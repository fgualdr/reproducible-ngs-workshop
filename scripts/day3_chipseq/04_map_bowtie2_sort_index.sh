#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv trimmed_dir index_prefix outdir}"
TRIMMED_DIR="${2:?Usage: $0 samples.tsv trimmed_dir index_prefix outdir}"
INDEX_PREFIX="${3:?Usage: $0 samples.tsv trimmed_dir index_prefix outdir}"
OUTDIR="${4:?Usage: $0 samples.tsv trimmed_dir index_prefix outdir}"
LOGDIR="${LOGDIR:-results/logs/day3}"
need_file "$SAMPLES"; need_dir "$TRIMMED_DIR"; need_cmd bowtie2; need_cmd samtools; make_dir "$OUTDIR"; make_dir "$LOGDIR"
tail -n +2 "$SAMPLES" | while IFS=$'\t' read -r sample_id condition assay role fq1 fq2 rest; do
  [[ "$sample_id" == TODO* ]] && continue
  if [[ -f "$TRIMMED_DIR/${sample_id}_R1.trimmed.fastq.gz" ]]; then
    bowtie2 -x "$INDEX_PREFIX" -1 "$TRIMMED_DIR/${sample_id}_R1.trimmed.fastq.gz" -2 "$TRIMMED_DIR/${sample_id}_R2.trimmed.fastq.gz" -p "$THREADS" 2> "$LOGDIR/06_bowtie2_${sample_id}.log" | samtools sort -@ "$THREADS" -o "$OUTDIR/${sample_id}.sorted.bam"
  else
    bowtie2 -x "$INDEX_PREFIX" -U "$TRIMMED_DIR/${sample_id}.trimmed.fastq.gz" -p "$THREADS" 2> "$LOGDIR/06_bowtie2_${sample_id}.log" | samtools sort -@ "$THREADS" -o "$OUTDIR/${sample_id}.sorted.bam"
  fi
  samtools index "$OUTDIR/${sample_id}.sorted.bam"
done
