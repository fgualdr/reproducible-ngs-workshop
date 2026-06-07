#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) stop("Usage: 04_make_final_tables.R deg_peak_links.tsv outdir")
links <- read.delim(args[[1]], check.names = FALSE)
outdir <- args[[2]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
candidate <- links[isTRUE(links$candidate_direct) | (!is.na(links$candidate_direct) & links$candidate_direct), , drop = FALSE]
write.table(candidate, file.path(outdir, "candidate_direct_targets.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

