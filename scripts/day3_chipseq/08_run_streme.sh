#!/usr/bin/env bash
set -euo pipefail

fasta_dir="results/day3_chipseq/motifs"
out_dir="results/day3_chipseq/motifs/streme"
log_dir="results/logs/day3"

mkdir -p "${out_dir}" "${log_dir}"

fasta_files=("${fasta_dir}"/*_peak_sequences.fa)

if [[ ! -e "${fasta_files[0]}" ]]; then
  echo "ERROR: No peak-sequence FASTA files found in ${fasta_dir}" >&2
  exit 1
fi

for fasta in "${fasta_files[@]}"
do
  sample="$(basename "${fasta}" _peak_sequences.fa)"

  echo "Running STREME for ${sample}"
  streme \
    --p "${fasta}" \
    --dna \
    --oc "${out_dir}/${sample}" \
    2>&1 | tee "${log_dir}/${sample}.streme.log"
done
