#!/usr/bin/env bash
set -euo pipefail

log_dir="results/logs/day2"
counts_dir="results/day2_rnaseq/counts"
qc_dir="results/day2_rnaseq/qc"

mkdir -p "${qc_dir}"

if [[ ! -d "${log_dir}" ]]; then
  echo "ERROR: Day 2 log directory not found: ${log_dir}" >&2
  exit 1
fi

if ! compgen -G "${log_dir}/*" > /dev/null; then
  echo "ERROR: No Day 2 logs found in ${log_dir}" >&2
  exit 1
fi

multiqc \
  "${log_dir}" \
  "${counts_dir}" \
  --outdir "${qc_dir}" \
  --filename multiqc_report.html \
  --force
