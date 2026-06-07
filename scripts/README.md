# Script templates

These scripts are instructor examples and student-copyable templates. They avoid hard-coded absolute paths, default to `THREADS=2`, create output directories, and fail early when required commands or inputs are missing.

The scripts are intentionally generic because the final teaching dataset may change. Students should edit metadata tables and configuration files, not hard-code sample names inside scripts.

Heavy workflow scripts are not run by default during repository checks.

## Log convention

Scripts write command logs to the student repository under `results/logs/dayX/` by default, using numbered filenames such as:

```text
results/logs/day2/01_fastqc_raw.log
results/logs/day2/06_bowtie2_SAMPLE.log
results/logs/day3/08_macs3_with_input_SAMPLE.log
```

Set `LOGDIR` to override the destination:

```bash
LOGDIR=results/logs/day2 bash code/day2_rnaseq/01_fastqc_raw.sh samples.tsv data/raw_fastq/rnaseq results/rnaseq/qc/raw
```

Keeping logs in one ordered folder per day makes it easier to audit the workflow and to point MultiQC at a compact set of QC-relevant files.
