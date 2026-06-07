#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
FASTA_DIR="${1:?Usage: $0 peak_fasta_dir outdir}"
OUTDIR="${2:?Usage: $0 peak_fasta_dir outdir}"
LOGDIR="${LOGDIR:-results/logs/day3}"
need_dir "$FASTA_DIR"; need_cmd streme; make_dir "$OUTDIR"; make_dir "$LOGDIR"
for fasta in "$FASTA_DIR"/*.fa; do
  [[ -e "$fasta" ]] || continue
  base="$(basename "$fasta" .fa)"
  streme --p "$fasta" --oc "$OUTDIR/$base" --dna 2>&1 | tee "$LOGDIR/12_streme_${base}.log"
done
