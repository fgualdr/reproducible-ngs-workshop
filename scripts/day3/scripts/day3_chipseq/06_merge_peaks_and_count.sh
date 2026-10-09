#!/usr/bin/env bash
set -euo pipefail

peak_dir="results/day3_chipseq/peaks/no_input"
bam_dir="results/day3_chipseq/bam"
consensus_dir="results/day3_chipseq/peaks/consensus"
count_dir="results/day3_chipseq/counts"

mkdir -p "${consensus_dir}" "${count_dir}"

consensus_bed="${consensus_dir}/consensus_peaks.bed"
count_table="${count_dir}/consensus_peak_counts.tsv"

cat "${peak_dir}"/*_peaks.narrowPeak \
  | sort -k1,1 -k2,2n \
  | bedtools merge \
  > "${consensus_bed}"

cp "${consensus_bed}" "${consensus_dir}/day4_consensus_peaks.bed"

bam_files=("${bam_dir}"/*.filtered.bam)

{
  printf "chrom\tstart\tend"

  for bam in "${bam_files[@]}"
  do
    sample=$(basename "${bam}" .filtered.bam)
    printf "\t%s" "${sample}"
  done

  printf "\n"

  bedtools multicov \
    -bams "${bam_files[@]}" \
    -bed "${consensus_bed}"
} > "${count_table}"
