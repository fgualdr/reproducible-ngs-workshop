#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

FASTA="${1:?Usage: $0 genome.fa index_prefix}"
INDEX_PREFIX="${2:?Usage: $0 genome.fa index_prefix}"
need_file "$FASTA"
need_cmd bowtie2-build
make_dir "$(dirname "$INDEX_PREFIX")"

bowtie2-build "$FASTA" "$INDEX_PREFIX"
log "Built Bowtie2 index prefix: $INDEX_PREFIX"

