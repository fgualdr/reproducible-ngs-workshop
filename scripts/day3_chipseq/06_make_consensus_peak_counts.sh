#!/usr/bin/env bash
set -euo pipefail

peak_dir="results/day3_chipseq/peaks/no_input"
bam_dir="results/day3_chipseq/bam"
out_dir="results/day3_chipseq/peaks/consensus"
count_dir="results/day3_chipseq/counts"
log_dir="results/logs/day3"

consensus_bed="${out_dir}/consensus_peaks.bed"
day4_peak_set="${out_dir}/day4_consensus_peaks.bed"
count_matrix="${count_dir}/consensus_peak_counts.tsv"
log_file="${log_dir}/consensus_peak_counts.log"

mkdir -p "${out_dir}" "${count_dir}" "${log_dir}"

peak_files=("${peak_dir}"/*_peaks.narrowPeak)
bam_files=("${bam_dir}"/*.filtered.bam)

if [[ ! -e "${peak_files[0]}" ]]; then
  echo "ERROR: No MACS3 narrowPeak files found in ${peak_dir}" >&2
  exit 1
fi

if [[ ! -e "${bam_files[0]}" ]]; then
  echo "ERROR: No filtered BAM files found in ${bam_dir}" >&2
  exit 1
fi

tmp_peaks="${out_dir}/all_sample_peaks.tmp.bed"
sorted_peaks="${out_dir}/all_sample_peaks.sorted.tmp.bed"
merged_peaks="${out_dir}/merged_peaks.tmp.bed"
raw_counts="${count_dir}/consensus_peak_counts.raw.tmp.tsv"

echo "Creating a merged consensus peak set" | tee "${log_file}"
: > "${tmp_peaks}"

for peak_file in "${peak_files[@]}"
do
  sample_id="$(basename "${peak_file}" _peaks.narrowPeak)"
  awk -v sample="${sample_id}" 'BEGIN { OFS = "\t" } NF >= 3 { print $1, $2, $3, sample }' \
    "${peak_file}" >> "${tmp_peaks}"
done

sort -k1,1 -k2,2n "${tmp_peaks}" > "${sorted_peaks}"

bedtools merge \
  -i "${sorted_peaks}" \
  -c 4 \
  -o count \
  > "${merged_peaks}" 2>> "${log_file}"

if [[ ! -s "${merged_peaks}" ]]; then
  echo "ERROR: Consensus peak set is empty after merging" >&2
  exit 1
fi

awk 'BEGIN { OFS = "\t" } { printf "%s\t%s\t%s\tpeak_%04d\t%s\n", $1, $2, $3, NR, $4 }' \
  "${merged_peaks}" > "${consensus_bed}"

cp "${consensus_bed}" "${day4_peak_set}"

echo "Counting filtered BAM alignments in consensus peaks" | tee -a "${log_file}"
bedtools multicov \
  -bams "${bam_files[@]}" \
  -bed "${consensus_bed}" \
  > "${raw_counts}" 2>> "${log_file}"

{
  printf "chrom\tstart\tend\tpeak_id\tpeak_record_count"
  for bam in "${bam_files[@]}"
  do
    sample_id="$(basename "${bam}" .filtered.bam)"
    printf "\t%s" "${sample_id}"
  done
  printf "\n"
  cat "${raw_counts}"
} > "${count_matrix}"

rm -f "${tmp_peaks}" "${sorted_peaks}" "${merged_peaks}" "${raw_counts}"

echo "Wrote ${consensus_bed}" | tee -a "${log_file}"
echo "Wrote ${day4_peak_set}" | tee -a "${log_file}"
echo "Wrote ${count_matrix}" | tee -a "${log_file}"
