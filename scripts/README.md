# Script templates

These scripts are student-copyable templates. They use relative paths from the
student repository root and deliberately keep the logic visible: simple
variables, `mkdir -p`, and `for` loops over FASTQ, BAM, peak, or FASTA files.

Day 1 owns FASTQ QC and trimming for both assays. Day 2 and Day 3 start from the
trimmed FASTQ files created on Day 1.

## Day 1

```text
scripts/day1/00_download_ena_fastq.sh
scripts/day1/01_fastqc_raw.sh
scripts/day1/02_trim_fastq.sh
scripts/day1/03_reference_genome_annotation.sh
scripts/day1/04_fastqc_trimmed.sh
```

Optional future-use SRA example:

```text
scripts/day1/example_sra_run_selector_download.sh
```

## Day 2 RNA-seq

```text
scripts/day2_rnaseq/01_build_bowtie2_index.sh
scripts/day2_rnaseq/02_map_bowtie2_sort_index.sh
scripts/day2_rnaseq/03_featurecounts_per_sample.sh
scripts/day2_rnaseq/04_merge_featurecounts.R
scripts/day2_rnaseq/05_make_bigwig_bamcoverage.sh
scripts/day2_rnaseq/06_deseq2_analysis.R
```

## Day 3 ChIP-seq

```text
scripts/day3_chipseq/01_map_bowtie2_sort_index.sh
scripts/day3_chipseq/02_make_chipseq_bigwigs.sh
scripts/day3_chipseq/03_call_peaks_macs3_no_input.sh
scripts/day3_chipseq/04_extract_peak_sequences.sh
scripts/day3_chipseq/05_run_streme.sh
```

## Runtime convention

Each shell script is meant to run inside the matching Docker image. The lesson page shows the run command, for example:

```bash
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastqc:latest \
  bash scripts/day1/01_fastqc_raw.sh
```

The matching Dockerfiles are in `Docker_files/` for rebuilding images one tool at a time.
