#!/usr/bin/env bash
set -euo pipefail

cd /Users/ieo5244/Documents/NGS_Workshop
docker login
docker buildx use multiarch
docker buildx inspect --bootstrap

echo "===== Building docker.io/fgualdr/ngs-curl:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.curl \
  -t docker.io/fgualdr/ngs-curl:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-sra-tools:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.sra-tools \
  -t docker.io/fgualdr/ngs-sra-tools:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-fastqc:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.fastqc \
  -t docker.io/fgualdr/ngs-fastqc:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-fastp:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.fastp \
  -t docker.io/fgualdr/ngs-fastp:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-ncbi-datasets:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.ncbi-datasets \
  -t docker.io/fgualdr/ngs-ncbi-datasets:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-bowtie2-samtools:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.bowtie2-samtools \
  -t docker.io/fgualdr/ngs-bowtie2-samtools:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-featurecounts:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.featurecounts \
  -t docker.io/fgualdr/ngs-featurecounts:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-rseqc:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.rseqc \
  -t docker.io/fgualdr/ngs-rseqc:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-r-bioc:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.r-bioc \
  -t docker.io/fgualdr/ngs-r-bioc:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-multiqc:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.multiqc \
  -t docker.io/fgualdr/ngs-multiqc:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-deeptools:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.deeptools \
  -t docker.io/fgualdr/ngs-deeptools:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-chipseq-qc:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.chipseq-qc \
  -t docker.io/fgualdr/ngs-chipseq-qc:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-macs3:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.macs3 \
  -t docker.io/fgualdr/ngs-macs3:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-bedtools:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.bedtools \
  -t docker.io/fgualdr/ngs-bedtools:latest \
  --push \
  .

echo "===== Building docker.io/fgualdr/ngs-streme:latest ====="
docker buildx build \
  --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  --pull \
  -f Docker_files/Dockerfile.streme \
  -t docker.io/fgualdr/ngs-streme:latest \
  --push \
  .

echo "===== Inspecting manifests ====="
docker buildx imagetools inspect docker.io/fgualdr/ngs-curl:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-sra-tools:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-fastqc:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-fastp:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-ncbi-datasets:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-bowtie2-samtools:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-featurecounts:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-rseqc:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-r-bioc:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-multiqc:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-deeptools:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-chipseq-qc:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-macs3:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-bedtools:latest

docker buildx imagetools inspect docker.io/fgualdr/ngs-streme:latest
