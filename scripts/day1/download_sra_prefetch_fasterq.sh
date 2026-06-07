#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

ACCESSIONS="${1:?Usage: $0 accessions.tsv outdir}"
OUTDIR="${2:?Usage: $0 accessions.tsv outdir}"
LOGDIR="${LOGDIR:-results/logs/day1}"
need_file "$ACCESSIONS"
need_cmd prefetch
need_cmd fasterq-dump
make_dir "$OUTDIR"
make_dir "$LOGDIR"

tail -n +2 "$ACCESSIONS" | while IFS=$'\t' read -r sample_id run_accession rest; do
  [[ -n "${run_accession:-}" ]] || continue
  [[ "$run_accession" == TODO* ]] && continue
  log "Downloading $run_accession for $sample_id"
  prefetch "$run_accession" --output-directory "$OUTDIR" 2>&1 | tee "$LOGDIR/04_prefetch_${run_accession}.log"
  fasterq-dump "$run_accession" --split-files --threads "$THREADS" --outdir "$OUTDIR" 2>&1 | tee "$LOGDIR/05_fasterq_${run_accession}.log"
done
