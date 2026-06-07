#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv bam_dir outdir}"
BAM_DIR="${2:?Usage: $0 samples.tsv bam_dir outdir}"
OUTDIR="${3:?Usage: $0 samples.tsv bam_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day3}"
need_file "$SAMPLES"; need_dir "$BAM_DIR"; need_cmd bamCoverage; make_dir "$OUTDIR"; make_dir "$LOGDIR"
tail -n +2 "$SAMPLES" | while IFS=$'\t' read -r sample_id condition assay role fq1 fq2 input_sample rest; do
  [[ "$sample_id" == TODO* ]] && continue
  bamCoverage -b "$BAM_DIR/${sample_id}.sorted.bam" -o "$OUTDIR/${sample_id}.cpm.bw" --normalizeUsing CPM --numberOfProcessors "$THREADS" 2>&1 | tee "$LOGDIR/09_bamcoverage_${sample_id}.log"
  if [[ "$role" == "IP" && -n "${input_sample:-}" && "$input_sample" != "NA" ]] && command -v bamCompare >/dev/null 2>&1; then
    bamCompare -b1 "$BAM_DIR/${sample_id}.sorted.bam" -b2 "$BAM_DIR/${input_sample}.sorted.bam" -o "$OUTDIR/${sample_id}.log2_ip_input.bw" --operation log2 --normalizeUsing CPM --numberOfProcessors "$THREADS" 2>&1 | tee "$LOGDIR/10_bamcompare_${sample_id}.log"
  fi
done
