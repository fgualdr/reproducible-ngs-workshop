# Reproducible NGS workshop — extracted scripts (Day 0–4)

This package was generated from the five supplied Quarto lessons without changing the scientific workflow. Day 0 is setup; Days 1–3 are core practicals; Day 4 is an optional R integration exercise.

## Folder contents

Each `dayN/` contains:
- `source_quarto.qmd`: complete original lesson.
- `scripts/`: complete individual Bash/R scripts, with their original workshop-relative paths.
- `dayN_docker_calls.sh`: Docker invocations from that day, **in source order**, with `# Step` comments and corresponding Quarto line numbers.
- `dayN_terminal_examples.md`: other terminal examples, inspection commands, and demonstrations.

## Use with your workshop repository

These are **not** standalone data bundles. Commands assume the existing `workshop_ngs` repository, sequencing data, reference files, and results, with the relative paths described in the Quarto lessons. They are designed to run from the repository root, not from within `dayN/`.

1. Copy the script directories into the existing project while keeping the nested paths. On Linux/macOS/WSL, from this extracted ZIP directory, for example:

   ```bash
   mkdir -p ~/workshop_ngs/scripts
   for day in day1 day2 day3 day4; do
     if [ -d "$day/scripts" ]; then cp -R "$day/scripts/." ~/workshop_ngs/scripts/; fi
   done
   ```

2. Change directory to the workshop repo: `cd ~/workshop_ngs`.
3. Review the original lesson, create required folders and download prerequisite files as described there. The `dayN_terminal_examples.md` is a reference for the terminal checks and setup commands.
4. Open the day's `dayN_docker_calls.sh`, review optional/alternative Docker routes, then run **selected commands** from the file in lesson order. Do not execute the entire file without reviewing alternatives, internet tests and interactive examples.

The Day 2 Docker calls additionally include a clearly marked non-interactive `Rscript` invocation to run the complete extracted DESeq2 analysis.

Day 1 includes alternative ENA and SRA FASTQ acquisition routes; choose the route described for your setup. Day 0 has platform-specific setup. Day 4 is optional.

**Important:** Script code is extracted from the provided teaching notes, not verified against installed container images or datasets. Some snippets in the notes are intentionally interactive or conceptual, and are retained separately rather than made into misleading runnable scripts. The collected Docker calls are not a dependency-resolving automated workflow.

## Script inventory

### Day 0 (0 scripts; 6 Docker code blocks)


### Day 1 (4 scripts; 11 Docker code blocks)

- `scripts/day1/01_reference_genome_annotation.sh`
- `scripts/day1/02_download_ena_fastq.sh`
- `scripts/day1/04_download_sra_fastq.sh`
- `scripts/day1/03_trim_fastq.sh`

### Day 2 (6 scripts; 7 Docker code blocks)

- `scripts/day2_rnaseq/01_build_bowtie2_index.sh`
- `scripts/day2_rnaseq/02_map_bowtie2_sort_index.sh`
- `scripts/day2_rnaseq/03_featurecounts_all_samples.sh`
- `scripts/day2_rnaseq/05_make_bigwig_bamcoverage.sh`
- `scripts/day2_rnaseq/06_multiqc_day2.sh`
- `scripts/day2_rnaseq/04_deseq2_analysis.R`

### Day 3 (13 scripts; 13 Docker code blocks)

- `scripts/day3_chipseq/01_map_bowtie2_sort_filter.sh`
- `scripts/day3_chipseq/02_phantom_peak_qc.sh`
- `scripts/day3_chipseq/03_make_cpm_bigwigs.sh`
- `scripts/day3_chipseq/04_call_peaks_macs3.sh`
- `scripts/day3_chipseq/05_idr_pairwise_qc.sh`
- `scripts/day3_chipseq/05b_replicate_signal_correlation.sh`
- `scripts/day3_chipseq/05c_frip_qc.sh`
- `scripts/day3_chipseq/06_merge_peaks_and_count.sh`
- `scripts/day3_chipseq/07_peak_matrix_pca.R`
- `scripts/day3_chipseq/08_differential_peaks.R`
- `scripts/day3_chipseq/09_genomation_peak_profiles.R`
- `scripts/day3_chipseq/10_extract_peak_sequences.sh`
- `scripts/day3_chipseq/11_run_streme.sh`

### Day 4 (1 scripts; 1 Docker code blocks)

- `scripts/day4_optional/01_basic_integration.R`

