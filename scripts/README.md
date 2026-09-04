# Script templates

These scripts are student-copyable templates. They use relative paths from the
student repository root and deliberately keep the logic visible: simple
variables, `mkdir -p`, and `for` loops over FASTQ, BAM, peak, or FASTA files.

Day 1 owns FASTQ QC and trimming for both assays. Day 2 and Day 3 start from the
trimmed FASTQ files created on Day 1.

## Day 0 maintainer checks

Day 0 students use the self-contained copy-paste commands on the lesson page;
they do not need to clone this completed teaching repository. These two helper
scripts are for instructor or repository-maintainer checks:

```text
scripts/day0/check_host_setup.sh
scripts/day0/test_container_mount.sh
```

The lesson page is authoritative for student-facing Day 0 setup and readiness.

## Day 1

```text
scripts/day1/00_download_ena_fastq.sh
scripts/day1/02_trim_fastq.sh
scripts/day1/03_reference_genome_annotation.sh
```

Optional future-use SRA example:

```text
scripts/day1/example_sra_run_selector_download.sh
```

## Day 2 RNA-seq

```text
scripts/day2_rnaseq/01_build_bowtie2_index.sh
scripts/day2_rnaseq/02_map_bowtie2_sort_index.sh
scripts/day2_rnaseq/03_featurecounts_all_samples.sh
scripts/day2_rnaseq/04_deseq2_analysis.R
scripts/day2_rnaseq/05_make_bigwig_bamcoverage.sh
scripts/day2_rnaseq/06_multiqc_day2.sh
```

## Day 3 ChIP-seq

```text
scripts/day3_chipseq/01_map_bowtie2_sort_index.sh
scripts/day3_chipseq/02_phantom_peak_cross_correlation.sh
scripts/day3_chipseq/03_make_chipseq_bigwigs.sh
scripts/day3_chipseq/04_call_peaks_macs3_no_input.sh
scripts/day3_chipseq/05_idr_replicate_qc.sh
scripts/day3_chipseq/06_make_consensus_peak_counts.sh
scripts/day3_chipseq/07_extract_peak_sequences.sh
scripts/day3_chipseq/08_run_streme.sh
scripts/day3_chipseq/09_differential_peak_analysis.R
```

## Day 4 integration

```text
scripts/day4_integration/peak_gene_integration.R
```

## Runtime convention

Each shell script is meant to run inside the matching Docker image. The lesson page shows the run command, for example:

```bash
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp:latest \
  bash scripts/day1/02_trim_fastq.sh
```

The matching Dockerfiles are in `Docker_files/` for rebuilding images one tool at a time.
