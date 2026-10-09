#!/usr/bin/env bash
set -euo pipefail

# Day 0 - Docker calls extracted from source_quarto.qmd
# Run from the ROOT of your existing workshop_ngs project.
# First copy this package's day-specific scripts/ directory into the project.
# This file lists teaching examples and ALTERNATIVE routes in source order.
# Review selections before executing; do not indiscriminately run every alternative.

# Step 01 | Quarto line 294 | Step 5: test Docker from Ubuntu
docker --version
docker run --rm hello-world

# Step 02 | Quarto line 461 | Step 11: test folder mounting with Docker
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  alpine:latest \
  sh -c 'cat test_mount/message.txt && echo "Docker can write this file" > test_mount/docker_write_test.txt'

cat test_mount/docker_write_test.txt

# Step 03 | Quarto line 566 | Step 4: install Docker Desktop for Mac
docker --version
docker run --rm hello-world

# Step 04 | Quarto line 631 | Step 6: test folder mounting with Docker
docker run --rm \
  --user "$(id -u):$(id -g)" \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  alpine:latest \
  sh -c 'cat test_mount/message.txt && echo "Docker can write this file" > test_mount/docker_write_test.txt'

cat test_mount/docker_write_test.txt

# Step 05 | Quarto line 747 | Step 4: check Docker
docker run --rm hello-world

# Step 06 | Quarto line 811 | Step 6: test folder mounting with Docker
docker run --rm \
  --user "$(id -u):$(id -g)" \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  alpine:latest \
  sh -c 'cat test_mount/message.txt && echo "Docker can write this file" > test_mount/docker_write_test.txt'

cat test_mount/docker_write_test.txt

