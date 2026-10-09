#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
peak_dir="results/day3_chipseq/peaks/no_input"
log_dir="results/logs/day3"
genome_size="1696601"

mkdir -p "${peak_dir}" "${log_dir}"

for bam in "${bam_dir}"/*.filtered.bam
do
  sample_id="$(basename "${bam}" .filtered.bam)"

  macs3 callpeak \
    -t "${bam}" \
    -f BAMPE \
    -g "${genome_size}" \
    -n "${sample_id}" \
    --outdir "${peak_dir}" \
    --keep-dup all \
    --call-summits \
    --nolambda \
    > "${log_dir}/${sample_id}.macs3.log" 2>&1
done
