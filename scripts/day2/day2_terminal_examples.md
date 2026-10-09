# Day 2 — terminal commands and examples

Extracted verbatim as reference; some are interactive, illustrative, platform-specific or alternatives. Do not execute indiscriminately.

```bash
# Quarto line 17
cd ~/workshop_ngs
pwd
```

```bash
# Quarto line 32
ls -lh results/day1_qc/trimmed_fastq/rnaseq/*.trimmed.fastq.gz
```

```bash
# Quarto line 38
ls -lh reference_genome/genome.fa
ls -lh reference_genome/annotation.gff3
ls -lh reference_genome/genes.bed
grep '^>' reference_genome/genome.fa | grep 'NZ_AP026446.1'
grep -v '^#' reference_genome/annotation.gff3 | head -1
head -1 reference_genome/genes.bed
```

```bash
# Quarto line 102
mkdir -p scripts/day2_rnaseq
mkdir -p results/day2_rnaseq/bam
mkdir -p results/day2_rnaseq/counts
mkdir -p results/day2_rnaseq/bigwig
mkdir -p results/day2_rnaseq/deseq2
mkdir -p results/logs/day2
```

```bash
# Quarto line 231
nano scripts/day2_rnaseq/01_build_bowtie2_index.sh
```

```bash
# Quarto line 269
nano scripts/day2_rnaseq/02_map_bowtie2_sort_index.sh
```

```bash
# Quarto line 364
samtools sort \
  -@ 2 \
  -O BAM \
  -o "${bam_file}" \
  "${sam_file}"
```

```bash
# Quarto line 384
samtools view \
  -@ 2 \
  -b \
  -q 10 \
  -f 2 \
  -F 2828 \
  -o "${filtered_bam}" \
  "${bam_file}"
```

```bash
# Quarto line 423
ls -lh results/logs/day2/*.bowtie2.log
cat results/logs/day2/*.bowtie2.log
```

```bash
# Quarto line 445
ls -lh results/logs/day2/*.flagstat.txt
cat results/logs/day2/*.flagstat.txt
```

```bash
# Quarto line 538
nano scripts/day2_rnaseq/03_featurecounts_all_samples.sh
```

```bash
# Quarto line 625
ls -lh results/logs/day2/featureCounts_all_samples.log
cat results/logs/day2/featureCounts_all_samples.log
ls -lh results/day2_rnaseq/counts/featureCounts_all_samples.txt
ls -lh results/day2_rnaseq/counts/featureCounts_all_samples.txt.summary
head results/day2_rnaseq/counts/featureCounts_all_samples.txt
cat results/day2_rnaseq/counts/featureCounts_all_samples.txt.summary
```

```bash
# Quarto line 1315
nano scripts/day2_rnaseq/05_make_bigwig_bamcoverage.sh
```

```bash
# Quarto line 1376
nano scripts/day2_rnaseq/06_multiqc_day2.sh
```

```bash
# Quarto line 1456
mkdir -p results/day2_rnaseq/counts
cp checkpoints/rnaseq/featureCounts_all_samples.txt \
  results/day2_rnaseq/counts/featureCounts_all_samples.txt
```

```bash
# Quarto line 1478
git status
```

```bash
# Quarto line 1486
git add scripts/day2_rnaseq
git add results/logs/day2
git add results/day2_rnaseq/counts/featureCounts_all_samples.txt
git add results/day2_rnaseq/counts/gene_count_matrix.tsv
git add results/day2_rnaseq/deseq2
git add results/day2_rnaseq/qc/multiqc_report.html
git add workflow_execution.md README.md
git status
```

```bash
# Quarto line 1501
git commit -m "Complete Day 2 RNA-seq mapping counts and DESeq2"
git push
```

