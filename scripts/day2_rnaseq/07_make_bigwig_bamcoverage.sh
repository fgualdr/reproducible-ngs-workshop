#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv bam_dir outdir}"
BAM_DIR="${2:?Usage: $0 samples.tsv bam_dir outdir}"
OUTDIR="${3:?Usage: $0 samples.tsv bam_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day2}"
need_file "$SAMPLES"; need_dir "$BAM_DIR"; need_cmd bamCoverage; make_dir "$OUTDIR"; make_dir "$LOGDIR"
tail -n +2 "$SAMPLES" | while IFS=$'\t' read -r sample_id condition replicate fq1 fq2 rest; do
  [[ "$sample_id" == TODO* ]] && continue
  bamCoverage -b "$BAM_DIR/${sample_id}.sorted.bam" -o "$OUTDIR/${sample_id}.cpm.bw" --normalizeUsing CPM --numberOfProcessors "$THREADS" 2>&1 | tee "$LOGDIR/08_bamcoverage_${sample_id}.log"
done
