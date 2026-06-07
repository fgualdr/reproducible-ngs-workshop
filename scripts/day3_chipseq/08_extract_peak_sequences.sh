#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"
PEAK_DIR="${1:?Usage: $0 peak_dir genome.fa outdir}"
GENOME="${2:?Usage: $0 peak_dir genome.fa outdir}"
OUTDIR="${3:?Usage: $0 peak_dir genome.fa outdir}"
LOGDIR="${LOGDIR:-results/logs/day3}"
need_dir "$PEAK_DIR"; need_file "$GENOME"; need_cmd bedtools; make_dir "$OUTDIR"; make_dir "$LOGDIR"
for peak_file in "$PEAK_DIR"/*_peaks.narrowPeak; do
  [[ -e "$peak_file" ]] || continue
  base="$(basename "$peak_file" _peaks.narrowPeak)"
  bedtools getfasta -fi "$GENOME" -bed "$peak_file" -fo "$OUTDIR/${base}.peaks.fa" 2>&1 | tee "$LOGDIR/11_getfasta_${base}.log"
done
