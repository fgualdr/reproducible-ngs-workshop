#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
SAMPLES="${1:?Usage: $0 samples.tsv fastq_dir outdir}"
FASTQ_DIR="${2:?Usage: $0 samples.tsv fastq_dir outdir}"
OUTDIR="${3:?Usage: $0 samples.tsv fastq_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day2}"
need_file "$SAMPLES"; need_dir "$FASTQ_DIR"; need_cmd fastqc; make_dir "$OUTDIR"; make_dir "$LOGDIR"
find "$FASTQ_DIR" \( -name '*.fastq.gz' -o -name '*.fq.gz' \) -print | xargs fastqc --threads "$THREADS" --outdir "$OUTDIR" 2>&1 | tee "$LOGDIR/01_fastqc_raw.log"
command -v multiqc >/dev/null 2>&1 && multiqc "$OUTDIR" --outdir "$OUTDIR" 2>&1 | tee "$LOGDIR/02_multiqc_raw.log" || true
