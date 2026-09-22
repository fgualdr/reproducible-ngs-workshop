#!/usr/bin/env bash
set -euo pipefail

run() { echo "> $*"; "$@"; }

run docker run --rm docker.io/fgualdr/ngs-curl:latest curl --version
run docker run --rm docker.io/fgualdr/ngs-sra-tools:latest fasterq-dump --version
run docker run --rm docker.io/fgualdr/ngs-fastqc:latest fastqc --version
run docker run --rm docker.io/fgualdr/ngs-fastp:latest fastp --version
run docker run --rm docker.io/fgualdr/ngs-ncbi-datasets:latest datasets --version
run docker run --rm docker.io/fgualdr/ngs-bowtie2-samtools:latest bowtie2 --version
run docker run --rm docker.io/fgualdr/ngs-bowtie2-samtools:latest samtools --version
run docker run --rm docker.io/fgualdr/ngs-featurecounts:latest featureCounts -v
run docker run --rm docker.io/fgualdr/ngs-rseqc:latest infer_experiment.py --version
run docker run --rm docker.io/fgualdr/ngs-r-bioc:latest Rscript -e 'library(DESeq2); sessionInfo()'
run docker run --rm docker.io/fgualdr/ngs-multiqc:latest multiqc --version
run docker run --rm docker.io/fgualdr/ngs-deeptools:latest bamCoverage --version
run docker run --rm docker.io/fgualdr/ngs-chipseq-qc:latest bash -c 'command -v run_spp.R; idr --version; samtools --version | head -n1'
run docker run --rm docker.io/fgualdr/ngs-macs3:latest macs3 --version
run docker run --rm docker.io/fgualdr/ngs-bedtools:latest bedtools --version
run docker run --rm docker.io/fgualdr/ngs-streme:latest streme --version
run docker run --rm docker.io/fgualdr/ngs-trimmomatic:latest trimmomatic -version
