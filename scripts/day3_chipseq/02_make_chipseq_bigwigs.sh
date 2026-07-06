#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/bigwig"

mkdir -p "${out_dir}"

for bam in "${bam_dir}"/*.filtered.bam
do
  [[ -e "${bam}" ]] || continue
  sample_id="$(basename "${bam}" .filtered.bam)"

  bamCoverage \
    -b "${bam}" \
    -o "${out_dir}/${sample_id}.cpm.bw" \
    --normalizeUsing CPM \
    --binSize 10 \
    --numberOfProcessors 2
done
