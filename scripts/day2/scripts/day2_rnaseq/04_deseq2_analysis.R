#!/usr/bin/env Rscript

library(DESeq2)
library(ggplot2)
library(ggrepel)

count_file <- "results/day2_rnaseq/counts/featureCounts_all_samples.txt"
out_dir <- "results/day2_rnaseq/deseq2"
count_matrix_file <- "results/day2_rnaseq/counts/gene_count_matrix.tsv"

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# -------------------------------------------------------------------------
# Import featureCounts output and prepare the raw count matrix
# -------------------------------------------------------------------------

featureCounts <- read.delim(count_file, sep = "\t", comment.char = "#", check.names = FALSE)

colnames(featureCounts) <- gsub("results/day2_rnaseq/bam/", "", colnames(featureCounts), fixed = TRUE)
colnames(featureCounts) <- gsub(".filtered.bam", "", colnames(featureCounts), fixed = TRUE)
rownames(featureCounts) <- featureCounts$Geneid

# Keep only sample-count columns
featureCounts <- featureCounts[,grep("^WT",colnames(featureCounts))]
# -------------------------------------------------------------------------
# Build the sample design
# -------------------------------------------------------------------------

design_dt <- data.frame(
    samples = colnames(featureCounts),
    conditions = gsub("_1|_2|_3","",colnames(featureCounts)),
    replicates = gsub("WT_","",gsub("WTS_","",colnames(featureCounts)))
)

design_dt$conditions[design_dt$conditions == "WT"] <- "control"
design_dt$conditions[design_dt$conditions == "WTS"] <- "treated"
design_dt$conditions <- factor(design_dt$conditions, levels = c("control", "treated"))

rownames(design_dt) <- design_dt$samples

# Put the design rows in exactly the same order as the count columns
design_dt <- design_dt[colnames(featureCounts), , drop = FALSE]
featureCounts <- featureCounts[, rownames(design_dt), drop = FALSE]

# Save the clean raw count matrix
count_out <- data.frame(gene_id = rownames(featureCounts), featureCounts, check.names = FALSE)
write.table(count_out, count_matrix_file, sep = "\t", quote = FALSE, row.names = FALSE)

# -------------------------------------------------------------------------
# Create the DESeq2 dataset
# -------------------------------------------------------------------------

dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = as.matrix(featureCounts),
  colData = design_dt,
  design = ~ conditions
)

# inspect the content using attributes(dds)!

# -------------------------------------------------------------------------
# Estimate library-size factors BEFORE fitting the full model
# -------------------------------------------------------------------------

dds <- DESeq2::estimateSizeFactors(dds)

# -------------------------------------------------------------------------
# PCA on log2-normalized counts: inspect sample relationships and outliers
# Before diving into DEGs we check if the expected biological perturbation is the main driver of the variation in the experiment!
# Use PCA
# -------------------------------------------------------------------------
normalized_counts <- DESeq2::counts(dds, normalized = TRUE)
pca_input <- log2(normalized_counts+1) 
# Here there are different ways to treat the count data before PCA!
# log, scale, center, center+scale, Yeo-Johnson, Box-Cox, Quantile, etc...

pca <- prcomp(
  t(pca_input),
  center = TRUE,
  scale. = FALSE
)

variance_explained <- 100 * (pca$sdev^2 / sum(pca$sdev^2))

pca_dt <- data.frame(
  sample = rownames(pca$x),
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2],
  conditions = design_dt[rownames(pca$x), "conditions"],
  replicates = design_dt[rownames(pca$x), "replicates"]
)

pca_plot <- ggplot(pca_dt, aes(x=PC1, y=PC2, color = conditions, shape = replicates, label = sample)) +
  geom_point(size = 3) +
  ggrepel::geom_text_repel(show.legend = FALSE) +
  theme_bw() +
  labs(
    x = sprintf("PC1 (%.1f%%)", variance_explained[1]),
    y = sprintf("PC2 (%.1f%%)", variance_explained[2])
  )

ggsave(file.path(out_dir, "pc1_pc2_pca.pdf"), pca_plot, width = 6, height = 5)

scree_dt <- data.frame(
  PC = seq_along(variance_explained),
  variance = variance_explained
)

scree_plot <- ggplot(scree_dt, aes(x=PC, y=variance)) +
  geom_col() +
  scale_x_continuous(breaks = scree_dt$PC) +
  theme_bw() +
  labs(x = "Principal component", y = "Variance explained (%)")

ggsave(file.path(out_dir, "pca_scree.pdf"), scree_plot, width = 6, height = 4)

# -------------------------------------------------------------------------
# Fit the DESeq2 model and extract treated versus control
# -------------------------------------------------------------------------

dds <- DESeq2::DESeq(dds, fitType = "parametric")

print(DESeq2::resultsNames(dds))

res2 <- DESeq2::results(
  dds,
  contrast = c("conditions", "treated", "control") # treated vs control so control is the denominator!
)

res_dt <- as.data.frame(res2)
res_dt$gene_id <- rownames(res_dt)

