#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
peak_dir="results/day3_chipseq/peaks/no_input"
out_dir="results/day3_chipseq/qc/frip"
summary_file="${out_dir}/frip_summary.tsv"

mkdir -p "${out_dir}"

printf 'file\tfeatureType\tpercent\tfeatureReadCount\ttotalReadCount\n' > "${summary_file}"

for bam in "${bam_dir}"/*.filtered.bam
do
  sample="$(basename "${bam}" .filtered.bam)"
  peaks="${peak_dir}/${sample}_peaks.narrowPeak"
  tmp="${out_dir}/${sample}.plotEnrichment.tsv"

  plotEnrichment \
    -b "${bam}" \
    --BED "${peaks}" \
    --labels "${sample}" \
    --regionLabels called_peaks \
    --extendReads \
    --samFlagInclude 64 \
    --numberOfProcessors 2 \
    --outRawCounts "${tmp}"

  tail -n +2 "${tmp}" >> "${summary_file}"
  rm -f "${tmp}"
done
