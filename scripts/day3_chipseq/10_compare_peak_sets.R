#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("Usage: 10_compare_peak_sets.R no_input_dir with_input_dir outdir")
required <- c("GenomicRanges", "rtracklayer")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Missing R packages: ", paste(missing, collapse = ", "))
outdir <- args[[3]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
read_peaks <- function(dir) {
  files <- list.files(dir, pattern = "narrowPeak$", full.names = TRUE)
  if (!length(files)) return(NULL)
  do.call(c, lapply(files, rtracklayer::import, format = "BED"))
}
no_input <- read_peaks(args[[1]])
with_input <- read_peaks(args[[2]])
summary <- data.frame(
  set = c("no_input", "with_input"),
  n_peaks = c(if (is.null(no_input)) 0 else length(no_input), if (is.null(with_input)) 0 else length(with_input))
)
write.table(summary, file.path(outdir, "peak_set_summary.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)

