# Checkpoints

Checkpoint files allow every student to complete downstream analysis and interpretation even when local FASTQ processing fails.

Checkpoint mode still requires reproducibility documentation:

- Which steps were run directly.
- Which files were supplied as checkpoints.
- Which commands, inputs, parameters, and software versions would regenerate the checkpoint files.

Do not commit large checkpoint data into this repository unless explicitly approved. Use `MANIFEST.tsv` and checksums to document distributed files.

