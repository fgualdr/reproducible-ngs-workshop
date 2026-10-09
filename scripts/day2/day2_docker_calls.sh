#!/usr/bin/env bash
set -euo pipefail

# Day 2 - Docker calls extracted from source_quarto.qmd
# Run from the ROOT of your existing workshop_ngs project.
# First copy this package's day-specific scripts/ directory into the project.
# This file lists teaching examples and ALTERNATIVE routes in source order.
# Review selections before executing; do not indiscriminately run every alternative.

# Step 01 | Quarto line 254 | 3.4 Build the Bowtie2 index
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-bowtie2-samtools \
  bash scripts/day2_rnaseq/01_build_bowtie2_index.sh

# Step 02 | Quarto line 412 | 3.5.6 Run the mapping workflow
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-bowtie2-samtools \
  bash scripts/day2_rnaseq/02_map_bowtie2_sort_index.sh

# Step 03 | Quarto line 493 | 3.6 Determine RNA-seq library strandedness
mkdir -p results/logs/day2

{
for f in results/day2_rnaseq/bam/*.filtered.bam; do
    echo
    echo "===== $f ====="

    docker run --rm \
      --user "$(id -u):$(id -g)" \
      -v "$PWD:/work" \
      -w /work \
      docker.io/getwilds/rseqc \
      infer_experiment.py \
      -i "$f" \
      -r reference_genome/genes.bed

done
} 2>&1 | tee results/logs/day2/rseqc_strandedness.log

# Step 04 | Quarto line 614 | 4. Count reads per gene with featureCounts
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-featurecounts \
  bash scripts/day2_rnaseq/03_featurecounts_all_samples.sh

# Step 05 | Quarto line 867 | 5.6 Build and inspect the DESeq2 analysis interactively
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-r-bioc \
  R --vanilla

# Additional reproducible non-interactive execution of the complete Day 2 R script.
# This is supplied for convenience; the Quarto lesson teaches this step interactively.
# The count table must already exist and results/day2_rnaseq/deseq2 must be writable.
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work -it \
  docker.io/fgualdr/ngs-r-bioc

# Step 06 | Quarto line 1352 | 6. Optional: make RNA-seq bigWig tracks with the DESeq2 size factors
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-deeptools \
  bash scripts/day2_rnaseq/05_make_bigwig_bamcoverage.sh

# Step 07 | Quarto line 1405 | 7. Summarize Day 2 logs with MultiQC
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/multiqc/multiqc \
  bash scripts/day2_rnaseq/06_multiqc_day2.sh

