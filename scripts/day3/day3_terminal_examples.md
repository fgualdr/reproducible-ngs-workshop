# Day 3 — terminal commands and examples

Extracted verbatim as reference; some are interactive, illustrative, platform-specific or alternatives. Do not execute indiscriminately.

```bash
# Quarto line 11
cd ~/workshop_ngs
pwd
```

```bash
# Quarto line 26
ls -lh results/day1_qc/trimmed_fastq/chipseq/*.trimmed.fastq.gz
ls -lh reference_genome/genome.fa
ls -lh reference_genome/bowtie2_index/genome*.bt2
grep '^>' reference_genome/genome.fa | grep 'NZ_AP026446.1'
```

```bash
# Quarto line 107
mkdir -p scripts/day3_chipseq
mkdir -p results/day3_chipseq/bam
mkdir -p results/day3_chipseq/qc/phantom_peak
mkdir -p results/day3_chipseq/qc/replicate_correlation
mkdir -p results/day3_chipseq/qc/frip
mkdir -p results/day3_chipseq/qc/peak_counts
mkdir -p results/day3_chipseq/bigwig
mkdir -p results/day3_chipseq/peaks/no_input
mkdir -p results/day3_chipseq/peaks/consensus
mkdir -p results/day3_chipseq/idr
mkdir -p results/day3_chipseq/counts
mkdir -p results/day3_chipseq/differential_peaks
mkdir -p results/day3_chipseq/genomation
mkdir -p results/day3_chipseq/motifs/streme
mkdir -p results/logs/day3
```

```bash
# Quarto line 148
nano scripts/day3_chipseq/01_map_bowtie2_sort_filter.sh
```

```bash
# Quarto line 219
ls -lh results/day3_chipseq/bam/*.sorted.bam
ls -lh results/day3_chipseq/bam/*.filtered.bam
cat results/logs/day3/*.bowtie2.log
cat results/logs/day3/*.filtered.flagstat.txt
```

```bash
# Quarto line 230
samtools view -b -q 10 -f 2 -F 2828
```

```bash
# Quarto line 305
nano scripts/day3_chipseq/02_phantom_peak_qc.sh
```

```bash
# Quarto line 362
column -t -s $'\t' results/day3_chipseq/qc/phantom_peak/phantom_peak_summary.tsv
find results/day3_chipseq/qc/phantom_peak -name '*.pdf' | sort
```

```bash
# Quarto line 381
nano scripts/day3_chipseq/03_make_cpm_bigwigs.sh
```

```bash
# Quarto line 424
ls -lh results/day3_chipseq/bigwig/*.cpm.bw
```

```bash
# Quarto line 658
nano scripts/day3_chipseq/04_call_peaks_macs3.sh
```

```bash
# Quarto line 705
wc -l results/day3_chipseq/peaks/no_input/*_peaks.narrowPeak
```

```bash
# Quarto line 752
wc -l results/day3_chipseq/peaks/no_input/*_peaks.narrowPeak
```

```bash
# Quarto line 817
nano scripts/day3_chipseq/05_idr_pairwise_qc.sh
```

```bash
# Quarto line 876
ls -lh results/day3_chipseq/idr/*.idr.narrowPeak
ls -lh results/day3_chipseq/idr/*.png
wc -l results/day3_chipseq/idr/*.idr.narrowPeak
```

```bash
# Quarto line 923
nano scripts/day3_chipseq/05b_replicate_signal_correlation.sh
```

```bash
# Quarto line 981
cat results/day3_chipseq/qc/replicate_correlation/spearman_correlation.tsv
ls -lh results/day3_chipseq/qc/replicate_correlation/*.pdf
```

```bash
# Quarto line 1008
nano scripts/day3_chipseq/05c_frip_qc.sh
```

```bash
# Quarto line 1061
column -t -s $'\t' results/day3_chipseq/qc/frip/frip_summary.tsv
```

```bash
# Quarto line 1097
nano scripts/day3_chipseq/06_merge_peaks_and_count.sh
```

```bash
# Quarto line 1156
head results/day3_chipseq/peaks/consensus/consensus_peaks.bed
head results/day3_chipseq/counts/consensus_peak_counts.tsv
wc -l results/day3_chipseq/peaks/consensus/consensus_peaks.bed
```

```bash
# Quarto line 1180
nano scripts/day3_chipseq/07_peak_matrix_pca.R
```

```bash
# Quarto line 1309
ls -lh results/day3_chipseq/qc/peak_counts/pca*.pdf
```

```bash
# Quarto line 1340
nano scripts/day3_chipseq/08_differential_peaks.R
```

```bash
# Quarto line 1495
ls -lh results/day3_chipseq/differential_peaks
head results/day3_chipseq/differential_peaks/differential_peak_results.tsv
head results/day3_chipseq/differential_peaks/top_differential_peaks.tsv
wc -l results/day3_chipseq/differential_peaks/significant_differential_peaks.bed
```

```bash
# Quarto line 1525
nano scripts/day3_chipseq/09_genomation_peak_profiles.R
```

```bash
# Quarto line 1650
ls -lh results/day3_chipseq/genomation
```

```bash
# Quarto line 1781
nano scripts/day3_chipseq/10_extract_peak_sequences.sh
```

```bash
# Quarto line 1816
head results/day3_chipseq/motifs/consensus_peak_sequences.fa
```

```bash
# Quarto line 1826
nano scripts/day3_chipseq/11_run_streme.sh
```

```bash
# Quarto line 1858
find results/day3_chipseq/motifs/streme -maxdepth 1 -type f | sort
```

