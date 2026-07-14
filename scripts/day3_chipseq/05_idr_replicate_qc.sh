#!/usr/bin/env bash
set -euo pipefail

peak_dir="results/day3_chipseq/peaks/no_input"
out_dir="results/day3_chipseq/idr"
log_dir="results/logs/day3"

mkdir -p "${out_dir}" "${log_dir}"

peak_files=("${peak_dir}"/*_peaks.narrowPeak)

if [[ ! -e "${peak_files[0]}" ]]; then
  echo "ERROR: No MACS3 narrowPeak files found in ${peak_dir}" >&2
  exit 1
fi

found_pair=0

for rep1_peak in "${peak_dir}"/*_1_*_peaks.narrowPeak
do
  [[ -e "${rep1_peak}" ]] || continue

  sample1="$(basename "${rep1_peak}" _peaks.narrowPeak)"
  prefix="${sample1%%_1_*}"
  condition="${sample1#${prefix}_1_}"
  sample2="${prefix}_2_${condition}"
  rep2_peak="${peak_dir}/${sample2}_peaks.narrowPeak"

  if [[ ! -f "${rep2_peak}" ]]; then
    echo "Skipping ${condition}: expected replicate peak file not found: ${rep2_peak}" >&2
    continue
  fi

  found_pair=1
  echo "Running IDR for ${condition}: ${sample1} versus ${sample2}"
  idr \
    --samples "${rep1_peak}" "${rep2_peak}" \
    --input-file-type narrowPeak \
    --rank p.value \
    --idr-threshold 0.05 \
    --output-file "${out_dir}/${condition}.idr.narrowPeak" \
    --plot \
    --log-output-file "${log_dir}/${condition}.idr.log"
done

if [[ "${found_pair}" -eq 0 ]]; then
  echo "ERROR: No replicate 1/2 peak pairs found in ${peak_dir}" >&2
  exit 1
fi
