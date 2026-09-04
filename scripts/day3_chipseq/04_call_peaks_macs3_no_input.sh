#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/peaks/no_input"
log_dir="results/logs/day3"
genome_size="1696601"

mkdir -p "${out_dir}" "${log_dir}"

bam_files=("${bam_dir}"/*.filtered.bam)

if [[ ! -e "${bam_files[0]}" ]]; then
  echo "ERROR: No filtered BAM files found in ${bam_dir}" >&2
  exit 1
fi

for bam in "${bam_files[@]}"
do
  sample_id="$(basename "${bam}" .filtered.bam)"

  echo "Calling peaks for ${sample_id}"
  macs3 callpeak \
    -t "${bam}" \
    -f BAMPE \
    -g "${genome_size}" \
    -n "${sample_id}" \
    --outdir "${out_dir}" \
    --keep-dup all \
    2>&1 | tee "${log_dir}/${sample_id}.macs3.log"
done
