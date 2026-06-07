#!/usr/bin/env bash
set -euo pipefail

cat > .gitignore <<'EOF'
# Large local analysis data
data/raw_fastq/*
data/trimmed_fastq/*
data/genome/*
data/bam/*
data/raw_counts/*
data/macs_peaks/*

# Keep empty directory placeholders
!data/**/.gitkeep

# Large/generated file types
*.fastq
*.fastq.gz
*.fq.gz
*.sra
*.bam
*.bai
*.bw
*.bigWig
*.zip
*.tar
*.tar.gz

# Temporary and interactive files
*.tmp
*.log.tmp
__pycache__/
.Rhistory
.RData
.Rproj.user/
.DS_Store
EOF

printf 'Wrote .gitignore for NGS project\n'
