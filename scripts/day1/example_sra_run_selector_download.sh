#!/usr/bin/env bash
set -euo pipefail

csv_file="raw_data/metadata/SraRunTable.csv"
out_dir="raw_data/fastq/sra_example"

mkdir -p "${out_dir}"

if [[ ! -f "${csv_file}" ]]; then
  echo "ERROR: CSV file not found: ${csv_file}" >&2
  exit 1
fi

tail -n +2 "${csv_file}" | cut -d, -f1 | tr -d '\r' |
while read -r run_accession
do
  [[ -n "${run_accession}" ]] || continue

  echo "Downloading ${run_accession}"
  fasterq-dump "${run_accession}" \
    --split-files \
    --threads 2 \
    --outdir "${out_dir}"

  gzip -f "${out_dir}/${run_accession}"*.fastq
done
