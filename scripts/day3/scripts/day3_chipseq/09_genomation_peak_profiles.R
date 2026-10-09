#!/usr/bin/env Rscript

library(genomation)
library(GenomicRanges)
library(rtracklayer)

peak_file <- "results/day3_chipseq/peaks/consensus/consensus_peaks.bed"
bigwig_dir <- "results/day3_chipseq/bigwig"
differential_file <- "results/day3_chipseq/differential_peaks/differential_peak_results.tsv"
out_dir <- "results/day3_chipseq/genomation"
genome_size <- 1696601L

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

peaks <- import(peak_file, format = "BED")

# rtracklayer converts BED starts from 0-based to 1-based coordinates.
# Reconstruct the same peak IDs used in the count table.
names(peaks) <- paste0(
  as.character(seqnames(peaks)), ":", start(peaks) - 1, "-", end(peaks)
)

centres <- resize(peaks, width = 1, fix = "center")
windows <- resize(centres, width = 1001, fix = "center")
windows <- windows[start(windows) >= 1 & end(windows) <= genome_size]

bigwigs <- sort(list.files(bigwig_dir, pattern = "\\.cpm\\.bw$", full.names = TRUE))
sample_names <- sub("\\.cpm\\.bw$", "", basename(bigwigs))

all_scores <- ScoreMatrixList(
  targets = bigwigs,
  windows = windows,
  type = "bigWig",
  strand.aware = FALSE,
  rpm = FALSE
)
names(all_scores) <- sample_names

pdf(file.path(out_dir, "all_peaks_metaplot.pdf"), width = 7, height = 5)
plotMeta(
  all_scores,
  overlay = TRUE,
  profile.names = sample_names,
  xcoords = -500:500,
  xlab = "Distance from merged peak centre (bp)",
  ylab = "Mean ChIP-seq signal (CPM)"
)
dev.off()

pdf(file.path(out_dir, "all_peaks_heatmaps.pdf"), width = 3 * length(bigwigs), height = 7)
multiHeatMatrix(
  all_scores,
  xcoords = c(-500, 500),
  order = TRUE,
  common.scale = TRUE,
  winsorize = c(0, 99),
  matrix.main = sample_names,
  legend.name = "CPM"
)
dev.off()

differential <- read.delim(differential_file)
changed <- differential[
  !is.na(differential$padj) &
    differential$padj < 0.05 &
    abs(differential$log2FoldChange) >= 1,
]

changed_windows <- windows[names(windows) %in% changed$peak_id]

if (length(changed_windows) > 0) {
  changed_scores <- ScoreMatrixList(
    targets = bigwigs,
    windows = changed_windows,
    type = "bigWig",
    strand.aware = FALSE,
    rpm = FALSE
  )
  names(changed_scores) <- sample_names

  pdf(file.path(out_dir, "differential_peaks_metaplot.pdf"), width = 7, height = 5)
  plotMeta(
    changed_scores,
    overlay = TRUE,
    profile.names = sample_names,
    xcoords = -500:500,
    xlab = "Distance from differential peak centre (bp)",
    ylab = "Mean ChIP-seq signal (CPM)"
  )
  dev.off()

  pdf(file.path(out_dir, "differential_peaks_heatmaps.pdf"), width = 3 * length(bigwigs), height = 7)
  multiHeatMatrix(
    changed_scores,
    xcoords = c(-500, 500),
    order = TRUE,
    common.scale = TRUE,
    winsorize = c(0, 99),
    matrix.main = sample_names,
    legend.name = "CPM"
  )
  dev.off()
}
