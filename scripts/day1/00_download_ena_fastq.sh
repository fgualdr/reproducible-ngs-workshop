#!/usr/bin/env bash
set -euo pipefail

# Download ENA FASTQ files listed in the filtered ArrayExpress SDRF metadata files.

rnaseq_sdrf="raw_data/metadata/E-MTAB-13025.sdrf.txt"
chipseq_sdrf="raw_data/metadata/E-MTAB-13026.sdrf.txt"
out_dir="raw_data/fastq"

mkdir -p "${out_dir}/rnaseq" "${out_dir}/chipseq"

if [[ ! -f "${rnaseq_sdrf}" ]]; then
  echo "ERROR: RNA-seq SDRF file not found: ${rnaseq_sdrf}" >&2
  exit 1
fi

if [[ ! -f "${chipseq_sdrf}" ]]; then
  echo "ERROR: ChIP-seq SDRF file not found: ${chipseq_sdrf}" >&2
  exit 1
fi

echo "Downloading RNA-seq FASTQ files"

tr -d '\r' < "${rnaseq_sdrf}" |
awk -F '\t' '
  NR == 1 {
    for (i = 1; i <= NF; i++) {
      if ($i == "Source Name") sample_col = i
      if ($i == "Comment[FASTQ_URI]") fastq_col = i
    }
    next
  }
  {
    print $sample_col "\t" $fastq_col
  }
' |
while IFS=$'\t' read -r sample_id fastq_url
do
  [[ -n "${sample_id}" && -n "${fastq_url}" ]] || continue

  read_label="R1"
  if [[ "${fastq_url}" == *_2.fastq.gz ]]; then
    read_label="R2"
  fi

  echo "Downloading rnaseq ${sample_id} ${read_label}"
  curl -L "${fastq_url}" -o "${out_dir}/rnaseq/${sample_id}_${read_label}.fastq.gz"
done

echo "Downloading ChIP-seq FASTQ files"

tr -d '\r' < "${chipseq_sdrf}" |
awk -F '\t' '
  NR == 1 {
    for (i = 1; i <= NF; i++) {
      if ($i == "Source Name") sample_col = i
      if ($i == "Comment[FASTQ_URI]") fastq_col = i
    }
    next
  }
  {
    print $sample_col "\t" $fastq_col
  }
' |
while IFS=$'\t' read -r sample_id fastq_url
do
  [[ -n "${sample_id}" && -n "${fastq_url}" ]] || continue

  read_label="R1"
  if [[ "${fastq_url}" == *_2.fastq.gz ]]; then
    read_label="R2"
  fi

  echo "Downloading chipseq ${sample_id} ${read_label}"
  curl -L "${fastq_url}" -o "${out_dir}/chipseq/${sample_id}_${read_label}.fastq.gz"
done
