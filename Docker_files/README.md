# Docker Images for the NGS Workshop

This folder contains the task-specific Dockerfiles used by the workshop. Each custom image is intentionally narrow: one image per tool or small workflow step. This keeps the teaching commands readable and makes the software environment explicit.

## Multi-architecture policy

All custom `fgualdr` workshop images are intended to be published as a single Docker tag containing both:

- `linux/amd64` — Intel/AMD Linux, Intel Macs, and the usual Windows/WSL2 route;
- `linux/arm64` — Apple Silicon Macs and ARM64 Linux.

Student-facing `docker run` commands should therefore **not** force `--platform linux/amd64`. Docker should select the native image automatically.

`--platform` remains useful for maintainer smoke tests, where both architectures are tested deliberately.

Publishing with the existing tag `:latest` updates/overwrites the previous Docker Hub `latest` reference with the newly pushed multi-platform manifest.

## Custom image inventory

| Dockerfile | Docker Hub image | Main commands |
|---|---|---|
| `Dockerfile.curl` | `docker.io/fgualdr/ngs-curl:latest` | `curl`, `awk`, `gzip` |
| `Dockerfile.sra-tools` | `docker.io/fgualdr/ngs-sra-tools:latest` | `curl`, `prefetch`, `fasterq-dump`, `pigz` |
| `Dockerfile.fastqc` | `docker.io/fgualdr/ngs-fastqc:latest` | `fastqc` |
| `Dockerfile.fastp` | `docker.io/fgualdr/ngs-fastp:latest` | `fastp` |
| `Dockerfile.ncbi-datasets` | `docker.io/fgualdr/ngs-ncbi-datasets:latest` | `datasets`, `unzip` |
| `Dockerfile.bowtie2-samtools` | `docker.io/fgualdr/ngs-bowtie2-samtools:latest` | `bowtie2`, `bowtie2-build`, `samtools` |
| `Dockerfile.featurecounts` | `docker.io/fgualdr/ngs-featurecounts:latest` | `featureCounts` |
| `Dockerfile.rseqc` | `docker.io/fgualdr/ngs-rseqc:latest` | `infer_experiment.py` |
| `Dockerfile.r-bioc` | `docker.io/fgualdr/ngs-r-bioc:latest` | `Rscript`, DESeq2, GenomicRanges, rtracklayer |
| `Dockerfile.multiqc` | `docker.io/fgualdr/ngs-multiqc:latest` | `multiqc` |
| `Dockerfile.deeptools` | `docker.io/fgualdr/ngs-deeptools:latest` | `bamCoverage` |
| `Dockerfile.chipseq-qc` | `docker.io/fgualdr/ngs-chipseq-qc:latest` | `run_spp.R`, `idr`, `samtools` |
| `Dockerfile.macs3` | `docker.io/fgualdr/ngs-macs3:latest` | `macs3` |
| `Dockerfile.bedtools` | `docker.io/fgualdr/ngs-bedtools:latest` | `bedtools` |
| `Dockerfile.streme` | `docker.io/fgualdr/ngs-streme:latest` | `streme` |

## One-time Buildx setup

If the `multiarch` builder does not yet exist:

```bash
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap
```

If it already exists:

```bash
docker buildx use multiarch
docker buildx inspect --bootstrap
```

The platform list must include both `linux/amd64` and `linux/arm64`.

Authenticate once:

```bash
docker login
```

## Build location

Run all build commands from the repository root:

```bash
cd /Users/ieo5244/Documents/NGS_Workshop
```

The Dockerfiles are expected under `Docker_files/`.

## Rebuild every image and overwrite `latest`

Each command builds both architectures and pushes the multi-platform image directly to Docker Hub.

### curl

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.curl -t docker.io/fgualdr/ngs-curl:latest --push .
```

### SRA Toolkit

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.sra-tools -t docker.io/fgualdr/ngs-sra-tools:latest --push .
```

### FastQC

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.fastqc -t docker.io/fgualdr/ngs-fastqc:latest --push .
```

### fastp

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.fastp -t docker.io/fgualdr/ngs-fastp:latest --push .
```

### NCBI Datasets

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.ncbi-datasets -t docker.io/fgualdr/ngs-ncbi-datasets:latest --push .
```

### Bowtie2 + samtools

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.bowtie2-samtools -t docker.io/fgualdr/ngs-bowtie2-samtools:latest --push .
```

### featureCounts

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.featurecounts -t docker.io/fgualdr/ngs-featurecounts:latest --push .
```

### RSeQC

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.rseqc -t docker.io/fgualdr/ngs-rseqc:latest --push .
```

### R / Bioconductor

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.r-bioc -t docker.io/fgualdr/ngs-r-bioc:latest --push .
```

### MultiQC

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.multiqc -t docker.io/fgualdr/ngs-multiqc:latest --push .
```

