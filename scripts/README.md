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
scripts/day1/01_reference_genome_annotation.sh
scripts/day1/02_download_ena_fastq.sh
scripts/day1/03_trim_fastq.sh
```

Optional future-use SRA example. This script downloads the two run-level
metadata reports from their SRA study accessions through the ENA Portal API,
retains the WT samples, downloads each paired run with `fasterq-dump`, and
renames the files to the same sample-based names used by the main ENA route:

```text
scripts/day1/04_optional_sra_download.sh
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

Day 1 download scripts that require only Bash and standard commands such as `curl`, `awk`, and `gzip` run directly on the host, for example:

```bash
bash scripts/day1/01_reference_genome_annotation.sh
```

The lesson pages retain `ngs-curl` as an optional fallback. Because network access inside a container uses Docker's DNS, proxy, and VPN configuration, the host command is preferred for downloads.

Scripts that require specialist bioinformatics tools run inside the matching Docker image, for example:

```bash
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp@sha256:67d843e80a94d529e9fbcc8e0767c3e018f62c1c9560087214dc1db998b74650 \
  bash scripts/day1/03_trim_fastq.sh
```

The `@sha256:...` digest identifies the exact runtime content; mutable tags such as `latest` are not used for analysis commands. The full release inventory is in `Docker_files/images.lock.tsv`. Matching Dockerfiles are retained as build recipes for the custom images.
