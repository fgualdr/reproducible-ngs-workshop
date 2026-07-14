#!/usr/bin/env bash
set -euo pipefail

bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/qc/phantom_peak"
log_dir="results/logs/day3"
THREADS="${THREADS:-2}"

mkdir -p "${out_dir}" "${log_dir}"

bam_files=("${bam_dir}"/*.filtered.bam)

if [[ ! -e "${bam_files[0]}" ]]; then
  echo "ERROR: No filtered BAM files found in ${bam_dir}" >&2
  exit 1
fi

spp_script="$(command -v run_spp.R || true)"
if [[ -z "${spp_script}" ]]; then
  echo "ERROR: run_spp.R was not found. Use the ChIP-seq QC Docker image." >&2
  exit 1
fi

repo_root="${PWD}"

for bam in "${bam_files[@]}"
do
  sample_id="$(basename "${bam}" .filtered.bam)"
  sample_dir="${out_dir}/${sample_id}"

  mkdir -p "${sample_dir}"

  echo "Running phantom peak cross-correlation QC for ${sample_id}"
  (
    cd "${sample_dir}"
    Rscript "${spp_script}" \
      -c="${repo_root}/${bam}" \
      -p="${THREADS}" \
      -savp \
      -out="${sample_id}.phantom_peak_qc.tsv"
  ) 2>&1 | tee "${log_dir}/${sample_id}.phantom_peak.log"
done
