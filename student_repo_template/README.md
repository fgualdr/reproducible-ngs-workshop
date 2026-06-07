# Reproducible NGS project

This is the student analysis repository. It is intentionally simpler than the workshop teaching-material repository.

Use this `README.md` as the main record of the work: what was run, with which inputs, which outputs were produced, and which checkpoint files were used when local execution failed.

## Biological question

TODO: state the organism, condition, assay, and biological comparison.

## Repository structure

```text
.
├── README.md
├── code/
│   ├── day1/
│   ├── day2_rnaseq/
│   ├── day3_chipseq/
│   └── day4_integration/
├── container/
│   ├── ngs-cli/
│   └── ngs-r/
├── data/
│   ├── raw_fastq/
│   ├── trimmed_fastq/
│   ├── genome/
│   ├── bam/
│   ├── raw_counts/
│   └── macs_peaks/
└── results/
    ├── rnaseq/
    ├── chipseq/
    ├── integration/
    └── logs/
```

Large files in `data/` are local working files and are ignored by Git.

Command logs are stored in `results/logs/day0/`, `results/logs/day1/`, and so on. Use numbered names such as `01_fastqc_raw.log` so the execution order is clear.

## Questions and issues

If you have a GitHub account, ask workshop questions by opening an Issue in this repository. Include:

- the day and step;
- your operating system;
- the command you ran;
- the exact error message;
- the relevant log file path, for example `results/logs/day1/03_get_ena_metadata.log`.

If you cannot create or access a GitHub account, email:

```text
francesco.gualdrini@gmail.com
```

## Data

- RNA-seq accessions: TODO.
- ChIP-seq accessions: TODO.
- Reference genome: TODO.
- Annotation: TODO.

## Execution backend

TODO: local Docker/Podman, partial local plus checkpoints, or checkpoint mode.

## Workflow

### Day 1 - Project setup and public data

TODO: repository setup, container recipe, metadata inspection, selected accessions, FASTQ retrieval or checkpoint route.

### Day 2 - RNA-seq

TODO: QC, trimming, mapping, counting, DESeq2, plots, checkpoint use if relevant.

### Day 3 - ChIP-seq

TODO: QC, trimming, mapping, peak calling, bigWig tracks, metaplots, motif or checkpoint use if relevant.

### Day 4 - Integration

TODO: link differential expression with nearby peaks, figures, interpretation, limitations.

## Limitations

TODO: document replicate count, checkpoint use, incomplete local execution, or biological caveats.

## Commit checkpoints

Suggested commits:

```text
Initialize reproducible NGS project structure
Add Day 1 metadata and data retrieval notes
Add RNA-seq workflow and results
Add ChIP-seq workflow and results
Add RNA-seq and ChIP-seq integration summary
```
