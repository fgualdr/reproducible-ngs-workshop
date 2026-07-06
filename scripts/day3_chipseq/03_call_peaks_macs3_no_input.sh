#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/peaks/no_input"
genome_size="1.7e6"

mkdir -p "${out_dir}"

for bam in "${bam_dir}"/*.filtered.bam
do
  [[ -e "${bam}" ]] || continue
  sample_id="$(basename "${bam}" .filtered.bam)"

  macs3 callpeak \
    -t "${bam}" \
    -f BAM \
    -g "${genome_size}" \
    -n "${sample_id}" \
    --outdir "${out_dir}" \
    --keep-dup all
done
