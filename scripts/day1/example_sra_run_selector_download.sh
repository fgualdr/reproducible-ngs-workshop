#!/usr/bin/env bash
set -euo pipefail

csv_file="raw_data/metadata/sra_example.csv"
out_dir="raw_data/fastq/sra_example"

mkdir -p "${out_dir}"

for run_accession in $(tail -n +2 "${csv_file}")
do
  echo "Downloading ${run_accession}"
  fasterq-dump "${run_accession}" \
    --split-files \
    --threads 2 \
    --outdir "${out_dir}"

  gzip -f "${out_dir}/${run_accession}"*.fastq
done
