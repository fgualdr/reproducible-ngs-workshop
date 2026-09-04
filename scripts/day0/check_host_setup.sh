#!/usr/bin/env bash
set -euo pipefail

printf '[%s] Checking host setup\n' "$(date '+%Y-%m-%d %H:%M:%S')"
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Working directory: %s\n' "$PWD"

status=0

for cmd in git gawk curl wget unzip docker; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf 'OK: %s -> %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf 'MISSING: %s\n' "$cmd"
    status=1
  fi
done

if command -v docker >/dev/null 2>&1; then
  if ! docker --version; then
    status=1
  fi
fi

if command -v podman >/dev/null 2>&1; then
  printf 'OPTIONAL: Podman is installed\n'
  podman --version || true
fi

printf 'Manual checks still required: GitHub, Docker Hub, VS Code, hello-world, folder mount, and IGV.\n'
printf '[%s] Host check complete\n' "$(date '+%Y-%m-%d %H:%M:%S')"

exit "$status"
