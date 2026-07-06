#!/usr/bin/env bash
set -euo pipefail

RUNTIME="${1:-docker}"
IMAGE="${IMAGE:-ubuntu:24.04}"
OUTDIR="${OUTDIR:-results/day0}"
OUTFILE="$OUTDIR/container_mount_test.txt"

if ! command -v "$RUNTIME" >/dev/null 2>&1; then
  echo "ERROR: required command not found: $RUNTIME" >&2
  exit 1
fi

mkdir -p "$OUTDIR"

printf '[%s] Testing %s mount with image %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$RUNTIME" "$IMAGE"
"$RUNTIME" run --rm -v "$PWD":/work -w /work "$IMAGE" \
  bash -lc "mkdir -p '$OUTDIR' && echo container_mount_ok > '$OUTFILE'"

if [[ ! -f "$OUTFILE" ]]; then
  echo "ERROR: mount test did not write $OUTFILE" >&2
  exit 1
fi

printf '[%s] Mount test wrote %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$OUTFILE"
