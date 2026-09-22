#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(pwd)}"
DOCKER_DIR="${ROOT}/Docker_files"
BUILDER="${BUILDER:-multiarch}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
NAMESPACE="${NAMESPACE:-docker.io/fgualdr}"

cd "${ROOT}"

docker buildx inspect "${BUILDER}" >/dev/null 2>&1 || \
  docker buildx create --name "${BUILDER}" --driver docker-container --use

docker buildx use "${BUILDER}"
docker buildx inspect --bootstrap

images=(
  # "curl:Dockerfile.curl"
  # "sra-tools:Dockerfile.sra-tools"
  # "fastqc:Dockerfile.fastqc"
  # "fastp:Dockerfile.fastp"
  # "ncbi-datasets:Dockerfile.ncbi-datasets"
  # "bowtie2-samtools:Dockerfile.bowtie2-samtools"
  # "featurecounts:Dockerfile.featurecounts"
  # "rseqc:Dockerfile.rseqc"
  "r-bioc:Dockerfile.r-bioc"
  "multiqc:Dockerfile.multiqc"
  "deeptools:Dockerfile.deeptools"
  "chipseq-qc:Dockerfile.chipseq-qc"
  "macs3:Dockerfile.macs3"
  "bedtools:Dockerfile.bedtools"
  "streme:Dockerfile.streme"
  "trimmomatic:Dockerfile.trimmomatic"
)

for spec in "${images[@]}"; do
  name="${spec%%:*}"
  dockerfile="${spec#*:}"
  tag="${NAMESPACE}/ngs-${name}:latest"

  echo "===== Building ${tag} ====="
  docker buildx build \
    --builder "${BUILDER}" \
    --platform "${PLATFORMS}" \
    --pull \
    -f "${DOCKER_DIR}/${dockerfile}" \
    -t "${tag}" \
    --push \
    .
done

echo "===== Published manifests ====="
for spec in "${images[@]}"; do
  name="${spec%%:*}"
  tag="${NAMESPACE}/ngs-${name}:latest"
  echo "===== ${tag} ====="
  docker buildx imagetools inspect "${tag}"
done