write.table(
  res_dt, 
  file.path(out_dir, "deseq2_results.tsv"),
  sep = "\t", 
  quote = FALSE, 
  row.names = FALSE
  )

ranked <- res_dt[!is.na(res_dt$padj), , drop = FALSE]

ranked <- ranked[order(ranked$padj, abs(ranked$log2FoldChange)), , drop = FALSE]

normalized_counts <- DESeq2::counts(dds, normalized = TRUE)

l <- list()
for(cond in unique(design_dt$conditions)){
  idx <- which(
    colnames(normalized_counts)  %in% rownames(design_dt[design_dt$conditions == cond,])
    )
  a <- normalized_counts[, idx]
  a <- rowMeans(a)
  l[[cond]] <- a
}
av_l <- as.data.frame(do.call(cbind,l))
av_l <- av_l[,c("control","treated")]

ranked <- cbind(ranked,av_l[rownames(ranked),])

# -------------------------------------------------------------------------
# Dispersion plot
# -------------------------------------------------------------------------

pdf(file.path(out_dir, "dispersion_plot.pdf"))
  DESeq2::plotDispEsts(dds)
dev.off()

# -------------------------------------------------------------------------
# Custom MA-like plot: mean expression versus log2 fold change
# -------------------------------------------------------------------------

# Use a signed significance score:
# significant down-regulated genes -> negative -> blue
# non-significant genes            -> 0        -> white
# significant up-regulated genes   -> positive -> red
res_dt$signed_significance <- 0
is_sig <- !is.na(res_dt$padj) & res_dt$padj < 0.05
res_dt$signed_significance[is_sig] <-
  sign(res_dt$log2FoldChange[is_sig]) * -log10(pmax(res_dt$padj[is_sig], .Machine$double.xmin))

sig_dt <- res_dt[is_sig, , drop = FALSE]

top_up <- sig_dt[sig_dt$log2FoldChange > 0, , drop = FALSE]
top_up <- head(top_up[order(top_up$padj, -top_up$log2FoldChange), , drop = FALSE], 5)

top_down <- sig_dt[sig_dt$log2FoldChange < 0, , drop = FALSE]
top_down <- head(top_down[order(top_down$padj, top_down$log2FoldChange), , drop = FALSE], 5)

label_dt <- rbind(top_up, top_down)

ma_plot <- ggplot(res_dt, aes(baseMean + 1, log2FoldChange, color = signed_significance)) +
  geom_point(alpha = 0.9, size = 1, na.rm = TRUE) +
  geom_hline(yintercept = 0, linetype = 2) +
  scale_x_log10() +
  scale_color_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    midpoint = 0,
    name = "signed\n-log10(padj)"
  ) +
  ggrepel::geom_text_repel(
    data = label_dt,
    aes(label = gene_id),
    size = 3,
    max.overlaps = Inf,
    show.legend = FALSE
  ) +
  theme_bw() +
  labs(
    x = "Mean normalized expression (baseMean + 1, log10 scale)",
    y = "log2 fold change (treated / control)"
  )

ggsave(file.path(out_dir, "ma_plot.pdf"), ma_plot, width = 7, height = 5)

# -------------------------------------------------------------------------
# Volcano plot
# -------------------------------------------------------------------------

res_dt$minus_log10_padj <- -log10(pmax(res_dt$padj, .Machine$double.xmin))

volcano <- ggplot(res_dt, aes(log2FoldChange, minus_log10_padj)) +
  geom_point(alpha = 0.6, size = 1, na.rm = TRUE) +
  theme_bw() +
  labs(
    x = "log2 fold change (treated / control)",
    y = "-log10 adjusted p-value"
  )

ggsave(file.path(out_dir, "volcano.pdf"), volcano, width = 6, height = 5)

writeLines(capture.output(sessionInfo()), file.path(out_dir, "sessionInfo.txt"))

# -------------------------------------------------------------------------
# We will save usefull data for the generation of scaled Tracks!
# -------------------------------------------------------------------------

size_factors <- DESeq2::sizeFactors(dds)
normalized_counts <- DESeq2::counts(dds, normalized = TRUE)
normalized_out <- data.frame(gene_id = rownames(normalized_counts), normalized_counts, check.names = FALSE)

write.table(
  normalized_out, 
  file.path(out_dir, "normalized_counts.tsv"),
  sep = "\t", 
  quote = FALSE, 
  row.names = FALSE
  )

# DESeq2 divides counts by the size factor.
# Later we will use bamCoverage to create BigWig tracks
# bamCoverage  multiplies coverage by --scaleFactor.
# Therefore the matching bamCoverage factor is 1 / DESeq2 size factor.
scale_dt <- data.frame(
  sample = names(size_factors),
  deseq2_size_factor = as.numeric(size_factors),
  bamcoverage_scale_factor = 1 / as.numeric(size_factors) 
  # this as Deseq2 divide so scales down to the lower. BamCoverage used for BigWig generation instead uses multiplicative scaling
)

write.table(scale_dt, file.path(out_dir, "deseq2_size_factors.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)

print(scale_dt)
