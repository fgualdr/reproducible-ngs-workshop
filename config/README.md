# Configuration files

These files are examples and should be copied into student repositories before editing.

- `teaching_subset_samples.csv`: WT-only oxidative-stress teaching subset for RNA-seq and ChIP-seq.

SRA Toolkit is shown in Day 1 as a future-use example, not as the main workshop download route.

## Progressive Quarto release files

The `_quarto_day*.yml` files are copy-paste templates for publishing the
website one workshop day at a time.

Choose the release day (`0` through `4`) and render from a clean output folder:

```bash
release_day=1
cp "config/_quarto_day${release_day}.yml" _quarto.yml
rm -rf docs
quarto render
```

Then commit the updated `_quarto.yml` and rendered `docs/` folder.
The repository's current `_quarto.yml` is the complete Day 4 configuration.

Release order:

- `config/_quarto_day0.yml`: Home, Day 0, Git/GitHub module, Docker module.
- `config/_quarto_day1.yml`: Adds Day 1, public data retrieval, and reference genome modules.
- `config/_quarto_day2.yml`: Adds Day 2 and the RNA-seq module.
- `config/_quarto_day3.yml`: Adds Day 3 and the ChIP-seq module.
- `config/_quarto_day4.yml`: Adds Day 4, genomic intervals, scripts, checkpoints, and assessment.

Early releases intentionally omit the global Scripts page because it lists
future-day scripts.
