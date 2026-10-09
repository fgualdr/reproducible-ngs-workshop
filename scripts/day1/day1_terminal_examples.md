# Day 1 — terminal commands and examples

Extracted verbatim as reference; some are interactive, illustrative, platform-specific or alternatives. Do not execute indiscriminately.

```bash
# Quarto line 17
cd ~/workshop_ngs
pwd
```

```bash
# Quarto line 133
cd ~/workshop_ngs
pwd
```

```bash
# Quarto line 140
git init
git status
```

```bash
# Quarto line 147
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
```

```bash
# Quarto line 184
git remote add origin https://github.com/YOUR_USERNAME/workshop_ngs.git
git remote -v
```

```bash
# Quarto line 199
nano .gitignore
```

```bash
# Quarto line 245
nano README.md
```

```bash
# Quarto line 257
git status
git add .gitignore README.md
git commit -m "Initialize workshop repository"
git branch -M main
git push -u origin main
```

```bash
# Quarto line 477
mkdir -p reference_genome
mkdir -p scripts/day1
```

```bash
# Quarto line 484
nano scripts/day1/01_reference_genome_annotation.sh
```

```bash
# Quarto line 587
curl --help
```

```bash
# Quarto line 591
gzip --help
```

```bash
# Quarto line 606
curl -I https://ftp.ncbi.nlm.nih.gov
```

```bash
# Quarto line 661
grep '^>' reference_genome/genome.fa | head
grep -v '^#' reference_genome/annotation.gff3 | head
grep -v '^#' reference_genome/annotation.gtf | head
head reference_genome/genes.bed
cat reference_genome/reference_files.sha256
awk -F '\t' '{print NF; exit}' reference_genome/genes.bed
grep -v '^#' reference_genome/annotation.gff3 | wc -l
```

```bash
# Quarto line 795
nano scripts/day1/02_download_ena_fastq.sh
```

```bash
# Quarto line 1024
tail -n +2 raw_data/metadata/Chipseq_metadata.tmp |
while IFS= read -r line; do

  sample=$(printf '%s\n' "${line}" | cut -d $'\t' -f1)
  url=$(printf '%s\n' "${line}" | cut -d $'\t' -f31 | tr -d '\r')

  url="https://${url#ftp://}"

  filename="${url##*/}"
  mate="${filename%.fastq.gz}"
  mate="${mate##*_}"

  fastq_name="${sample}_R${mate}.fastq.gz"

  printf '%s\t%s\t%s\n' \
    "${line}" \
    "${url}" \
    "${fastq_name}" \
    >> raw_data/metadata/Chipseq_metadata.txt

done
```

```bash
# Quarto line 1126
rev raw_data/metadata/RNAseq_metadata.txt | cut -d $'\t' -f1,2 | rev | head
rev raw_data/metadata/Chipseq_metadata.txt | cut -d $'\t' -f1,2 | rev | head
ls -lh raw_data/metadata/RNAseq_metadata.txt
ls -lh raw_data/metadata/Chipseq_metadata.txt
ls -lh raw_data/metadata/METADATA.md
ls -lh raw_data/fastq/rnaseq/*.fastq.gz
ls -lh raw_data/fastq/chipseq/*.fastq.gz
cat results/logs/day1/metadata_fastq_download.log
```

```bash
# Quarto line 1143
zcat raw_data/fastq/rnaseq/WT_1_R1.fastq.gz | head
```

```bash
# Quarto line 1148
gzcat raw_data/fastq/rnaseq/WT_1_R1.fastq.gz | head
```

```bash
# Quarto line 1159
zcat raw_data/fastq/rnaseq/WT_1_R2.fastq.gz | grep 'PASTE_READ_ID_HERE'
```

```bash
# Quarto line 1163
gzcat raw_data/fastq/rnaseq/WT_1_R2.fastq.gz | grep 'PASTE_READ_ID_HERE'
```

```bash
# Quarto line 1237
nano scripts/day1/04_download_sra_fastq.sh
```

```bash
# Quarto line 1526
head raw_data_sra/metadata/RNAseq_metadata_all.tsv
cat raw_data_sra/metadata/RNAseq_metadata.txt

head raw_data_sra/metadata/Chipseq_metadata_all.tsv
cat raw_data_sra/metadata/Chipseq_metadata.txt
```

```bash
# Quarto line 1536
ls -lh raw_data_sra/fastq/rnaseq/
ls -lh raw_data_sra/fastq/chipseq/
```

```bash
# Quarto line 1593
nano scripts/day1/03_trim_fastq.sh
```

```bash
# Quarto line 1718
nano README.md
```

```bash
# Quarto line 1734
nano workflow_execution.md
```

```bash
# Quarto line 1757
git status
```

```bash
# Quarto line 1763
git add README.md .gitignore workflow_execution.md
git add raw_data/metadata/*.csv raw_data/metadata/*.txt raw_data/metadata/*.tsv
git add raw_data/metadata/METADATA.md
git add reference_genome/REFERENCE.md reference_genome/reference_files.sha256
git add scripts/day1/*.sh
git add results/logs/day1/reference_download.log
git add results/logs/day1/metadata_fastq_download.log
git add results/logs/day1/fastp
```

```bash
# Quarto line 1776
git status
```

```bash
# Quarto line 1784
git commit -m "Complete Day 1 FASTQ retrieval and fastp QC"
git push
```

```bash
# Quarto line 1791
git status
```

```bash
# Quarto line 1853
docker ps
```

```bash
# Quarto line 1859
docker stop CONTAINER_ID
```

```bash
# Quarto line 1882
apptainer exec \
  --bind "$PWD:/work" \
  --pwd /work \
  docker://fgualdr/ngs-fastp \
  bash scripts/day1/03_trim_fastq.sh
```

```bash
# Quarto line 1892
singularity exec \
  --bind "$PWD:/work" \
  --pwd /work \
  docker://fgualdr/ngs-fastp \
  bash scripts/day1/03_trim_fastq.sh
```

```bash
# Quarto line 1913
apptainer shell \
  --bind "$PWD:/work" \
  --pwd /work \
  docker://fgualdr/ngs-fastp
```

```bash
# Quarto line 1967
bash -n scripts/day1/03_trim_fastq.sh
```

