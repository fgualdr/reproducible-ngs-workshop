#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) stop("Usage: 01_peak_gene_annotation.R peak_dir annotation.gff3 output.tsv")
required <- c("GenomicRanges", "rtracklayer")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Missing R packages: ", paste(missing, collapse = ", "))
peak_files <- list.files(args[[1]], pattern = "narrowPeak$|bed$", full.names = TRUE)
if (!length(peak_files)) stop("No peak files found")
peaks <- do.call(c, lapply(peak_files, rtracklayer::import))
annotation <- rtracklayer::import(args[[2]])
genes <- annotation[annotation$type %in% c("gene", "CDS")]
nearest <- GenomicRanges::nearest(peaks, genes)
out <- data.frame(
  peak_seqnames = as.character(GenomicRanges::seqnames(peaks)),
  peak_start = GenomicRanges::start(peaks),
  peak_end = GenomicRanges::end(peaks),
  nearest_gene_id = mcols(genes)$ID[nearest],
  distance = GenomicRanges::distance(peaks, genes[nearest])
)
dir.create(dirname(args[[3]]), recursive = TRUE, showWarnings = FALSE)
write.table(out, args[[3]], sep = "\t", quote = FALSE, row.names = FALSE)

