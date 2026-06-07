#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) stop("Usage: 06_merge_featurecounts.R counts_dir output.tsv")
counts_dir <- args[[1]]
output <- args[[2]]
files <- list.files(counts_dir, pattern = "featureCounts.txt$", full.names = TRUE)
if (!length(files)) stop("No featureCounts files found")
read_one <- function(path) {
  x <- read.delim(path, comment.char = "#", check.names = FALSE)
  sample <- sub("\\.featureCounts\\.txt$", "", basename(path))
  out <- x[, c("Geneid", ncol(x))]
  names(out) <- c("gene_id", sample)
  out
}
lst <- lapply(files, read_one)
merged <- Reduce(function(a, b) merge(a, b, by = "gene_id", all = TRUE), lst)
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
write.table(merged, output, sep = "\t", quote = FALSE, row.names = FALSE)

