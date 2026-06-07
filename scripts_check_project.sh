#!/usr/bin/env bash
set -euo pipefail

status=0

warn() {
  printf 'WARNING: %s\n' "$*" >&2
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

printf 'Checking shell script syntax...\n'
while IFS= read -r script; do
  bash -n "$script" || status=1
done < <(find scripts -name '*.sh' -print)

if check_cmd shellcheck; then
  printf 'Running shellcheck...\n'
  shellcheck $(find scripts -name '*.sh' -print) || status=1
else
  warn 'shellcheck not installed; skipping.'
fi

if check_cmd Rscript; then
  printf 'Checking R script parseability...\n'
  while IFS= read -r rscript; do
    Rscript -e "parse(file='$rscript')" >/dev/null || status=1
  done < <(find scripts -name '*.R' -print)
else
  warn 'Rscript not installed; skipping R parse checks.'
fi

if check_cmd quarto; then
  printf 'Running quarto check...\n'
  quarto check || warn 'quarto check reported issues.'
  printf 'Rendering Quarto site...\n'
  quarto render || status=1
else
  warn 'quarto not installed; skipping render.'
fi

printf 'Checking for tracked large-file extensions when inside a Git repo...\n'
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  forbidden="$(git ls-files | grep -E '\.(fastq|fq|sra|bam|bai|cram|crai|bw|bigWig)(\.gz)?$' || true)"
  if [[ -n "$forbidden" ]]; then
    printf 'Forbidden tracked large files:\n%s\n' "$forbidden" >&2
    status=1
  fi
else
  warn 'Not a Git repository; skipping tracked-file check.'
fi

exit "$status"

