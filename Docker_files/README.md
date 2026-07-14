# Docker Images for the NGS Workshop

This folder contains task-specific Dockerfiles for the workshop commands. Each
image is intentionally narrow: one image per tool or small workflow step. This
keeps the teaching commands readable and avoids hiding the analysis in a large
pipeline image.

Students normally use the prebuilt images from Docker Hub. Rebuild these images
only when maintaining the workshop, changing tool versions, or preparing for a
class where internet access to Docker Hub is unreliable.

## Image Inventory

The current workshop pages and scripts use, or can be supported by, the
following runtime coverage.

| Workshop use | Dockerfile | Docker Hub image | Main commands |
|---|---|---|---|
| Day 1 ENA/reference downloads | `Dockerfile.curl` | `docker.io/fgualdr/ngs-curl:latest` | `curl`, `awk`, `gzip` |
| Day 1 optional SRA route | `Dockerfile.sra-tools` | `docker.io/fgualdr/ngs-sra-tools:latest` | `prefetch`, `fasterq-dump` |
| Day 1 FASTQ QC | `Dockerfile.fastqc` | `docker.io/fgualdr/ngs-fastqc:latest` | `fastqc` |
| Day 1 trimming/QC | `Dockerfile.fastp` | `docker.io/fgualdr/ngs-fastp:latest` | `fastp` |
| Optional NCBI datasets route | `Dockerfile.ncbi-datasets` | `docker.io/fgualdr/ngs-ncbi-datasets:latest` | `datasets`, `unzip` |
| Day 2/3 mapping and BAM cleanup | `Dockerfile.bowtie2-samtools` | `docker.io/fgualdr/ngs-bowtie2-samtools:latest` | `bowtie2`, `bowtie2-build`, `samtools` |
| Day 2 gene counting | `Dockerfile.featurecounts` | `docker.io/fgualdr/ngs-featurecounts:latest` | `featureCounts` |
| Day 2/4 R/Bioconductor | `Dockerfile.r-bioc` | `docker.io/fgualdr/ngs-r-bioc:latest` | `Rscript`, `DESeq2`, `tidyverse`, `GenomicRanges`, `rtracklayer` |
| Day 2 MultiQC report | `Dockerfile.multiqc` | `docker.io/fgualdr/ngs-multiqc:latest` | `multiqc` |
| Day 2/3 bigWig tracks | `Dockerfile.deeptools` | `docker.io/fgualdr/ngs-deeptools:latest` | `bamCoverage` |
| Day 3 ChIP-seq QC | `Dockerfile.chipseq-qc` | `docker.io/fgualdr/ngs-chipseq-qc:latest` | `run_spp.R`, `idr`, `samtools` |
| Day 3 peak calling | `Dockerfile.macs3` | `docker.io/fgualdr/ngs-macs3:latest` | `macs3` |
| Day 3 consensus peaks and FASTA extraction | `Dockerfile.bedtools` | `docker.io/fgualdr/ngs-bedtools:latest` | `bedtools merge`, `bedtools multicov`, `bedtools getfasta` |
| Day 3 motif discovery | `Dockerfile.streme` | `docker.io/fgualdr/ngs-streme:latest` | `streme` |

Day 0 uses public Docker test images such as `hello-world` and `alpine`; those
do not need workshop Dockerfiles.

The Day 2 page currently uses the upstream `multiqc/multiqc:latest` image.
`Dockerfile.multiqc` is included so the workshop can publish a pinned
`docker.io/fgualdr/ngs-multiqc:latest` equivalent when instructors want all
course images under the same Docker Hub namespace.

## Runtime Convention

All workshop images use `/work` as the working directory. Student commands mount
the repository root into `/work` and run a script from there:

```bash
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastqc:latest \
  bash scripts/day1/01_fastqc_raw.sh
```

Use two threads by default in scripts:

```bash
THREADS="${THREADS:-2}"
```

## Cross-Platform Strategy

The most reliable workshop target is `linux/amd64`.

Reason: many bioinformatics packages used here come from Bioconda. Bioconda
coverage is strongest for `linux/amd64`; native `linux/arm64` builds are not
guaranteed for every package. For a teaching workshop, a single tested
`linux/amd64` image per tool is more reliable than an untested multi-arch image.

Recommended approach:

1. Build and publish `linux/amd64` images.
2. Keep `--platform linux/amd64` in student `docker run` commands.
3. Let Docker Desktop emulate `linux/amd64` on Apple Silicon and Windows/WSL2.
4. Test the same run command on macOS, Windows WSL2, and Linux before class.

For Apple Silicon Macs, Docker Desktop may run these images through emulation.
That is usually acceptable for small teaching datasets. If performance is poor,
use checkpoint files or university machines rather than changing the lesson to
untested native ARM images.

