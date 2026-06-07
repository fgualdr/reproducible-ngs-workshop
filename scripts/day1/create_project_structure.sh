#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/common.sh"

log "Creating student project structure in $PWD"
mkdir -p \
  code/day1 \
  code/day2_rnaseq \
  code/day3_chipseq \
  code/day4_integration \
  container/ngs-cli \
  container/ngs-r \
  data/raw_fastq \
  data/trimmed_fastq \
  data/genome \
  data/bam \
  data/raw_counts \
  data/macs_peaks \
  results/rnaseq/deseq2 \
  results/rnaseq/plots \
  results/chipseq/peaks \
  results/chipseq/metaplots \
  results/chipseq/plots \
  results/integration \
  results/logs/day0 \
  results/logs/day1 \
  results/logs/day2 \
  results/logs/day3 \
  results/logs/day4
touch README.md
cat > README.md <<'EOF'
# Reproducible NGS project

This repository documents a reproducible RNA-seq and ChIP-seq analysis.

## Contents

- `code/`: day-by-day scripts and command notes.
- `container/`: Dockerfile, Containerfile, and environment recipes.
- `data/`: local FASTQ, genome, BAM, count, and peak files ignored by Git.
- `results/`: small final tables, plots, and summaries.
- `results/logs/`: command logs used to document execution.

## Execution backend

TODO: local Docker/Podman, partial local plus checkpoints, or checkpoint mode.

## Daily log

- Day 1:
- Day 2:
- Day 3:
- Day 4:
EOF
log "Created project directories"
