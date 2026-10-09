#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day2_rnaseq/bam"
out_dir="results/day2_rnaseq/bigwig"
log_dir="results/logs/day2"
scale_file="results/day2_rnaseq/deseq2/deseq2_size_factors.tsv"

mkdir -p "${out_dir}" "${log_dir}"


while IFS=$'\t' read -r sample deseq2_size_factor bamcoverage_scale_factor
do
  bam="${bam_dir}/${sample}.filtered.bam"

  echo "${sample}: DESeq2 size factor=${deseq2_size_factor}; bamCoverage scale factor=${bamcoverage_scale_factor}"

  bamCoverage \
    -b "${bam}" \
    -o "${out_dir}/${sample}.deseq2.bw" \
    --scaleFactor "${bamcoverage_scale_factor}" \
    --binSize 10 \
    --numberOfProcessors 2 \
    2>&1 | tee "${log_dir}/${sample}.bamCoverage.log"
done < <(tail -n +2 "${scale_file}")
