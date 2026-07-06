#!/usr/bin/env bash
set -euo pipefail

annotation="reference_genome/annotation.gff3"
bam_dir="results/day2_rnaseq/bam"
counts_dir="results/day2_rnaseq/counts"
log_dir="results/logs/day2"

mkdir -p "${counts_dir}" "${log_dir}"

if [[ ! -f "${annotation}" ]]; then
  echo "ERROR: annotation file not found: ${annotation}" >&2
  exit 1
fi

for bam in "${bam_dir}"/*.filtered.bam
do
  [[ -e "${bam}" ]] || continue
  sample_id="$(basename "${bam}" .filtered.bam)"

  echo "Counting ${sample_id}"
  featureCounts \
    -T 2 \
    -p \
    -B \
    -C \
    -a "${annotation}" \
    -o "${counts_dir}/${sample_id}.featureCounts.txt" \
    "${bam}" \
    2>&1 | tee "${log_dir}/${sample_id}.featureCounts.log"
done
