#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

log "Checking host setup"
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Working directory: %s\n' "$PWD"

for cmd in git; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf 'OK: %s -> %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf 'MISSING: %s\n' "$cmd"
  fi
done

if command -v docker >/dev/null 2>&1; then
  docker --version || true
else
  printf 'MISSING: docker\n'
fi

if command -v podman >/dev/null 2>&1; then
  podman --version || true
else
  printf 'MISSING: podman\n'
fi

log "Host check complete"

