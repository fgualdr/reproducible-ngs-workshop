#!/usr/bin/env bash
set -euo pipefail

genome="reference_genome/genome.fa"
peaks="results/day3_chipseq/peaks/consensus/consensus_peaks.bed"
out_fasta="results/day3_chipseq/motifs/consensus_peak_sequences.fa"

mkdir -p results/day3_chipseq/motifs

bedtools getfasta \
  -fi "${genome}" \
  -bed "${peaks}" \
  -fo "${out_fasta}"
