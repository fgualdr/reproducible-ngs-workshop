#!/usr/bin/env bash
set -euo pipefail

THREADS="${THREADS:-2}"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >&2
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

need_file() {
  [[ -f "$1" ]] || die "Required file not found: $1"
}

need_dir() {
  [[ -d "$1" ]] || die "Required directory not found: $1"
}

make_dir() {
  mkdir -p "$1"
}

