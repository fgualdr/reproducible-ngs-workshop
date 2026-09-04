# Configuration files

These files are examples and should be copied into student repositories before editing.

- `teaching_subset_samples.csv`: WT-only oxidative-stress teaching subset for RNA-seq and ChIP-seq.

SRA Toolkit is shown in Day 1 as a future-use example, not as the main workshop download route.

## Progressive Quarto release files

The root-level `_quarto-day*.yml` files are Quarto project profiles for
publishing the website one workshop day at a time. Each profile is cumulative:
for example, `day2` publishes Day 0, Day 1, and Day 2.

Choose the release day (`0` through `4`) and render its profile from a clean
output folder:

```bash
make clean-rendered
quarto render --profile day1
```

Use exactly one day profile at a time. Activating multiple day profiles would
merge their page lists.

Then commit the profile, released source material, and rendered `docs/` folder.
The default profile is recorded under `profile.default` in `_quarto.yml`, so a
plain `quarto render` uses the currently released day. Change that one value
from `day0` to `day1`, and so on, when each release becomes public.

Release order:

- `_quarto-day0.yml`: Home, Day 0, Git/GitHub module, Docker module.
- `_quarto-day1.yml`: Adds Day 1, public data retrieval, and reference genome modules.
- `_quarto-day2.yml`: Adds Day 2 and the RNA-seq module.
- `_quarto-day3.yml`: Adds Day 3 and the ChIP-seq module.
- `_quarto-day4.yml`: Adds Day 4, genomic intervals, scripts, checkpoints, and assessment.

Early releases intentionally omit the global Scripts page because it lists
future-day scripts.
