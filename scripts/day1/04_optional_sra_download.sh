#!/usr/bin/env bash
set -euo pipefail

THREADS="${THREADS:-2}"

rnaseq_study="ERP147707"
chipseq_study="ERP147583"

rnaseq_tsv="raw_data/metadata/${rnaseq_study}_metadata.tsv"
chipseq_tsv="raw_data/metadata/${chipseq_study}_metadata.tsv"

rnaseq_metadata="raw_data/metadata/${rnaseq_study}_WT_metadata.tsv"
chipseq_metadata="raw_data/metadata/${chipseq_study}_WT_metadata.tsv"

run_column=1
sample_column=73
layout_column=109
experiment_column=163
selected_columns="${run_column},${sample_column},${layout_column},${experiment_column}"

rnaseq_out="raw_data/fastq/rnaseq"
chipseq_out="raw_data/fastq/chipseq"
temp_dir="results/logs/day1/sra_tmp"
log_file="results/logs/day1/sra_fastq_download.log"

mkdir -p \
  raw_data/metadata \
  "${rnaseq_out}" \
  "${chipseq_out}" \
  "${temp_dir}"

: > "${log_file}"


# -------------------------------------------------------------------------
# Download the two SRA study metadata reports
# -------------------------------------------------------------------------

echo "Downloading RNA-seq metadata for ${rnaseq_study}" | tee -a "${log_file}"

curl -fL \
  "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${rnaseq_study}&result=read_run&fields=all" \
  -o "${rnaseq_tsv}"


echo "Downloading ChIP-seq metadata for ${chipseq_study}" | tee -a "${log_file}"

curl -fL \
  "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=${chipseq_study}&result=read_run&fields=all" \
  -o "${chipseq_tsv}"


# -------------------------------------------------------------------------
# RNA-seq metadata
# -------------------------------------------------------------------------

echo "Selecting wild-type RNA-seq rows" | tee -a "${log_file}"

# Keep only the four columns needed below and give them short names.
header=$(head -n 1 "${rnaseq_tsv}" | cut -f"${selected_columns}")
expected_header=$'run_accession\tsample_title\tlibrary_layout\texperiment_accession'

if [[ "${header}" != "${expected_header}" ]]; then
  echo "Unexpected RNA-seq metadata columns" | tee -a "${log_file}"
  exit 1
fi

printf 'RUN_ACCESSION\tSAMPLE_ID\tLAYOUT\tEXPERIMENT_ACCESSION\tFASTQ_NAME_R1\tFASTQ_NAME_R2\n' \
  > "${rnaseq_metadata}"

tail -n +2 "${rnaseq_tsv}" |
cut -f"${selected_columns}" |
while IFS=$'\t' read -r run_accession sample layout experiment_accession; do

  case "${sample}" in
    WT_[123]|WTS_[123]) ;;
    *) continue ;;
  esac

  if [[ "${run_accession}" != ERR* || \
        "${experiment_accession}" != ERX* || \
        "${layout}" != "PAIRED" ]]; then
    echo "Unexpected RNA-seq row for ${sample}" | tee -a "${log_file}"
    exit 1
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "${run_accession}" \
    "${sample}" \
    "${layout}" \
    "${experiment_accession}" \
    "${sample}_R1.fastq.gz" \
    "${sample}_R2.fastq.gz" \
    >> "${rnaseq_metadata}"

done

selected_rows=$(tail -n +2 "${rnaseq_metadata}" | wc -l | tr -d ' ')

if [[ "${selected_rows}" -ne 6 ]]; then
  echo "Expected 6 WT/WTS RNA-seq samples; found ${selected_rows}" |
    tee -a "${log_file}"
  exit 1
fi


# -------------------------------------------------------------------------
# ChIP-seq metadata
# -------------------------------------------------------------------------

echo "Selecting wild-type ChIP-seq rows" | tee -a "${log_file}"

header=$(head -n 1 "${chipseq_tsv}" | cut -f"${selected_columns}")

if [[ "${header}" != "${expected_header}" ]]; then
  echo "Unexpected ChIP-seq metadata columns" | tee -a "${log_file}"
  exit 1
fi

printf 'RUN_ACCESSION\tSAMPLE_ID\tLAYOUT\tEXPERIMENT_ACCESSION\tFASTQ_NAME_R1\tFASTQ_NAME_R2\n' \
  > "${chipseq_metadata}"

tail -n +2 "${chipseq_tsv}" |
cut -f"${selected_columns}" |
while IFS=$'\t' read -r run_accession sample layout experiment_accession; do

  case "${sample}" in
    WT_[123]|WTS_[123]) ;;
    *) continue ;;
  esac

  if [[ "${run_accession}" != ERR* || \
        "${experiment_accession}" != ERX* || \
        "${layout}" != "PAIRED" ]]; then
    echo "Unexpected ChIP-seq row for ${sample}" | tee -a "${log_file}"
    exit 1
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
    "${run_accession}" \
    "${sample}" \
    "${layout}" \
    "${experiment_accession}" \
    "${sample}_R1.fastq.gz" \
    "${sample}_R2.fastq.gz" \
    >> "${chipseq_metadata}"

done

selected_rows=$(tail -n +2 "${chipseq_metadata}" | wc -l | tr -d ' ')

