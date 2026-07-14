#!/usr/bin/env bash
set -euo pipefail

genome="reference_genome/genome.fa"
peak_file="results/day3_chipseq/peaks/consensus/day4_consensus_peaks.bed"
out_dir="results/day3_chipseq/motifs"
log_dir="results/logs/day3"
out_fasta="${out_dir}/day4_consensus_peak_sequences.fa"

mkdir -p "${out_dir}" "${log_dir}"

if [[ ! -f "${genome}" ]]; then
  echo "ERROR: genome FASTA not found: ${genome}" >&2
  exit 1
fi

if [[ ! -f "${peak_file}" ]]; then
  echo "ERROR: Day 4 consensus peak set not found: ${peak_file}" >&2
  exit 1
fi

echo "Extracting consensus peak sequences" | tee "${log_dir}/extract_peak_sequences.log"
bedtools getfasta \
  -fi "${genome}" \
  -bed "${peak_file}" \
  -fo "${out_fasta}" \
  2>&1 | tee -a "${log_dir}/extract_peak_sequences.log"

echo "Wrote ${out_fasta}" | tee -a "${log_dir}/extract_peak_sequences.log"
