#!/usr/bin/env bash
set -euo pipefail

peak_dir="results/day3_chipseq/peaks/no_input"
out_dir="results/day3_chipseq/idr"
log_dir="results/logs/day3"

mkdir -p "${out_dir}" "${log_dir}"

pairs=(
  "WT_1:WT_2"
  "WT_1:WT_3"
  "WT_2:WT_3"
  "WTS_1:WTS_2"
  "WTS_1:WTS_3"
  "WTS_2:WTS_3"
)

for pair in "${pairs[@]}"
do
  sample1="${pair%%:*}"
  sample2="${pair##*:}"
  prefix="${sample1}_vs_${sample2}"

  idr \
    --samples \
      "${peak_dir}/${sample1}_peaks.narrowPeak" \
      "${peak_dir}/${sample2}_peaks.narrowPeak" \
    --input-file-type narrowPeak \
    --rank p.value \
    --idr-threshold 0.05 \
    --use-best-multisummit-IDR \
    --plot \
    --output-file "${out_dir}/${prefix}.idr.narrowPeak" \
    --log-output-file "${log_dir}/${prefix}.idr.log"
done
