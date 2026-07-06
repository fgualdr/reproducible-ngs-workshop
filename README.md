# Reproducible NGS Data Analysis

A practical workshop on reproducible RNA-seq and ChIP-seq analysis using public sequencing datasets, containers, Git/GitHub, and modern bioinformatics workflows.

---

## Course Website

The complete workshop material is available online:

➡️ **https://fgualdr.github.io/reproducible-ngs-workshop/**

The website contains:

- Day-by-day lessons
- Conceptual modules
- Practical exercises
- Workflow scripts
- Task-specific Dockerfile instructions
- Submission checklist

---

## Workshop Overview

Modern sequencing projects require more than the ability to run bioinformatics tools. Reproducible research depends on well-organized projects, documented workflows, version control, portable software environments, and clear reporting.

This workshop introduces a practical framework for organizing and executing RNA-seq and ChIP-seq analyses using publicly available datasets and lightweight computational infrastructures.

Topics include:

- Reproducible computational research
- Git and GitHub for scientific projects
- Docker containers
- Public sequencing repositories (GEO, SRA, ENA, ArrayExpress)
- RNA-seq analysis and differential expression
- ChIP-seq analysis, peak calling, and motif discovery
- Genomic intervals and peak-to-gene integration
- Scientific reporting and project documentation

The practical examples focus on bacterial-scale datasets that can be explored on personal laptops while introducing concepts that readily scale to larger projects and institutional computing infrastructures.

---

## Workshop Structure

| Day | Topic |
|------|------|
| Day 0 | Technical setup and software installation |
| Day 1 | Reproducible project setup, FASTQ QC/trimming, and reference files |
| Day 2 | RNA-seq analysis |
| Day 3 | ChIP-seq analysis |
| Day 4 | Integration, visualization, and biological interpretation |

Additional modules provide background material on:

- Git and GitHub
- Containers
- Public sequencing repositories
- Reference genomes and annotations
- RNA-seq concepts
- ChIP-seq concepts
- Genomic intervals

---

## Repository Organization

```text
days/                   Main workshop lessons
modules/                Conceptual background material
scripts/                Example workflow scripts
Docker_files/           Simple task-specific Dockerfiles
checkpoints/            Example outputs and fallback resources
config/                 Metadata templates and examples
assessments/            Student submission checklist
```

---

## Example Datasets

The workshop uses publicly available datasets and example metadata derived from small bacterial genomes suitable for laptop-scale analysis.

Current examples include:

- *Helicobacter pylori* RNA-seq (E-MTAB-13025)
- *Helicobacter pylori* ChIP-seq (E-MTAB-13026)

Additional datasets may be incorporated in future releases.

---

## Intended Audience

This material is primarily aimed at:

- PhD students
- Bioinformaticians entering NGS analysis
- Researchers interested in reproducible computational workflows

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
