#!/usr/bin/env bash
set -euo pipefail

genome="reference_genome/genome.fa"
peak_dir="results/day3_chipseq/peaks/no_input"
out_dir="results/day3_chipseq/motifs"

mkdir -p "${out_dir}"

if [[ ! -f "${genome}" ]]; then
  echo "ERROR: genome FASTA not found: ${genome}" >&2
  exit 1
fi

for peak_file in "${peak_dir}"/*_peaks.narrowPeak
do
  [[ -f "${peak_file}" ]] || continue
  sample="$(basename "${peak_file}" _peaks.narrowPeak)"

  bedtools getfasta \
    -fi "${genome}" \
    -bed "${peak_file}" \
    -fo "${out_dir}/${sample}_peak_sequences.fa"
done
