#!/usr/bin/env bash
set -euo pipefail

fasta="results/day3_chipseq/motifs/consensus_peak_sequences.fa"
out_dir="results/day3_chipseq/motifs/streme"

streme \
  --p "${fasta}" \
  --dna \
  --oc "${out_dir}"
