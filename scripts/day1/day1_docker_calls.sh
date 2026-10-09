#!/usr/bin/env bash
set -euo pipefail

# Day 1 - Docker calls extracted from source_quarto.qmd
# Run from the ROOT of your existing workshop_ngs project.
# First copy this package's day-specific scripts/ directory into the project.
# This file lists teaching examples and ALTERNATIVE routes in source order.
# Review selections before executing; do not indiscriminately run every alternative.

# Step 01 | Quarto line 320 | 5.1 Test Docker
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/library/alpine \
  sh -c 'echo "Hello from Docker" > test_hello.txt'

cat test_hello.txt

# Step 02 | Quarto line 612 | 6.5 Check the network and run the reference download
docker run --rm \
  docker.io/fgualdr/ngs-curl \
  bash -lc 'echo "DNS inside the container:"; cat /etc/resolv.conf; echo; curl -I https://ftp.ncbi.nlm.nih.gov'

# Step 03 | Quarto line 622 | 6.5 Check the network and run the reference download
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-curl \
  bash scripts/day1/01_reference_genome_annotation.sh

# Step 04 | Quarto line 1105 | Check the EBI connection and run the script
docker run --rm \
  docker.io/fgualdr/ngs-curl \
  bash -lc 'echo "DNS inside the container:"; cat /etc/resolv.conf; echo; curl -I https://www.ebi.ac.uk'

# Step 05 | Quarto line 1113 | Check the EBI connection and run the script
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-curl \
  bash scripts/day1/02_download_ena_fastq.sh

# Step 06 | Quarto line 1466 | Check EBI/NCBI and run the complete SRA route
docker run --rm \
  docker.io/fgualdr/ngs-sra-tools:latest \
  bash -c '
    echo "DNS inside the container:"
    cat /etc/resolv.conf
    echo
    echo "Testing EMBL-EBI..."
    curl -I https://www.ebi.ac.uk
    echo
    echo "Testing NCBI..."
    curl -I https://www.ncbi.nlm.nih.gov
    echo
    echo "SRA Toolkit:"
    command -v prefetch
    command -v vdb-validate
    command -v fastq-dump
    prefetch --version
    fastq-dump --version
  '

# Step 07 | Quarto line 1490 | Check EBI/NCBI and run the complete SRA route
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-sra-tools:latest \
  bash scripts/day1/04_download_sra_fastq.sh

# Step 08 | Quarto line 1655 | 8.2 Run the script in Docker
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp \
  bash scripts/day1/03_trim_fastq.sh

# Step 09 | Quarto line 1828 | Images and containers are not the same thing
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp \
  bash scripts/day1/03_trim_fastq.sh

# Step 10 | Quarto line 1871 | The same Docker image can also be used with Apptainer/Singularity
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp \
  bash scripts/day1/03_trim_fastq.sh

# Step 11 | Quarto line 1902 | The same Docker image can also be used with Apptainer/Singularity
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp \
  bash

