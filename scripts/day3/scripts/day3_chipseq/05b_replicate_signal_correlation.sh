#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/qc/replicate_correlation"

mkdir -p "${out_dir}"

bam_files=("${bam_dir}"/*.filtered.bam)

multiBamSummary bins \
  --bamfiles "${bam_files[@]}" \
  --smartLabels \
  --binSize 500 \
  --extendReads \
  --samFlagInclude 64 \
  --numberOfProcessors 2 \
  --outFileName "${out_dir}/binned_counts.npz" \
  --outRawCounts "${out_dir}/binned_counts.tsv"

plotCorrelation \
  -in "${out_dir}/binned_counts.npz" \
  --corMethod spearman \
  --skipZeros \
  --whatToPlot heatmap \
  --plotNumbers \
  --outFileCorMatrix "${out_dir}/spearman_correlation.tsv" \
  -o "${out_dir}/spearman_heatmap.pdf"

plotCorrelation \
  -in "${out_dir}/binned_counts.npz" \
  --corMethod spearman \
  --skipZeros \
  --whatToPlot scatterplot \
  --log1p \
  -o "${out_dir}/spearman_scatter.pdf"