### deepTools

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.deeptools -t docker.io/fgualdr/ngs-deeptools:latest --push .
```

### ChIP-seq QC

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.chipseq-qc -t docker.io/fgualdr/ngs-chipseq-qc:latest --push .
```

### MACS3

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.macs3 -t docker.io/fgualdr/ngs-macs3:latest --push .
```

### BEDTools

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.bedtools -t docker.io/fgualdr/ngs-bedtools:latest --push .
```

### STREME / MEME Suite

```bash
docker buildx build --builder multiarch --platform linux/amd64,linux/arm64 --pull -f Docker_files/Dockerfile.streme -t docker.io/fgualdr/ngs-streme:latest --push .
```

The same commands are available in `rebuild_multiarch.sh`.

## Verify each published manifest

For one image:

```bash
docker buildx imagetools inspect docker.io/fgualdr/ngs-fastp:latest
```

You should see both `linux/amd64` and `linux/arm64`.

For all images:

```bash
for image in ngs-curl ngs-sra-tools ngs-fastqc ngs-fastp ngs-ncbi-datasets ngs-bowtie2-samtools ngs-featurecounts ngs-rseqc ngs-r-bioc ngs-multiqc ngs-deeptools ngs-chipseq-qc ngs-macs3 ngs-bedtools ngs-streme
do
  echo "===== ${image} ====="
  docker buildx imagetools inspect "docker.io/fgualdr/${image}:latest"
done
```

## Smoke tests

Normal student use should not specify a platform:

```bash
docker run --rm docker.io/fgualdr/ngs-fastp:latest fastp --version
```

During release validation, test both architectures explicitly:

```bash
docker run --rm --platform linux/amd64 docker.io/fgualdr/ngs-fastp:latest fastp --version
docker run --rm --platform linux/arm64 docker.io/fgualdr/ngs-fastp:latest fastp --version
```

Representative native-architecture checks:

```bash
docker run --rm docker.io/fgualdr/ngs-curl:latest curl --version
docker run --rm docker.io/fgualdr/ngs-sra-tools:latest fasterq-dump --version
docker run --rm docker.io/fgualdr/ngs-fastqc:latest fastqc --version
docker run --rm docker.io/fgualdr/ngs-fastp:latest fastp --version
docker run --rm docker.io/fgualdr/ngs-ncbi-datasets:latest datasets --version
docker run --rm docker.io/fgualdr/ngs-bowtie2-samtools:latest bowtie2 --version
docker run --rm docker.io/fgualdr/ngs-featurecounts:latest featureCounts -v
docker run --rm docker.io/fgualdr/ngs-rseqc:latest --version
docker run --rm docker.io/fgualdr/ngs-r-bioc:latest Rscript -e 'library(DESeq2); sessionInfo()'
docker run --rm docker.io/fgualdr/ngs-multiqc:latest multiqc --version
docker run --rm docker.io/fgualdr/ngs-deeptools:latest bamCoverage --version
docker run --rm docker.io/fgualdr/ngs-chipseq-qc:latest bash -c 'command -v run_spp.R; idr --version; samtools --version | head -n1'
docker run --rm docker.io/fgualdr/ngs-macs3:latest macs3 --version
docker run --rm docker.io/fgualdr/ngs-bedtools:latest bedtools --version
docker run --rm docker.io/fgualdr/ngs-streme:latest streme --version
```

`Dockerfile.rseqc` defines `infer_experiment.py` as its entrypoint, so `--version` is passed directly to that entrypoint.

## Runtime convention

All workshop commands mount the project root at `/work`:

```bash
docker run --rm   -v "$PWD:/work"   -w /work   docker.io/fgualdr/ngs-fastp:latest   bash scripts/day1/03_trim_fastq.sh
```

Do not add `--platform` to normal student commands after the image has been verified as multi-architecture.

## Important: ARM64 package availability

The Buildx command can target both architectures only if every package in that Dockerfile is available or buildable on both platforms.

If one architecture fails during Conda/Bioconda dependency resolution, do not treat that image as successfully converted to multiarch. Update the relevant pinned package version or recipe, rebuild, and smoke-test both architectures before using it in the workshop.

This is especially important for older Bioconda packages and the larger R/Bioconductor image.

## `images.lock.tsv`

The attached `images.lock.tsv` describes the previous AMD64-only release. Its current digests become stale after rebuilding `:latest`.

For a multiarch release there is a top-level image-index digest plus separate per-platform manifest digests. Regenerate the lock file if you want to return to digest-pinned student runtimes.

## Maintenance checklist

1. Build every custom image for `linux/amd64,linux/arm64`.
2. Confirm both platforms with `docker buildx imagetools inspect`.
3. Run the relevant version smoke test.
4. Test at least one mounted project command.
5. Test representative images on Apple Silicon macOS and Windows/WSL2.
6. Keep `--platform` out of student-facing `docker run` commands.
7. Regenerate `images.lock.tsv` if digest pinning is required for the release.
