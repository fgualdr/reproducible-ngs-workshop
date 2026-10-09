#!/usr/bin/env bash
set -euo pipefail

# Day 4 - Docker calls extracted from source_quarto.qmd
# Run from the ROOT of your existing workshop_ngs project.
# First copy this package's day-specific scripts/ directory into the project.
# This file lists teaching examples and ALTERNATIVE routes in source order.
# Review selections before executing; do not indiscriminately run every alternative.

# Step 01 | Quarto line 494 | 12. Save the R session information
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-r-bioc \
  Rscript scripts/day4_optional/01_basic_integration.R \
  2>&1 | tee results/logs/day4/01_basic_integration.log

