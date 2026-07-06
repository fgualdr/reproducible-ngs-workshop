#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop("Usage: 04_merge_featurecounts.R counts_dir output.tsv")
}

counts_dir <- args[[1]]
output <- args[[2]]

files <- list.files(counts_dir, pattern = "[.]featureCounts[.]txt$", full.names = TRUE)
if (length(files) == 0) {
  stop("No featureCounts files found in ", counts_dir)
}

merged <- NULL

for (path in files) {
  x <- read.delim(path, comment.char = "#", check.names = FALSE)
  sample <- sub("[.]featureCounts[.]txt$", "", basename(path))
  one_sample <- x[, c("Geneid", ncol(x))]
  names(one_sample) <- c("gene_id", sample)

  if (is.null(merged)) {
    merged <- one_sample
  } else {
    merged <- merge(merged, one_sample, by = "gene_id", all = TRUE)
  }
}

dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
write.table(merged, output, sep = "\t", quote = FALSE, row.names = FALSE)
