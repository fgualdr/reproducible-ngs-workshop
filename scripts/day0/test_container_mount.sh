#!/usr/bin/env bash
set -euo pipefail

RUNTIME="${1:-docker}"
IMAGE="${IMAGE:-alpine:latest}"
PLATFORM="${PLATFORM:-linux/amd64}"
OUTDIR="${OUTDIR:-results/logs/day0}"
TESTFILE="$OUTDIR/container_mount_input.txt"
OUTFILE="$OUTDIR/container_mount_test.txt"

if ! command -v "$RUNTIME" >/dev/null 2>&1; then
  echo "ERROR: required command not found: $RUNTIME" >&2
  exit 1
fi

mkdir -p "$OUTDIR"
printf 'container_mount_ok\n' > "$TESTFILE"
trap 'rm -f "$TESTFILE"' EXIT

printf '[%s] Testing %s mount with image %s on %s\n' \
  "$(date '+%Y-%m-%d %H:%M:%S')" "$RUNTIME" "$IMAGE" "$PLATFORM"
container_output="$(
  "$RUNTIME" run --rm \
    --platform "$PLATFORM" \
    -v "$PWD:/work" \
    -w /work \
    "$IMAGE" \
    cat "$TESTFILE"
)"

if [[ "$container_output" != "container_mount_ok" ]]; then
  echo "ERROR: container did not read the expected text from $TESTFILE" >&2
  exit 1
fi

printf 'container_mount_ok\n' > "$OUTFILE"
printf '[%s] Mount test passed; record written to %s\n' \
  "$(date '+%Y-%m-%d %H:%M:%S')" "$OUTFILE"
