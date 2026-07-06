#!/usr/bin/env bash
set -euo pipefail

printf '[%s] Checking host setup\n' "$(date '+%Y-%m-%d %H:%M:%S')"
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

printf '[%s] Host check complete\n' "$(date '+%Y-%m-%d %H:%M:%S')"
