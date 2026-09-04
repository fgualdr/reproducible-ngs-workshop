library(DESeq2)
library(ggplot2)

counts_file <- "results/day2_rnaseq/counts/featureCounts_all_samples.txt"
metadata_file <- "raw_data/metadata/samples.csv"
out_dir <- "results/day2_rnaseq/deseq2"
count_matrix_file <- file.path(dirname(counts_file), "gene_count_matrix.tsv")

featurecounts <- read.delim(
  counts_file,
  comment.char = "#",
  check.names = FALSE
)
metadata <- read.csv(metadata_file, stringsAsFactors = FALSE, check.names = FALSE)

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

print(dim(featurecounts))
print(head(featurecounts))
print(metadata)

counts <- featurecounts[, -c(2:6), drop = FALSE]
names(counts)[1] <- "gene_id"
names(counts)[-1] <- sub(
  "[.]filtered[.]bam$",
  "",
  basename(names(counts)[-1])
)

write.table(
  counts,
  count_matrix_file,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)

print(dim(counts))
print(head(counts))

required_columns <- c("sample_id", "assay", "condition", "replicate", "read1")
if (!all(required_columns %in% names(metadata))) {
  stop("Metadata is missing required columns")
}
if (!"gene_id" %in% names(counts)) stop("Count matrix requires a gene_id column")

metadata <- metadata[metadata$assay == "rnaseq", , drop = FALSE]
metadata$analysis_id <- sub("_R1[.]fastq[.]gz$", "", basename(metadata$read1))
sample_ids <- setdiff(names(counts), "gene_id")
metadata <- metadata[match(sample_ids, metadata$analysis_id), , drop = FALSE]
if (anyNA(metadata$sample_id)) stop("Count-matrix columns do not match the metadata")
if (anyDuplicated(metadata$analysis_id)) stop("RNA-seq analysis_id values must be unique")

rownames(metadata) <- metadata$analysis_id
metadata$condition <- factor(metadata$condition, levels = c("condition_A", "condition_B"))
if (anyNA(metadata$condition)) stop("Conditions must be condition_A and condition_B")

print(metadata[, c("analysis_id", "sample_id", "condition", "replicate")])
print(table(metadata$condition))
print(identical(sample_ids, rownames(metadata)))

rownames(counts) <- counts$gene_id
count_mat <- as.matrix(counts[, sample_ids, drop = FALSE])
storage.mode(count_mat) <- "integer"
if (anyNA(count_mat) || any(count_mat < 0)) stop("Counts must be non-negative integers")

print(dim(count_mat))
print(head(count_mat))
print(identical(colnames(count_mat), rownames(metadata)))

dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = count_mat,
  colData = metadata[, c("sample_id", "condition", "replicate"), drop = FALSE],
  design = ~ condition
)

print(dds)

keep <- rowSums(DESeq2::counts(dds)) >= 10
print(table(keep))
dds <- dds[keep, ]

dds <- DESeq2::DESeq(dds)

print(DESeq2::sizeFactors(dds))
print(DESeq2::resultsNames(dds))

res <- DESeq2::results(
  dds,
  contrast = c("condition", "condition_B", "condition_A")
)

print(summary(res))

res_table <- as.data.frame(res)
res_table$gene_id <- rownames(res_table)
res_table <- res_table[, c("gene_id", setdiff(names(res_table), "gene_id"))]

top <- res_table[!is.na(res_table$padj), , drop = FALSE]
top <- top[order(top$padj, -abs(top$log2FoldChange)), , drop = FALSE]

print(head(
  top[, c("gene_id", "baseMean", "log2FoldChange", "lfcSE", "padj")],
  20
))

write.csv(metadata[, c("analysis_id", "sample_id", "condition", "replicate")],
          file.path(out_dir, "sample_design.csv"), row.names = FALSE)
write.table(res_table, file.path(out_dir, "deseq2_results.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
write.table(head(top, 20), file.path(out_dir, "top_deg.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)

vsd <- DESeq2::vst(dds, blind = TRUE)

pdf(file.path(out_dir, "pca.pdf"))
print(DESeq2::plotPCA(vsd, intgroup = "condition"))
dev.off()

pdf(file.path(out_dir, "dispersion_plot.pdf"))
DESeq2::plotDispEsts(dds)
dev.off()

pdf(file.path(out_dir, "ma_plot.pdf"))
DESeq2::plotMA(res)
dev.off()

res_table$minus_log10_padj <- -log10(
  pmax(res_table$padj, .Machine$double.xmin)
)

volcano <- ggplot2::ggplot(
  res_table,
  ggplot2::aes(x = log2FoldChange, y = minus_log10_padj)
) +
  ggplot2::geom_point(alpha = 0.6, size = 1, na.rm = TRUE) +
  ggplot2::theme_bw() +
  ggplot2::labs(
    x = "log2 fold change (condition_B / condition_A)",
    y = "-log10 adjusted p-value"
  )

ggplot2::ggsave(
  file.path(out_dir, "volcano.pdf"),
  volcano,
  width = 6,
  height = 5
)

info <- sessionInfo()
print(info)
writeLines(capture.output(info), file.path(out_dir, "sessionInfo.txt"))

print(list.files(out_dir))
