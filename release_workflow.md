# GitHub release workflow

This teaching repository is released progressively. Students should see only the material that has been released for the current workshop day.

Author and maintainer: Francesco Gualdrini.

Repository:

```text
https://github.com/fgualdr/Reproducible_NGS_Workshop
```

Published website:

```text
https://fgualdr.github.io/Reproducible_NGS_Workshop/
```

## Repository roles

This repository contains the Quarto teaching site.

Students create a separate analysis repository from `student_repo_template/`. Their repository is not a Quarto website. It contains `README.md`, `code/`, `container/`, `data/`, and `results/`.

## One-day-at-a-time release

Do not push future day pages to the public GitHub repository before they should be visible. Hiding a page from the sidebar is not sufficient because students can still browse files in a public repository.

Recommended workflow:

1. Keep unreleased material local or on a private branch.
2. Add the next day page and supporting scripts when ready.
3. Render the site.
4. Commit the source files and rendered `docs/` output.
5. Push to GitHub.

```bash
quarto render
git status
git add README.md _quarto.yml index.qmd days modules backends scripts student_repo_template docs
git commit -m "Release Day 1 reproducible project material"
git push
```

Use analogous commit messages for later days:

```text
Release Day 2 RNA-seq material
Release Day 3 ChIP-seq material
Release Day 4 integration material
```

## GitHub Pages setup

Render output is written to `docs/`.

In GitHub:

1. Open repository settings.
2. Select Pages.
3. Choose "Deploy from a branch".
4. Select branch `main`.
5. Select folder `/docs`.
6. Save.

The published URL will usually be:

```text
https://fgualdr.github.io/Reproducible_NGS_Workshop/
```

## Student daily commits

Students should commit their own repository at the end of each day:

```bash
git add README.md code container results
git commit -m "Add Day 1 project setup and metadata"
git push
```

For later days:

```text
Add RNA-seq workflow and results
Add ChIP-seq workflow and results
Add RNA-seq and ChIP-seq integration summary
```

Students should not commit FASTQ, BAM, BAI, bigWig, SRA, or large archive files.
