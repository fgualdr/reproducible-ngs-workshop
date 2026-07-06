#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(GenomicRanges)
  library(rtracklayer)
  library(tidyverse)
})

# Inputs
peak_file <- "results/day3_chipseq/peaks/no_input/WT_1_peaks.narrowPeak"
annotation_file <- "reference_genome/annotation.gff3"
deseq_file <- "results/day2_rnaseq/deseq2/deseq2_results.tsv"

# Import data
peaks <- import(peak_file, format = "BED")
annotation <- import(annotation_file)
de <- read_tsv(deseq_file, show_col_types = FALSE)

# Keep gene-like features. Adapt this line to the organism annotation.
genes <- annotation[annotation$type %in% c("gene", "CDS")]

# Create stable gene identifiers from available metadata.
gene_id <- mcols(genes)$gene_id
if (is.null(gene_id)) gene_id <- mcols(genes)$ID
if (is.null(gene_id)) gene_id <- mcols(genes)$locus_tag
if (is.null(gene_id)) gene_id <- paste0("gene_", seq_along(genes))
mcols(genes)$gene_id <- as.character(gene_id)

# Nearest gene per peak. Peak intervals are unstranded, so ignore strand here.
nearest_hits <- distanceToNearest(peaks, genes, ignore.strand = TRUE)
peak_gene <- tibble(
  peak_index = queryHits(nearest_hits),
  gene_index = subjectHits(nearest_hits),
  distance_to_gene = mcols(nearest_hits)$distance,
  gene_id = mcols(genes)$gene_id[subjectHits(nearest_hits)],
  peak_chr = as.character(seqnames(peaks))[queryHits(nearest_hits)],
  peak_start = start(peaks)[queryHits(nearest_hits)],
  peak_end = end(peaks)[queryHits(nearest_hits)]
)

write_tsv(peak_gene, "results/day4_integration/tables/peak_nearest_gene.tsv")

# Join with DESeq2 results. Adapt the gene ID column if needed.
if (!"gene_id" %in% names(de)) {
  first_col <- names(de)[1]
  de <- de %>% rename(gene_id = all_of(first_col))
}
de <- de %>% mutate(gene_id = as.character(gene_id))
combined <- peak_gene %>%
  left_join(de, by = "gene_id") %>%
  mutate(
    is_de = !is.na(padj) & padj < 0.05 & abs(log2FoldChange) >= 1,
    candidate_class = case_when(
      is_de ~ "DE gene with nearby peak",
      TRUE ~ "Nearby peak without DE evidence"
    )
  )

write_tsv(combined, "results/day4_integration/tables/peak_gene_deseq2_join.tsv")
