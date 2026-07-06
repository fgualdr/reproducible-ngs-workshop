# Task-specific Dockerfiles

These Dockerfiles are intentionally small teaching examples. Each file builds one
image for one tool or one narrow workflow step.

Students should normally use the Docker Hub images listed in the lesson run commands.
Build these images only when needed, because package downloads can be slow on
workshop Wi-Fi.

## Runtime pattern

All images use the same working-directory convention. Run one temporary
container and execute the script inside `/work`:

```bash
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastqc:latest \
  bash scripts/day1/01_fastqc_raw.sh
```

Use two threads unless the course instructions say otherwise:

```bash
THREADS=2
```

## Dockerfiles

| File | Main purpose |
|---|---|
| `Dockerfile.curl` | direct ENA FASTQ download with curl |
| `Dockerfile.fastqc` | FASTQ quality control with FastQC |
| `Dockerfile.fastp` | FASTQ trimming and filtering with fastp |
| `Dockerfile.sra-tools` | `prefetch` and `fasterq-dump` for SRA accessions |
| `Dockerfile.ncbi-datasets` | reference genome and annotation download from NCBI |
| `Dockerfile.bowtie2-samtools` | Bowtie2 mapping plus BAM sorting/indexing |
| `Dockerfile.featurecounts` | gene or interval counting with featureCounts |
| `Dockerfile.deeptools` | bigWig generation from BAM files |
| `Dockerfile.macs3` | ChIP-seq peak calling with MACS3 |
| `Dockerfile.bedtools` | BED/FASTA interval operations |
| `Dockerfile.streme` | motif discovery with STREME from MEME Suite |
| `Dockerfile.r-bioc` | R/Bioconductor analysis for DESeq2 and intervals |

## Build commands

Run these commands from the repository root.

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.curl -t fgualdr/ngs-curl:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.fastqc -t fgualdr/ngs-fastqc:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.fastp -t fgualdr/ngs-fastp:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.sra-tools -t fgualdr/ngs-sra-tools:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.ncbi-datasets -t fgualdr/ngs-ncbi-datasets:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.bowtie2-samtools -t fgualdr/ngs-bowtie2-samtools:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.featurecounts -t fgualdr/ngs-featurecounts:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.deeptools -t fgualdr/ngs-deeptools:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.macs3 -t fgualdr/ngs-macs3:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.bedtools -t fgualdr/ngs-bedtools:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.streme -t fgualdr/ngs-streme:latest .
```

```bash
# docker build --platform linux/amd64 -f Docker_files/Dockerfile.r-bioc -t fgualdr/ngs-r-bioc:latest .
```

## Push commands

After building, push the images to Docker Hub:

```bash
# docker push fgualdr/ngs-curl:latest
```

```bash
# docker push fgualdr/ngs-fastqc:latest
```

```bash
# docker push fgualdr/ngs-fastp:latest
```

```bash
# docker push fgualdr/ngs-sra-tools:latest
```

```bash
# docker push fgualdr/ngs-ncbi-datasets:latest
```

```bash
# docker push fgualdr/ngs-bowtie2-samtools:latest
```

```bash
# docker push fgualdr/ngs-featurecounts:latest
```

```bash
# docker push fgualdr/ngs-deeptools:latest
```

```bash
docker push fgualdr/ngs-macs3:latest
```

```bash
docker push fgualdr/ngs-bedtools:latest
```

```bash
docker push fgualdr/ngs-streme:latest
```

```bash
docker push fgualdr/ngs-r-bioc:latest
```

## Example command

```bash
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD:/work" \
  -w /work \
  docker.io/fgualdr/ngs-fastqc:latest \
  fastqc --version
```