if [[ "${selected_rows}" -ne 6 ]]; then
  echo "Expected 6 WT/WTS ChIP-seq samples; found ${selected_rows}" |
    tee -a "${log_file}"
  exit 1
fi


# -------------------------------------------------------------------------
# Download and rename RNA-seq FASTQ files
# -------------------------------------------------------------------------

echo "Downloading RNA-seq FASTQ files" | tee -a "${log_file}"

tail -n +2 "${rnaseq_metadata}" |
while IFS=$'\t' read -r \
  run_accession sample layout experiment_accession fastq_r1 fastq_r2; do

  final_r1="${rnaseq_out}/${fastq_r1}"
  final_r2="${rnaseq_out}/${fastq_r2}"
  plain_r1="${final_r1%.gz}"
  plain_r2="${final_r2%.gz}"

  echo \
    "Downloading ${experiment_accession} through run ${run_accession}" |
    tee -a "${log_file}"

  if [[ -e "${final_r1}" || -e "${final_r2}" || \
        -e "${plain_r1}" || -e "${plain_r2}" ]]; then
    echo "Output already exists for ${run_accession}; stopping" |
      tee -a "${log_file}"
    exit 1
  fi

  fasterq-dump "${run_accession}" \
    --split-files \
    --threads "${THREADS}" \
    --temp "${temp_dir}" \
    --outdir "${rnaseq_out}"

  if [[ ! -s "${rnaseq_out}/${run_accession}_1.fastq" || \
        ! -s "${rnaseq_out}/${run_accession}_2.fastq" ]]; then
    echo "Paired FASTQ output is missing for ${run_accession}" |
      tee -a "${log_file}"
    exit 1
  fi

  mv "${rnaseq_out}/${run_accession}_1.fastq" "${plain_r1}"
  mv "${rnaseq_out}/${run_accession}_2.fastq" "${plain_r2}"
  pigz -f -p "${THREADS}" "${plain_r1}" "${plain_r2}"

done


# -------------------------------------------------------------------------
# Download and rename ChIP-seq FASTQ files
# -------------------------------------------------------------------------

echo "Downloading ChIP-seq FASTQ files" | tee -a "${log_file}"

tail -n +2 "${chipseq_metadata}" |
while IFS=$'\t' read -r \
  run_accession sample layout experiment_accession fastq_r1 fastq_r2; do

  final_r1="${chipseq_out}/${fastq_r1}"
  final_r2="${chipseq_out}/${fastq_r2}"
  plain_r1="${final_r1%.gz}"
  plain_r2="${final_r2%.gz}"

  echo \
    "Downloading ${experiment_accession} through run ${run_accession}" |
    tee -a "${log_file}"

  if [[ -e "${final_r1}" || -e "${final_r2}" || \
        -e "${plain_r1}" || -e "${plain_r2}" ]]; then
    echo "Output already exists for ${run_accession}; stopping" |
      tee -a "${log_file}"
    exit 1
  fi

  fasterq-dump "${run_accession}" \
    --split-files \
    --threads "${THREADS}" \
    --temp "${temp_dir}" \
    --outdir "${chipseq_out}"

  if [[ ! -s "${chipseq_out}/${run_accession}_1.fastq" || \
        ! -s "${chipseq_out}/${run_accession}_2.fastq" ]]; then
    echo "Paired FASTQ output is missing for ${run_accession}" |
      tee -a "${log_file}"
    exit 1
  fi

  mv "${chipseq_out}/${run_accession}_1.fastq" "${plain_r1}"
  mv "${chipseq_out}/${run_accession}_2.fastq" "${plain_r2}"
  pigz -f -p "${THREADS}" "${plain_r1}" "${plain_r2}"

done


# -------------------------------------------------------------------------
# Record what was done
# -------------------------------------------------------------------------

cat > raw_data/metadata/SRA_METADATA.md <<'EOF'
# Optional SRA metadata route

The complete run-level metadata reports were downloaded in code from the ENA
Portal API for these SRA studies:

- ERP147707_metadata.tsv (RNA-seq study ERP147707)
- ERP147583_metadata.tsv (ChIP-seq study ERP147583)

The optional SRA script selected the exact sample_title values WT_1, WT_2,
WT_3, WTS_1, WTS_2, and WTS_3. It saved the selected rows as:

- ERP147707_WT_metadata.tsv
- ERP147583_WT_metadata.tsv

The script kept run_accession (column 1), sample_title (column 73),
library_layout (column 109), and experiment_accession (column 163). The selected
tables contain only these required fields plus the two simplified FASTQ names.
The ERX experiment accession was retained for provenance. fasterq-dump was given
the corresponding ERR run accession because FASTQ data are retrieved at run
level.

Paired FASTQ files were renamed from ERR-accession names to sample names such
as WT_1_R1.fastq.gz and WT_1_R2.fastq.gz.

RNA-seq metadata API:
https://www.ebi.ac.uk/ena/portal/api/filereport?accession=ERP147707&result=read_run&fields=all

ChIP-seq metadata API:
https://www.ebi.ac.uk/ena/portal/api/filereport?accession=ERP147583&result=read_run&fields=all

RNA-seq FASTQ files:
raw_data/fastq/rnaseq

ChIP-seq FASTQ files:
raw_data/fastq/chipseq
EOF


echo "Optional SRA metadata processing and FASTQ download complete" |
  tee -a "${log_file}"
