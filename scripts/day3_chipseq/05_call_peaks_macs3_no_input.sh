#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv bam_dir outdir}"
BAM_DIR="${2:?Usage: $0 samples.tsv bam_dir outdir}"
OUTDIR="${3:?Usage: $0 samples.tsv bam_dir outdir}"
GENOME_SIZE="${GENOME_SIZE:-4.6e6}"
LOGDIR="${LOGDIR:-results/logs/day3}"
need_file "$SAMPLES"; need_dir "$BAM_DIR"; need_cmd macs3; make_dir "$OUTDIR"; make_dir "$LOGDIR"
tail -n +2 "$SAMPLES" | while IFS=$'\t' read -r sample_id condition assay role fq1 fq2 rest; do
  [[ "$sample_id" == TODO* || "$role" != "IP" ]] && continue
  macs3 callpeak -t "$BAM_DIR/${sample_id}.sorted.bam" -f BAM -g "$GENOME_SIZE" -n "$sample_id" --outdir "$OUTDIR" --keep-dup all 2>&1 | tee "$LOGDIR/07_macs3_no_input_${sample_id}.log"
done
