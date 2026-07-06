#!/usr/bin/env bash
set -euo pipefail

raw_dir="raw_data/fastq"
out_dir="results/day1_qc/trimmed_fastq"
report_dir="results/logs/day1/fastp"

mkdir -p "${out_dir}/rnaseq" "${out_dir}/chipseq" "${report_dir}"

for assay in rnaseq chipseq
do
  for read1 in "${raw_dir}/${assay}"/*_R1.fastq.gz
  do
    [[ -e "${read1}" ]] || continue

    read2="${read1/_R1.fastq.gz/_R2.fastq.gz}"
    sample_id="$(basename "${read1}" _R1.fastq.gz)"

    if [[ ! -f "${read2}" ]]; then
      echo "ERROR: paired read not found for ${read1}" >&2
      exit 1
    fi

    echo "Trimming ${sample_id}"
    fastp \
      -i "${read1}" \
      -I "${read2}" \
      -o "${out_dir}/${assay}/${sample_id}_R1.trimmed.fastq.gz" \
      -O "${out_dir}/${assay}/${sample_id}_R2.trimmed.fastq.gz" \
      --thread 2 \
      --html "${report_dir}/${sample_id}.fastp.html" \
      --json "${report_dir}/${sample_id}.fastp.json"
  done
done