## Optional True Multi-Arch Builds

Only build true multi-architecture images when every package in the image solves
and runs on each target platform.

Create and select a Buildx builder:

```bash
docker buildx create --name ngs-workshop-builder --use
docker buildx inspect --bootstrap
```

Build a test image for both `linux/amd64` and `linux/arm64`:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f Docker_files/Dockerfile.curl \
  -t docker.io/fgualdr/ngs-curl:latest \
  --push \
  .
```

Do not publish a multi-arch tag unless both platforms have been tested. For most
Bioconda-heavy images in this workshop, prefer the `linux/amd64` build commands
below.

## Login to Docker Hub

Authenticate before pushing:

```bash
docker login
```

Use a Docker Hub access token rather than an account password when possible.
The image names below assume the Docker Hub namespace is `fgualdr`.

## Build One Image

Run from the repository root:

```bash
docker buildx build \
  --platform linux/amd64 \
  -f Docker_files/Dockerfile.fastqc \
  -t docker.io/fgualdr/ngs-fastqc:latest \
  --load \
  .
```

Smoke test locally:

```bash
docker run --rm \
  --platform linux/amd64 \
  docker.io/fgualdr/ngs-fastqc:latest \
  fastqc --version
```

Push after the smoke test:

```bash
docker push docker.io/fgualdr/ngs-fastqc:latest
```

For a remote builder where `--load` is not available, build and push in one step:

```bash
docker buildx build \
  --platform linux/amd64 \
  -f Docker_files/Dockerfile.fastqc \
  -t docker.io/fgualdr/ngs-fastqc:latest \
  --push \
  .
```

## Build All Workshop Images

Run from the repository root after `docker login`.

```bash
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.curl -t docker.io/fgualdr/ngs-curl:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.sra-tools -t docker.io/fgualdr/ngs-sra-tools:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.fastqc -t docker.io/fgualdr/ngs-fastqc:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.fastp -t docker.io/fgualdr/ngs-fastp:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.ncbi-datasets -t docker.io/fgualdr/ngs-ncbi-datasets:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.bowtie2-samtools -t docker.io/fgualdr/ngs-bowtie2-samtools:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.featurecounts -t docker.io/fgualdr/ngs-featurecounts:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.r-bioc -t docker.io/fgualdr/ngs-r-bioc:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.multiqc -t docker.io/fgualdr/ngs-multiqc:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.deeptools -t docker.io/fgualdr/ngs-deeptools:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.chipseq-qc -t docker.io/fgualdr/ngs-chipseq-qc:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.macs3 -t docker.io/fgualdr/ngs-macs3:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.bedtools -t docker.io/fgualdr/ngs-bedtools:latest --push .
docker buildx build --platform linux/amd64 -f Docker_files/Dockerfile.streme -t docker.io/fgualdr/ngs-streme:latest --push .
```

## Versioned Tags

Use `latest` for student-facing workshop commands only after testing. For
maintenance, also publish a dated immutable tag:

```bash
TAG_DATE="2026-07"
docker buildx build \
  --platform linux/amd64 \
  -f Docker_files/Dockerfile.fastqc \
  -t docker.io/fgualdr/ngs-fastqc:latest \
  -t docker.io/fgualdr/ngs-fastqc:${TAG_DATE} \
  --push \
  .
```

The dated tag gives instructors a stable fallback if `latest` is rebuilt later.

## Suggested Smoke Tests

Run these after building or pulling images:

```bash
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-curl:latest curl --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-sra-tools:latest fasterq-dump --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-fastqc:latest fastqc --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-fastp:latest fastp --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-ncbi-datasets:latest datasets --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-bowtie2-samtools:latest bowtie2 --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-featurecounts:latest featureCounts -v
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-r-bioc:latest Rscript -e 'library(DESeq2); library(tidyverse); library(rtracklayer); sessionInfo()'
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-multiqc:latest multiqc --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-deeptools:latest bamCoverage --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-chipseq-qc:latest bash -lc 'command -v run_spp.R && idr --version'
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-macs3:latest macs3 --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-bedtools:latest bedtools --version
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-streme:latest streme --version
```

## Maintenance Checklist

Before a workshop release:

1. Confirm every `docker.io/fgualdr/ngs-*` image in the lessons has a matching
   Dockerfile in this folder.
2. Rebuild images only from committed Dockerfiles.
3. Run the smoke tests above.
4. Run at least one representative mounted-folder command with `-v "$PWD:/work"`.
5. Update this README if a lesson adds or removes a tool image.
6. Push both `latest` and a dated tag for images used in student commands.
7. Avoid changing student-facing image tags during a live workshop.
