#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv annotation.gff3 bam_dir outdir}"
ANNOTATION="${2:?Usage: $0 samples.tsv annotation.gff3 bam_dir outdir}"
BAM_DIR="${3:?Usage: $0 samples.tsv annotation.gff3 bam_dir outdir}"
OUTDIR="${4:?Usage: $0 samples.tsv annotation.gff3 bam_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day2}"
need_file "$SAMPLES"; need_file "$ANNOTATION"; need_dir "$BAM_DIR"; need_cmd featureCounts; make_dir "$OUTDIR"; make_dir "$LOGDIR"
tail -n +2 "$SAMPLES" | while IFS=$'\t' read -r sample_id condition replicate fq1 fq2 rest; do
  [[ "$sample_id" == TODO* ]] && continue
  need_file "$BAM_DIR/${sample_id}.sorted.bam"
  featureCounts -T "$THREADS" -a "$ANNOTATION" -o "$OUTDIR/${sample_id}.featureCounts.txt" "$BAM_DIR/${sample_id}.sorted.bam" 2>&1 | tee "$LOGDIR/07_featurecounts_${sample_id}.log"
done
