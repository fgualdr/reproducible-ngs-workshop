#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv trimmed_dir outdir}"
TRIMMED_DIR="${2:?Usage: $0 samples.tsv trimmed_dir outdir}"
OUTDIR="${3:?Usage: $0 samples.tsv trimmed_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day2}"
need_file "$SAMPLES"; need_dir "$TRIMMED_DIR"; need_cmd fastqc; make_dir "$OUTDIR"; make_dir "$LOGDIR"
find "$TRIMMED_DIR" \( -name '*.fastq.gz' -o -name '*.fq.gz' \) -print | xargs fastqc --threads "$THREADS" --outdir "$OUTDIR" 2>&1 | tee "$LOGDIR/04_fastqc_trimmed.log"
command -v multiqc >/dev/null 2>&1 && multiqc "$OUTDIR" --outdir "$OUTDIR" 2>&1 | tee "$LOGDIR/05_multiqc_trimmed.log" || true
