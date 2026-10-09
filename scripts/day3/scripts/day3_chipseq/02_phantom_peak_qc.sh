#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/qc/phantom_peak"
log_dir="results/logs/day3"
work_dir="$PWD"
summary_file="${out_dir}/phantom_peak_summary.tsv"

mkdir -p "${out_dir}" "${log_dir}"

printf 'filename\tnumReads\testFragLen\tcorr_estFragLen\tphantomPeak\tcorr_phantomPeak\targmin_corr\tmin_corr\tNSC\tRSC\tQualityTag\n' > "${summary_file}"

for bam in "${bam_dir}"/*.filtered.bam
do
  sample_id="$(basename "${bam}" .filtered.bam)"
  sample_dir="${out_dir}/${sample_id}"
  qc_file="${sample_dir}/${sample_id}.phantom_peak_qc.tsv"

  mkdir -p "${sample_dir}"
  rm -f "${qc_file}"

  Rscript "$(command -v run_spp.R)" \
    -c="${work_dir}/${bam}" \
    -p=2 \
    -savp \
    -rf \
    -odir="${work_dir}/${sample_dir}" \
    -tmpdir="${work_dir}/${sample_dir}" \
    -out="${work_dir}/${qc_file}" \
    > "${log_dir}/${sample_id}.phantom_peak.log" 2>&1

  cat "${qc_file}" >> "${summary_file}"
done
