#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("Usage: 08_deseq2_analysis.R samples.tsv count_matrix.tsv outdir")
required <- c("DESeq2", "ggplot2")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Missing R packages: ", paste(missing, collapse = ", "))
samples <- read.delim(args[[1]], check.names = FALSE)
counts <- read.delim(args[[2]], check.names = FALSE)
outdir <- args[[3]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
rownames(counts) <- counts$gene_id
counts$gene_id <- NULL
common <- intersect(samples$sample_id, names(counts))
if (length(common) < 2) stop("Fewer than two samples match count matrix columns")
samples <- samples[match(common, samples$sample_id), ]
count_mat <- as.matrix(round(counts[, common, drop = FALSE]))
dds <- DESeq2::DESeqDataSetFromMatrix(countData = count_mat, colData = samples, design = ~ condition)
dds <- DESeq2::DESeq(dds)
res <- as.data.frame(DESeq2::results(dds))
res$gene_id <- rownames(res)
write.table(res, file.path(outdir, "deseq2_results.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
vsd <- DESeq2::vst(dds, blind = TRUE)
pdf(file.path(outdir, "pca.pdf"))
print(DESeq2::plotPCA(vsd, intgroup = "condition"))
dev.off()
pdf(file.path(outdir, "ma_plot.pdf"))
DESeq2::plotMA(res)
dev.off()
pdf(file.path(outdir, "volcano.pdf"))
plot(res$log2FoldChange, -log10(res$padj), pch = 16, xlab = "log2 fold change", ylab = "-log10 adjusted p-value")
dev.off()
writeLines(capture.output(sessionInfo()), file.path(outdir, "sessionInfo.txt"))

