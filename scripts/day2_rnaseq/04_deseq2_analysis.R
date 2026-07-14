#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop("Usage: 04_deseq2_analysis.R count_matrix.tsv outdir")
}

required <- c("DESeq2", "ggplot2")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  stop("Missing R packages: ", paste(missing, collapse = ", "))
}

counts <- read.delim(args[[1]], check.names = FALSE)
outdir <- args[[2]]

dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

rownames(counts) <- counts$gene_id
counts$gene_id <- NULL

sample_ids <- names(counts)
if (length(sample_ids) < 4) {
  stop("Expected RNA-seq samples from at least two conditions with biological replicates")
}

condition <- sub("^[^_]+_[^_]+_", "", sample_ids)
replicate <- sub("^[^_]+_([^_]+)_.*$", "rep\\1", sample_ids)

samples <- data.frame(
  sample_id = sample_ids,
  condition = condition,
  replicate = replicate,
  row.names = sample_ids,
  check.names = FALSE
)

if (length(unique(samples$condition)) < 2) {
  stop("Could not infer at least two conditions from sample names")
}

if (all(c("WT_control", "WT_21Oxygen") %in% samples$condition)) {
  samples$condition <- factor(samples$condition, levels = c("WT_control", "WT_21Oxygen"))
} else {
  samples$condition <- factor(samples$condition)
}

count_mat <- as.matrix(round(counts[, sample_ids, drop = FALSE]))

dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = count_mat,
  colData = samples,
  design = ~ condition
)
dds <- dds[rowSums(DESeq2::counts(dds)) >= 10, ]
dds <- DESeq2::DESeq(dds)

if (all(c("WT_control", "WT_21Oxygen") %in% levels(samples$condition))) {
  res <- as.data.frame(DESeq2::results(dds, contrast = c("condition", "WT_21Oxygen", "WT_control")))
} else {
  res <- as.data.frame(DESeq2::results(dds))
}
res$gene_id <- rownames(res)
write.csv(samples, file.path(outdir, "inferred_sample_design.csv"), row.names = FALSE)
write.table(res, file.path(outdir, "deseq2_results.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

vsd <- DESeq2::vst(dds, blind = TRUE)

pdf(file.path(outdir, "pca.pdf"))
print(DESeq2::plotPCA(vsd, intgroup = "condition"))
dev.off()

pdf(file.path(outdir, "dispersion_plot.pdf"))
DESeq2::plotDispEsts(dds)
dev.off()

pdf(file.path(outdir, "ma_plot.pdf"))
DESeq2::plotMA(res)
dev.off()

volcano <- ggplot2::ggplot(res, ggplot2::aes(x = log2FoldChange, y = -log10(padj))) +
  ggplot2::geom_point(alpha = 0.6, size = 1) +
  ggplot2::theme_bw() +
  ggplot2::labs(x = "log2 fold change", y = "-log10 adjusted p-value")

ggplot2::ggsave(file.path(outdir, "volcano.pdf"), volcano, width = 6, height = 5)
writeLines(capture.output(sessionInfo()), file.path(outdir, "sessionInfo.txt"))
