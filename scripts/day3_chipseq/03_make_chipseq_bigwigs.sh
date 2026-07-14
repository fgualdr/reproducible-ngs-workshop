#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/bigwig"
log_dir="results/logs/day3"
THREADS="${THREADS:-2}"

mkdir -p "${out_dir}" "${log_dir}"

bam_files=("${bam_dir}"/*.filtered.bam)

if [[ ! -e "${bam_files[0]}" ]]; then
  echo "ERROR: No filtered BAM files found in ${bam_dir}" >&2
  exit 1
fi

for bam in "${bam_files[@]}"
do
  sample_id="$(basename "${bam}" .filtered.bam)"

  bamCoverage \
    -b "${bam}" \
    -o "${out_dir}/${sample_id}.cpm.bw" \
    --normalizeUsing CPM \
    --binSize 10 \
    --numberOfProcessors "${THREADS}" \
    2>&1 | tee "${log_dir}/${sample_id}.bamCoverage.log"
done
