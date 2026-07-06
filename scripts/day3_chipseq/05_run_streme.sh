#!/usr/bin/env bash
set -euo pipefail

fasta_dir="results/day3_chipseq/motifs"
out_dir="results/day3_chipseq/motifs/streme"

mkdir -p "${out_dir}"

for fasta in "${fasta_dir}"/*_peak_sequences.fa
do
  [[ -f "${fasta}" ]] || continue
  sample="$(basename "${fasta}" _peak_sequences.fa)"

  streme \
    --p "${fasta}" \
    --dna \
    --oc "${out_dir}/${sample}"
done
