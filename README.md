# Reproducible NGS Data Analysis on Personal Laptops

Public teaching-material repository for a PhD practical workshop on reproducible public RNA-seq and ChIP-seq analysis using personal laptops, containers, Git/GitHub, Quarto, and checkpoint-based fallback files.

This repository is the course website and instructor-administered source of teaching material. It is not a finished student analysis repository. Students create their own simpler GitHub repositories during the workshop.

Author and maintainer: Francesco Gualdrini.

Repository:

```text
https://github.com/fgualdr/reproducible-ngs-workshop
```

Published website:

```text
https://fgualdr.github.io/reproducible-ngs-workshop/
```

## Student support

Students who can access GitHub should ask technical questions by opening Issues in their own workshop repositories. This keeps commands, logs, errors, and replies traceable.

Students who cannot create or access a GitHub account can email:

```text
francesco.gualdrini@gmail.com
```

## Render the site

```bash
quarto render
```

The teaching site renders to:

```text
docs/index.html
```

The `docs/` directory is used so GitHub Pages can publish the rendered Quarto site directly from the `main` branch.

If Quarto is unavailable, the files are still readable as plain Markdown/Quarto.

## Lightweight validation

```bash
bash scripts_check_project.sh
```

## Main directories

- `days/`: Day 0-Day 4 Quarto lessons.
- `modules/`: reusable conceptual material.
- `backends/`: execution backend pages.
- `scripts/`: workflow script templates.
- `student_repo_template/`: simple starter layout students copy into their own GitHub repositories.
- `config/`: example metadata and candidate datasets.
- `containers/`: Docker/Podman recipes, Dockerfiles, Containerfiles, and devcontainer material.
- `checkpoints/`: fallback file manifests and documentation.
- `assessments/`: rubrics and submission checklists.
- `instructor/`: course administration notes kept out of the rendered public navigation unless explicitly linked.

## Release model

The public site should grow one workshop day at a time. Keep unreleased future day pages local or on a private branch, then render and push only the material that should be visible.

```bash
quarto render
git add README.md _quarto.yml index.qmd days modules scripts student_repo_template docs
git commit -m "Release Day 1 workshop material"
git push
```

On GitHub, enable Pages from branch `main` and folder `/docs`.
