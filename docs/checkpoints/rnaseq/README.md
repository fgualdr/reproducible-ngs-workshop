# RNA-seq checkpoints

Expected files may include:

- `sample_metadata.tsv`
- `featureCounts_all_samples.txt`
- `deseq2_results.tsv`
- `multiqc_report.html`

These files are not committed by default.

Count tables and BAM/bigWig checkpoints must be regenerated after mapping to `GCF_025998455.1`; do not use processed tables derived from another assembly.
