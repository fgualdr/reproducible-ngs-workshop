#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

IN_FASTQ="${1:?Usage: $0 input.fastq.gz output.fastq.gz [n_reads] [seed]}"
OUT_FASTQ="${2:?Usage: $0 input.fastq.gz output.fastq.gz [n_reads] [seed]}"
N_READS="${3:-100000}"
SEED="${4:-42}"
need_file "$IN_FASTQ"
need_cmd seqtk
make_dir "$(dirname "$OUT_FASTQ")"

seqtk sample -s "$SEED" "$IN_FASTQ" "$N_READS" | gzip -c > "$OUT_FASTQ"
log "Wrote subsampled FASTQ: $OUT_FASTQ"

