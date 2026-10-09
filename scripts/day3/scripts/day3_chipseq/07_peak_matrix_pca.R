#!/usr/bin/env Rscript

library(DESeq2)
library(ggplot2)
library(ggrepel)

count_file <- "results/day3_chipseq/counts/consensus_peak_counts.tsv"
out_dir <- "results/day3_chipseq/qc/peak_counts"

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

peak_table <- read.delim(count_file, header = TRUE, check.names = FALSE)
samples <- colnames(peak_table)[4:ncol(peak_table)]

peak_table$peak_id <- paste0(
  peak_table$chrom, ":", peak_table$start, "-", peak_table$end
)

peak_counts <- as.matrix(peak_table[, samples, drop = FALSE])
rownames(peak_counts) <- peak_table$peak_id
storage.mode(peak_counts) <- "integer"

design_dt <- data.frame(
  samples = colnames(peak_counts),
  replicates = sub("^WTS?_", "", colnames(peak_counts)),
  conditions = sub("_[123]$", "", colnames(peak_counts))
)

design_dt$conditions[design_dt$conditions == "WT"] <- "control"
design_dt$conditions[design_dt$conditions == "WTS"] <- "stressed"
design_dt$conditions <- factor(
  design_dt$conditions,
  levels = c("control", "stressed")
)
design_dt$replicates <- factor(design_dt$replicates)
rownames(design_dt) <- design_dt$samples

peak_counts <- peak_counts[rowSums(peak_counts) >= 10, , drop = FALSE]

dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = peak_counts,
  colData = design_dt,
  design = ~ conditions
)

dds <- DESeq2::estimateSizeFactors(dds)
normalized_counts <- DESeq2::counts(dds, normalized = TRUE)

write.table(
  data.frame(peak_id = rownames(normalized_counts), normalized_counts, check.names = FALSE),
  file.path(out_dir, "normalized_peak_counts.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

size_dt <- data.frame(
  sample = names(DESeq2::sizeFactors(dds)),
  deseq2_size_factor = as.numeric(DESeq2::sizeFactors(dds))
)

write.table(
  size_dt,
  file.path(out_dir, "deseq2_size_factors.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

pca_input <- log2(normalized_counts + 1)
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

pca_plot <- ggplot(
  pca_dt,
  aes(PC1, PC2, color = conditions, shape = replicates, label = sample)
) +
  geom_point(size = 3) +
  ggrepel::geom_text_repel(show.legend = FALSE) +
  theme_bw() +
  labs(
    x = sprintf("PC1 (%.1f%%)", variance_explained[1]),
    y = sprintf("PC2 (%.1f%%)", variance_explained[2])
  )

ggsave(file.path(out_dir, "pca.pdf"), pca_plot, width = 6, height = 5)

scree_dt <- data.frame(
  PC = seq_along(variance_explained),
  variance = variance_explained
)

scree_plot <- ggplot(scree_dt, aes(PC, variance)) +
  geom_col() +
  scale_x_continuous(breaks = scree_dt$PC) +
  theme_bw() +
  labs(x = "Principal component", y = "Variance explained (%)")

ggsave(file.path(out_dir, "pca_scree.pdf"), scree_plot, width = 6, height = 4)
