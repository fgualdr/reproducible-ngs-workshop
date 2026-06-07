#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("Usage: 02_integrate_deg_and_peaks.R deseq2_results.tsv peak_gene.tsv output.tsv")
de <- read.delim(args[[1]], check.names = FALSE)
pg <- read.delim(args[[2]], check.names = FALSE)
gene_col <- if ("gene_id" %in% names(de)) "gene_id" else names(de)[1]
merged <- merge(de, pg, by.x = gene_col, by.y = "nearest_gene_id", all.x = FALSE, all.y = FALSE)
merged$candidate_direct <- !is.na(merged$padj) & merged$padj < 0.1 & abs(merged$log2FoldChange) >= 1 & merged$distance <= 500
dir.create(dirname(args[[3]]), recursive = TRUE, showWarnings = FALSE)
write.table(merged, args[[3]], sep = "\t", quote = FALSE, row.names = FALSE)

