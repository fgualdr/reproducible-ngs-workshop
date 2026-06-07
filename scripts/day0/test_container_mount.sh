#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

RUNTIME="${1:-docker}"
IMAGE="${IMAGE:-ubuntu:24.04}"
OUTDIR="${OUTDIR:-results/day0}"
OUTFILE="$OUTDIR/container_mount_test.txt"

need_cmd "$RUNTIME"
make_dir "$OUTDIR"

log "Testing $RUNTIME mount with image $IMAGE"
"$RUNTIME" run --rm -v "$PWD":/work -w /work "$IMAGE" \
  bash -lc "mkdir -p '$OUTDIR' && echo container_mount_ok > '$OUTFILE'"

need_file "$OUTFILE"
log "Mount test wrote $OUTFILE"

