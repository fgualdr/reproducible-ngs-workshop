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

for group in WT WTS
do
  for pair in 1_2 1_3 2_3
  do
    replicate1="${pair%_*}"
    replicate2="${pair#*_}"
    sample1="${group}_${replicate1}"
    sample2="${group}_${replicate2}"
    rep1_peak="${peak_dir}/${sample1}_peaks.narrowPeak"
    rep2_peak="${peak_dir}/${sample2}_peaks.narrowPeak"

    if [[ ! -f "${rep1_peak}" || ! -f "${rep2_peak}" ]]; then
      echo "Skipping ${sample1} versus ${sample2}: peak file not found" >&2
      continue
    fi

    found_pair=1
    echo "Running IDR for ${sample1} versus ${sample2}"
    idr \
      --samples "${rep1_peak}" "${rep2_peak}" \
      --input-file-type narrowPeak \
      --rank p.value \
      --idr-threshold 0.05 \
      --output-file "${out_dir}/${sample1}_vs_${sample2}.idr.narrowPeak" \
      --plot \
      --log-output-file "${log_dir}/${sample1}_vs_${sample2}.idr.log"
  done
done

if [[ "${found_pair}" -eq 0 ]]; then
  echo "ERROR: No replicate peak pairs found in ${peak_dir}" >&2
  exit 1
fi
