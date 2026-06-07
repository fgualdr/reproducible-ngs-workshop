install.packages(c("BiocManager", "tidyverse", "data.table", "ggplot2", "ggrepel", "pheatmap"), repos = "https://cloud.r-project.org")
BiocManager::install(c(
  "DESeq2",
  "GenomicRanges",
  "IRanges",
  "rtracklayer",
  "Rsamtools",
  "GenomicFeatures"
), ask = FALSE, update = FALSE)

