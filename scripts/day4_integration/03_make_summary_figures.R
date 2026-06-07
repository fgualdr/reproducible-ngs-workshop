#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("Usage: 03_make_summary_figures.R deseq2_dir integration_dir outdir")
outdir <- args[[3]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
links_file <- file.path(args[[2]], "deg_peak_links.tsv")
if (file.exists(links_file)) {
  links <- read.delim(links_file, check.names = FALSE)
  pdf(file.path(outdir, "peak_distance_histogram.pdf"))
  hist(links$distance, breaks = 30, xlab = "Distance to nearest gene (bp)", main = "Peak distance to nearest gene")
  dev.off()
}

