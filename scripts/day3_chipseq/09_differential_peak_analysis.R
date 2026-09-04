#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
  stop("Usage: 09_differential_peak_analysis.R peak_counts.tsv samples.csv outdir")
}
if (!requireNamespace("DESeq2", quietly = TRUE)) stop("Missing R package: DESeq2")

peak_counts <- read.delim(args[[1]], check.names = FALSE)
metadata <- read.csv(args[[2]], stringsAsFactors = FALSE, check.names = FALSE)
outdir <- args[[3]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)

coordinate_columns <- c("chrom", "start", "end", "peak_id", "peak_record_count")
if (!all(coordinate_columns %in% names(peak_counts))) stop("Peak-count table has unexpected columns")
metadata <- metadata[metadata$assay == "chipseq", , drop = FALSE]
metadata$analysis_id <- sub("_R1[.]fastq[.]gz$", "", basename(metadata$read1))
sample_ids <- setdiff(names(peak_counts), coordinate_columns)
metadata <- metadata[match(sample_ids, metadata$analysis_id), , drop = FALSE]
if (anyNA(metadata$sample_id)) stop("Peak-count columns do not match ChIP-seq metadata")

metadata$condition <- factor(metadata$condition, levels = c("condition_A", "condition_B"))
if (anyNA(metadata$condition)) stop("Conditions must be condition_A and condition_B")
rownames(metadata) <- metadata$analysis_id

count_mat <- as.matrix(peak_counts[, sample_ids, drop = FALSE])
storage.mode(count_mat) <- "integer"
if (anyNA(count_mat) || any(count_mat < 0)) stop("Peak counts must be non-negative integers")
rownames(count_mat) <- peak_counts$peak_id

dds <- DESeq2::DESeqDataSetFromMatrix(
  countData = count_mat,
  colData = metadata[, c("sample_id", "condition", "replicate"), drop = FALSE],
  design = ~ condition
)
dds <- dds[rowSums(DESeq2::counts(dds)) >= 10, ]
dds <- DESeq2::DESeq(dds)
res <- as.data.frame(DESeq2::results(dds, contrast = c("condition", "condition_B", "condition_A")))
res$peak_id <- rownames(res)

coordinates <- peak_counts[, coordinate_columns]
out <- merge(coordinates, res, by = "peak_id", all.y = TRUE, sort = FALSE)
write.table(out, file.path(outdir, "differential_peak_results.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
writeLines(capture.output(sessionInfo()), file.path(outdir, "sessionInfo.txt"))
