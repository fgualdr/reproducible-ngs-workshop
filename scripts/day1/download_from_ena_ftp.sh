#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

URLS="${1:?Usage: $0 ena_fastq_urls.tsv outdir}"
OUTDIR="${2:?Usage: $0 ena_fastq_urls.tsv outdir}"
need_file "$URLS"
need_cmd wget
make_dir "$OUTDIR"

tail -n +2 "$URLS" | while IFS=$'\t' read -r sample_id url rest; do
  [[ -n "${url:-}" ]] || continue
  [[ "$url" == TODO* ]] && continue
  log "Downloading $sample_id from $url"
  wget -c -P "$OUTDIR" "$url"
done

