#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv fastq_dir outdir}"
FASTQ_DIR="${2:?Usage: $0 samples.tsv fastq_dir outdir}"
OUTDIR="${3:?Usage: $0 samples.tsv fastq_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day3}"
need_file "$SAMPLES"; need_dir "$FASTQ_DIR"; need_cmd fastp; make_dir "$OUTDIR"; make_dir "$OUTDIR/logs"; make_dir "$LOGDIR"
tail -n +2 "$SAMPLES" | while IFS=$'\t' read -r sample_id condition assay role fq1 fq2 rest; do
  [[ "$sample_id" == TODO* ]] && continue
  need_file "$FASTQ_DIR/$fq1"
  if [[ -n "${fq2:-}" && "$fq2" != "NA" ]]; then
    need_file "$FASTQ_DIR/$fq2"
    fastp -i "$FASTQ_DIR/$fq1" -I "$FASTQ_DIR/$fq2" -o "$OUTDIR/${sample_id}_R1.trimmed.fastq.gz" -O "$OUTDIR/${sample_id}_R2.trimmed.fastq.gz" --thread "$THREADS" --html "$OUTDIR/logs/${sample_id}.html" --json "$OUTDIR/logs/${sample_id}.json" 2>&1 | tee "$LOGDIR/03_trim_fastp_${sample_id}.log"
  else
    fastp -i "$FASTQ_DIR/$fq1" -o "$OUTDIR/${sample_id}.trimmed.fastq.gz" --thread "$THREADS" --html "$OUTDIR/logs/${sample_id}.html" --json "$OUTDIR/logs/${sample_id}.json" 2>&1 | tee "$LOGDIR/03_trim_fastp_${sample_id}.log"
  fi
done
