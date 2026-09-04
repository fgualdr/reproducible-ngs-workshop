#!/usr/bin/env bash
set -euo pipefail

metadata="raw_data/metadata/selected_fastq_files.csv"
log_file="results/logs/day1/ena_download.log"

mkdir -p raw_data/fastq/rnaseq raw_data/fastq/chipseq results/logs/day1
: > "${log_file}"

for row in $(tail -n +2 "${metadata}" | tr -d '\r')
do
  IFS=, read -r assay fastq_name fastq_url <<< "${row}"

  echo "Downloading ${fastq_name}" | tee -a "${log_file}"
  curl -fL "${fastq_url}" -o "raw_data/fastq/${assay}/${fastq_name}"
done
