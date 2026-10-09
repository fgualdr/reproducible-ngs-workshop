#!/usr/bin/env Rscript

library(DESeq2)
library(ggplot2)

count_file <- "results/day3_chipseq/counts/consensus_peak_counts.tsv"
out_dir <- "results/day3_chipseq/differential_peaks"

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

keep <- rowSums(peak_counts) >= 10
peak_counts <- peak_counts[keep, , drop = FALSE]

dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = peak_counts,
  colData = design_dt,
  design = ~ conditions
)

dds <- DESeq2::DESeq(dds)

print(DESeq2::resultsNames(dds))

res <- DESeq2::results(
  dds,
  contrast = c("conditions", "stressed", "control")
)

print(summary(res))

res_dt <- as.data.frame(res)
res_dt$peak_id <- rownames(res_dt)
res_dt <- res_dt[, c("peak_id", setdiff(colnames(res_dt), "peak_id"))]

coords <- peak_table[
  match(res_dt$peak_id, peak_table$peak_id),
  c("chrom", "start", "end")
]

res_dt <- cbind(coords, res_dt)

is_sig <- !is.na(res_dt$padj) &
  res_dt$padj < 0.05 &
  abs(res_dt$log2FoldChange) >= 1

res_dt$significant <- is_sig

write.table(
  res_dt,
  file.path(out_dir, "differential_peak_results.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

ranked <- res_dt[!is.na(res_dt$padj), , drop = FALSE]
ranked <- ranked[
  order(ranked$padj, -abs(ranked$log2FoldChange)),
  , drop = FALSE
]

write.table(
  head(ranked, 20),
  file.path(out_dir, "top_differential_peaks.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

sig_dt <- res_dt[is_sig, , drop = FALSE]

write.table(
  sig_dt[, c("chrom", "start", "end", "peak_id")],
  file.path(out_dir, "significant_differential_peaks.bed"),
  sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE
)

write.csv(
  design_dt,
  file.path(out_dir, "sample_design.csv"),
  row.names = FALSE
)

pdf(file.path(out_dir, "dispersion_plot.pdf"))
DESeq2::plotDispEsts(dds)
dev.off()

pdf(file.path(out_dir, "ma_plot.pdf"), width = 7, height = 5)
DESeq2::plotMA(res, alpha = 0.05, ylim = c(-5, 5))
dev.off()

res_dt$minus_log10_padj <- -log10(
  pmax(res_dt$padj, .Machine$double.xmin)
)

volcano <- ggplot(res_dt, aes(log2FoldChange, minus_log10_padj)) +
  geom_point(alpha = 0.6, size = 1, na.rm = TRUE) +
  geom_vline(xintercept = c(-1, 1), linetype = 2) +
  geom_hline(yintercept = -log10(0.05), linetype = 2) +
  theme_bw() +
  labs(
    x = "log2 fold change (stressed / control)",
    y = "-log10 adjusted p-value"
  )

ggsave(file.path(out_dir, "volcano.pdf"), volcano, width = 6, height = 5)

writeLines(
  capture.output(sessionInfo()),
  file.path(out_dir, "sessionInfo.txt")
)
