# Reproducible NGS Data Analysis

A practical workshop on reproducible RNA-seq and ChIP-seq analysis using public sequencing datasets, containers, Git/GitHub, and modern bioinformatics workflows.

[![Course Website](https://img.shields.io/badge/Course%20Website-Visit-blue)](https://fgualdr.github.io/reproducible-ngs-workshop/)

---

## Course Website

The complete workshop material is available as a browsable website:

👉 **https://fgualdr.github.io/reproducible-ngs-workshop/**

The website contains all lessons, practical exercises, conceptual modules, workflow descriptions, supporting resources, and assessment guidelines.

---

## Overview

This workshop introduces a reproducible approach to next-generation sequencing (NGS) data analysis using small-scale RNA-seq and ChIP-seq datasets.

The material emphasizes:

* Reproducible computational research
* Git and GitHub for scientific projects
* Containerized bioinformatics using Docker and Podman
* Public sequencing repositories (GEO, SRA, ENA, ArrayExpress)
* RNA-seq analysis and differential expression
* ChIP-seq analysis, peak calling, and motif discovery
* Genomic intervals and peak-to-gene integration
* Scientific reporting and project documentation

The practical examples focus on bacterial-scale datasets that can be explored on personal laptops while introducing concepts that readily scale to larger projects and institutional computing infrastructures.

---

## Workshop Structure

| Day   | Topic                                                               |
| ----- | ------------------------------------------------------------------- |
| Day 0 | Technical setup and software installation                           |
| Day 1 | Reproducible projects, public data retrieval, and reference genomes |
| Day 2 | RNA-seq analysis                                                    |
| Day 3 | ChIP-seq analysis                                                   |
| Day 4 | Integration, visualization, and biological interpretation           |

Additional modules provide background material on:

* Git and GitHub
* Containers
* Public sequencing repositories
* Reference genomes and annotations
* RNA-seq concepts
* ChIP-seq concepts
* Genomic intervals
* Alternative execution backends

---

## Repository Contents

```text
days/                   Main workshop lessons
modules/                Conceptual background material
scripts/                Example workflow scripts
containers/             Docker and Podman environments
checkpoints/            Example outputs and fallback resources
config/                 Metadata templates and examples
student_repo_template/  Template repository for participants
assessments/            Rubrics and submission material
instructor/             Instructor notes and administration
```

---

## Example Datasets

The workshop uses publicly available datasets and example metadata derived from small bacterial genomes suitable for laptop-scale analysis.

Current example datasets include:

* *Helicobacter pylori* RNA-seq (E-MTAB-13025)
* *Helicobacter pylori* ChIP-seq (E-MTAB-13026)

Additional datasets may be incorporated in future releases.

---

## Intended Audience

This material is primarily aimed at:

* PhD students
* Early-career researchers
* Bioinformaticians entering NGS analysis
* Researchers interested in reproducible computational workflows

A basic familiarity with molecular biology is assumed. No prior experience with command-line bioinformatics is required.

---

## Citation

If you use or adapt this material, please refer to the citation information provided in:

```text
CITATION.cff
```

---

## License

See the `LICENSE` file for licensing information.
