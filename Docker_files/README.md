# NGS Workshop Docker images — no Micromamba

This release removes Micromamba from the workshop images. Simple compiled tools are built from upstream source or downloaded from upstream releases; Python tools are installed into isolated `venv`s; R/Bioconductor uses a Rocker R base; SRA Toolkit uses NCBI's official image.

## Important runtime rule

Removing Micromamba does **not** by itself solve bind-mount ownership. On Linux/WSL2, always run writable workshop containers with the host UID/GID:

```bash
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "$PWD:/work" \
  -w /work \
  IMAGE \
  COMMAND
```

This prevents both failure modes:

- a fixed non-root container user that cannot write to the student's project;
- root-created output files that the student cannot subsequently modify.

For example:

```bash
docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastp:latest \
  bash scripts/day1/03_trim_fastq.sh
```

## Images

| Dockerfile | Docker Hub tag |
|---|---|
| `Dockerfile.curl` | `fgualdr/ngs-curl:latest` |
| `Dockerfile.sra-tools` | `fgualdr/ngs-sra-tools:latest` |
| `Dockerfile.fastqc` | `fgualdr/ngs-fastqc:latest` |
| `Dockerfile.fastp` | `fgualdr/ngs-fastp:latest` |
| `Dockerfile.ncbi-datasets` | `fgualdr/ngs-ncbi-datasets:latest` |
| `Dockerfile.bowtie2-samtools` | `fgualdr/ngs-bowtie2-samtools:latest` |
| `Dockerfile.featurecounts` | `fgualdr/ngs-featurecounts:latest` |
| `Dockerfile.rseqc` | `fgualdr/ngs-rseqc:latest` |
| `Dockerfile.r-bioc` | `fgualdr/ngs-r-bioc:latest` |
| `Dockerfile.multiqc` | `fgualdr/ngs-multiqc:latest` |
| `Dockerfile.deeptools` | `fgualdr/ngs-deeptools:latest` |
| `Dockerfile.chipseq-qc` | `fgualdr/ngs-chipseq-qc:latest` |
| `Dockerfile.macs3` | `fgualdr/ngs-macs3:latest` |
| `Dockerfile.bedtools` | `fgualdr/ngs-bedtools:latest` |
| `Dockerfile.streme` | `fgualdr/ngs-streme:latest` |
| `Dockerfile.trimmomatic` | `fgualdr/ngs-trimmomatic:latest` |

## Buildx setup

From the repository root:

```bash
cd /Users/ieo5244/Documents/NGS_Workshop

docker login

docker buildx inspect multiarch >/dev/null 2>&1 || \
  docker buildx create --name multiarch --driver docker-container --use

docker buildx use multiarch
docker buildx inspect --bootstrap
```

The builder must list `linux/amd64` and `linux/arm64`.

## Rebuild and overwrite Docker Hub `latest`

Run:

```bash
chmod +x Docker_files/rebuild_multiarch.sh
Docker_files/rebuild_multiarch.sh
```

`--push` publishes a new multi-platform manifest under the existing `:latest` tag, replacing what Docker Hub resolves as `latest`. Existing immutable digests remain in registry history, but new pulls of `:latest` receive this release.

## Validate manifests

```bash
for image in \
  ngs-curl ngs-sra-tools ngs-fastqc ngs-fastp ngs-ncbi-datasets \
  ngs-bowtie2-samtools ngs-featurecounts ngs-rseqc ngs-r-bioc \
  ngs-multiqc ngs-deeptools ngs-chipseq-qc ngs-macs3 \
  ngs-bedtools ngs-streme ngs-trimmomatic
do
  echo "===== ${image} ====="
  docker buildx imagetools inspect "docker.io/fgualdr/${image}:latest"
done
```

Every image intended for the workshop should show both `linux/amd64` and `linux/arm64`.

## Smoke tests

```bash
docker run --rm docker.io/fgualdr/ngs-curl:latest curl --version
docker run --rm docker.io/fgualdr/ngs-sra-tools:latest fasterq-dump --version
docker run --rm docker.io/fgualdr/ngs-fastqc:latest fastqc --version
docker run --rm docker.io/fgualdr/ngs-fastp:latest fastp --version
docker run --rm docker.io/fgualdr/ngs-ncbi-datasets:latest datasets --version
docker run --rm docker.io/fgualdr/ngs-bowtie2-samtools:latest bowtie2 --version
docker run --rm docker.io/fgualdr/ngs-bowtie2-samtools:latest samtools --version | head -n1
docker run --rm docker.io/fgualdr/ngs-featurecounts:latest featureCounts -v
docker run --rm docker.io/fgualdr/ngs-rseqc:latest infer_experiment.py --version
docker run --rm docker.io/fgualdr/ngs-r-bioc:latest Rscript -e 'library(DESeq2); sessionInfo()'
docker run --rm docker.io/fgualdr/ngs-multiqc:latest multiqc --version
docker run --rm docker.io/fgualdr/ngs-deeptools:latest bamCoverage --version
docker run --rm docker.io/fgualdr/ngs-chipseq-qc:latest bash -c 'command -v run_spp.R; idr --version; samtools --version | head -n1'
docker run --rm docker.io/fgualdr/ngs-macs3:latest macs3 --version
docker run --rm docker.io/fgualdr/ngs-bedtools:latest bedtools --version
docker run --rm docker.io/fgualdr/ngs-streme:latest streme --version
docker run --rm docker.io/fgualdr/ngs-trimmomatic:latest trimmomatic -version
```

## Mandatory mounted-write test

Do not validate only that a container can read a bind mount. Test writing using the same runtime identity students will use:

```bash
mkdir -p test_mount

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-curl:latest \
  bash -c 'printf "container write OK\\n" > test_mount/docker_write_test.txt'

cat test_mount/docker_write_test.txt
ls -ln test_mount/docker_write_test.txt
rm -rf test_mount
```

On Linux/WSL2 the numeric owner should match `id -u` and `id -g`.

## Notes

### NCBI Datasets

The Dockerfile downloads the architecture-specific official NCBI v2 CLI binary at build time. This deliberately follows the current v2 CLI rather than pinning the old Conda `16.22.1` package. If exact CLI-version pinning is required, freeze the resulting image by digest after validation.

### SRA Toolkit

The image is based on NCBI's official `ncbi/sra-tools:3.4.1` image. Keep `HOME=/tmp` (or another writable directory) when running it under an arbitrary UID. For large `fasterq-dump` jobs, explicitly direct temporary files to a writable mounted path with `-t`.

### R/Bioconductor

The image uses R 4.3.3 and Bioconductor 3.18. Package installation is performed from the canonical CRAN/Bioconductor repositories rather than Conda/Bioconda.

### Multi-architecture warning

Do not assume a successful `amd64` build implies `arm64` works. The release script builds both platforms and fails immediately if either architecture fails. Smoke-test representative commands on Apple Silicon and WSL2 before class.
