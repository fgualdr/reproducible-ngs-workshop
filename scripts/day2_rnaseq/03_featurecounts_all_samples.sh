#!/usr/bin/env bash
set -euo pipefail

annotation="reference_genome/annotation.gff3"
bam_dir="results/day2_rnaseq/bam"
counts_dir="results/day2_rnaseq/counts"
log_dir="results/logs/day2"
featurecounts_out="${counts_dir}/featureCounts_all_samples.txt"
count_matrix="${counts_dir}/gene_count_matrix.tsv"

mkdir -p "${counts_dir}" "${log_dir}"

if [[ ! -f "${annotation}" ]]; then
  echo "ERROR: annotation file not found: ${annotation}" >&2
  exit 1
fi

bam_files=("${bam_dir}"/*.filtered.bam)

if [[ ! -e "${bam_files[0]}" ]]; then
  echo "ERROR: No filtered BAM files found in ${bam_dir}" >&2
  exit 1
fi

echo "Counting reads across ${#bam_files[@]} samples"

featureCounts \
  -T 2 \
  -p \
  -B \
  -C \
  -t gene \
  -g ID \
  -a "${annotation}" \
  -o "${featurecounts_out}" \
  "${bam_files[@]}" \
  2>&1 | tee "${log_dir}/featureCounts_all_samples.log"

# Convert the full featureCounts table into the simple gene x sample matrix used by DESeq2.
awk 'BEGIN { FS = OFS = "\t" }
  /^#/ { next }
  $1 == "Geneid" {
    printf "gene_id"
    for (i = 7; i <= NF; i++) {
      sample = $i
      sub(/^.*\//, "", sample)
      sub(/[.]filtered[.]bam$/, "", sample)
      printf OFS sample
    }
    printf "\n"
    next
  }
  {
    printf $1
    for (i = 7; i <= NF; i++) {
      printf OFS $i
    }
    printf "\n"
  }' "${featurecounts_out}" > "${count_matrix}"

echo "Wrote ${featurecounts_out}"
echo "Wrote ${count_matrix}"
