#!/usr/bin/env bash
set -euo pipefail

out_dir="reference_genome"
base_url="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/025/998/455/GCF_025998455.1_ASM2599845v1"
genome_file="GCF_025998455.1_ASM2599845v1_genomic.fna.gz"
gff_file="GCF_025998455.1_ASM2599845v1_genomic.gff.gz"
gtf_file="GCF_025998455.1_ASM2599845v1_genomic.gtf.gz"

mkdir -p "${out_dir}"

curl -L "${base_url}/${genome_file}" -o "${out_dir}/genome.fa.gz"

curl -L "${base_url}/${gff_file}" -o "${out_dir}/annotation.gff3.gz"

curl -L "${base_url}/${gtf_file}" -o "${out_dir}/annotation.gtf.gz"

gzip -dc "${out_dir}/genome.fa.gz" > "${out_dir}/genome.fa"
gzip -dc "${out_dir}/annotation.gff3.gz" > "${out_dir}/annotation.gff3"
gzip -dc "${out_dir}/annotation.gtf.gz" > "${out_dir}/annotation.gtf"

cat > "${out_dir}/REFERENCE.md" <<EOF
# Reference genome and annotation

- Organism: Helicobacter pylori
- Assembly accession: GCF_025998455.1
- Assembly name: ASM2599845v1
- Source: NCBI FTP
- FTP directory: ${base_url}/
- Genome FASTA: reference_genome/genome.fa
- Annotation GFF3: reference_genome/annotation.gff3
- Annotation GTF: reference_genome/annotation.gtf
- Download script: scripts/day1/03_reference_genome_annotation.sh
EOF
