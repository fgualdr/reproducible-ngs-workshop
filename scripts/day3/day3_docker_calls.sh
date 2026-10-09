#!/usr/bin/env bash
set -euo pipefail

# Day 3 - Docker calls extracted from source_quarto.qmd
# Run from the ROOT of your existing workshop_ngs project.
# First copy this package's day-specific scripts/ directory into the project.
# This file lists teaching examples and ALTERNATIVE routes in source order.
# Review selections before executing; do not indiscriminately run every alternative.

# Step 01 | Quarto line 208 | 3.1 Mapping and filtering script
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-bowtie2-samtools \
  bash scripts/day3_chipseq/01_map_bowtie2_sort_filter.sh

# Step 02 | Quarto line 350 | 4.2 `phantompeakqualtools`
docker run --rm \
  --user "$(id -u):$(id -g)" \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  quay.io/biocontainers/phantompeakqualtools:1.2.2--hdfd78af_1 \
  bash scripts/day3_chipseq/02_phantom_peak_qc.sh

# Step 03 | Quarto line 413 | 4.3 Make CPM-normalized fragment coverage with `bamCoverage`
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-deeptools \
  bash scripts/day3_chipseq/03_make_cpm_bigwigs.sh

# Step 04 | Quarto line 694 | 5.4 Run MACS3 on each sample
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-macs3 \
  bash scripts/day3_chipseq/04_call_peaks_macs3.sh

# Step 05 | Quarto line 864 | Run pairwise IDR
docker run --rm \
  --user "$(id -u):$(id -g)" \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  quay.io/biocontainers/idr:2.0.4.2--py39h031d066_12 \
  bash scripts/day3_chipseq/05_idr_pairwise_qc.sh

# Step 06 | Quarto line 970 | 6.2 Replicate signal correlation with deepTools
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-deeptools \
  bash scripts/day3_chipseq/05b_replicate_signal_correlation.sh

# Step 07 | Quarto line 1050 | 6.3 FRiP: fraction of usable fragments in called peaks
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-deeptools \
  bash scripts/day3_chipseq/05c_frip_qc.sh

# Step 08 | Quarto line 1145 | 7. Build one common peak set and count matrix
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-bedtools \
  bash scripts/day3_chipseq/06_merge_peaks_and_count.sh

# Step 09 | Quarto line 1298 | 8. PCA of the common peak-count matrix
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-r-bioc \
  Rscript scripts/day3_chipseq/07_peak_matrix_pca.R

# Step 10 | Quarto line 1484 | 9. Differential peak occupancy with DESeq2
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-r-bioc \
  Rscript scripts/day3_chipseq/08_differential_peaks.R

# Step 11 | Quarto line 1639 | 10. Minimal genomation profiles and heatmaps
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-r-bioc \
  Rscript scripts/day3_chipseq/09_genomation_peak_profiles.R

# Step 12 | Quarto line 1805 | 11.5 Extract DNA under the merged peaks
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-bedtools \
  bash scripts/day3_chipseq/10_extract_peak_sequences.sh

# Step 13 | Quarto line 1847 | 11.6 Run STREME with its default DNA background
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-streme \
  bash scripts/day3_chipseq/11_run_streme.sh

