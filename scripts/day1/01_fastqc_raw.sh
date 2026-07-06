#!/usr/bin/env bash
set -euo pipefail

fastq_dir="raw_data/fastq"
out_dir="results/day1_qc/fastqc_raw"

mkdir -p "${out_dir}/rnaseq" "${out_dir}/chipseq"

for assay in rnaseq chipseq
do
  for f in "${fastq_dir}/${assay}"/*.fastq.gz
  do
    [[ -e "${f}" ]] || continue
    echo "Running FastQC on ${f}"
    fastqc \
      --threads 2 \
      --outdir "${out_dir}/${assay}" \
      "${f}"
  done
done
