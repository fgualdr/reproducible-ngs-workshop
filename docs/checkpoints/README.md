# Checkpoints

Checkpoint files allow every student to complete downstream analysis and interpretation even when local FASTQ processing fails.

Checkpoint mode still requires reproducibility documentation:

- Which steps were run directly.
- Which files were supplied as checkpoints.
- Which commands, inputs, parameters, and software versions would regenerate the checkpoint files.

Do not commit large checkpoint data into this repository unless explicitly approved. Use `MANIFEST.tsv` and checksums to document distributed files.

All workshop checkpoints must be generated against RefSeq assembly `GCF_025998455.1` (`ASM2599845v1`, chromosome `NZ_AP026446.1`). Files in another coordinate system are not interchangeable checkpoints.
