#!/usr/bin/env Rscript

library(GenomicRanges)
library(rtracklayer)
library(Rsamtools)
library(Biostrings)
library(ggplot2)

rna_file <- "results/day2_rnaseq/deseq2/deseq2_results.tsv"
peak_file <- "results/day3_chipseq/peaks/consensus/consensus_peaks.bed"
peak_de_file <- "results/day3_chipseq/differential_peaks/differential_peak_results.tsv"
annotation_file <- "reference_genome/annotation.gff3"
genome_file <- "reference_genome/genome.fa"

table_dir <- "results/day4_optional/tables"
plot_dir <- "results/day4_optional/plots"

dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)
rna <- read.delim(rna_file, check.names = FALSE)
peaks <- import(peak_file, format = "BED")
annotation <- import(annotation_file, format = "GFF3")
genes <- annotation[annotation$type == "gene"]
genome <- FaFile(genome_file)
genome_index <- scanFaIndex(genome)
class(rna)
class(peaks)
class(genes)
class(genome)
class(genome_index)

rna[1:3, ]
peaks[1:3]
genes[1:3]
genome_index
if (!"name" %in% names(mcols(peaks))) {
  stop("Consensus BED must contain peak IDs in column 4")
}
peaks$peak_id <- as.character(peaks$name)
names(peaks) <- peaks$peak_id
candidate_id_columns <- c("ID", "gene_id", "locus_tag", "Name")
gene_id_column <- intersect(candidate_id_columns, names(mcols(genes)))[1]

if (is.na(gene_id_column)) {
  stop("No suitable gene identifier found in the GFF3 gene features")
}

genes$gene_id <- as.character(mcols(genes)[[gene_id_column]])
names(genes) <- genes$gene_id
genome_lengths <- setNames(width(genome_index), as.character(seqnames(genome_index)))
common_seqlevels <- intersect(names(genome_lengths), union(seqlevels(peaks), seqlevels(genes)))

seqlengths(peaks)[common_seqlevels] <- genome_lengths[common_seqlevels]
seqlengths(genes)[common_seqlevels] <- genome_lengths[common_seqlevels]
shared_sequences <- intersect(seqlevelsInUse(peaks), seqlevelsInUse(genes))
if (length(shared_sequences) == 0) {
  stop("Peaks and genes do not share chromosome names")
}
shared_sequences
nearest_hits <- distanceToNearest(peaks, genes, ignore.strand = TRUE)
class(nearest_hits)
nearest_hits
nearest_table <- data.frame(
  peak_id = peaks$peak_id[queryHits(nearest_hits)],
  peak_chrom = as.character(seqnames(peaks))[queryHits(nearest_hits)],
  peak_start = start(peaks)[queryHits(nearest_hits)],
  peak_end = end(peaks)[queryHits(nearest_hits)],
  gene_id = genes$gene_id[subjectHits(nearest_hits)],
  gene_strand = as.character(strand(genes))[subjectHits(nearest_hits)],
  distance_to_gene = mcols(nearest_hits)$distance
)

write.table(
  nearest_table,
  file.path(table_dir, "peak_nearest_gene.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)
distance_plot <- ggplot(nearest_table, aes(distance_to_gene)) +
  geom_histogram(bins = 40) +
  theme_bw() +
  labs(
    x = "Distance from peak to nearest annotated gene (bp)",
    y = "Number of peaks"
  )

ggsave(
  file.path(plot_dir, "peak_to_nearest_gene_distance.pdf"),
  distance_plot,
  width = 7, height = 5
)
promoter_ranges <- promoters(genes, upstream = 500, downstream = 101)
promoter_ranges <- trim(promoter_ranges)
promoter_ranges$gene_id <- genes$gene_id
promoter_hits <- findOverlaps(peaks, promoter_ranges, ignore.strand = TRUE)
class(promoter_hits)
promoter_table <- data.frame(
  peak_id = peaks$peak_id[queryHits(promoter_hits)],
  peak_chrom = as.character(seqnames(peaks))[queryHits(promoter_hits)],
  peak_start = start(peaks)[queryHits(promoter_hits)],
  peak_end = end(peaks)[queryHits(promoter_hits)],
  gene_id = promoter_ranges$gene_id[subjectHits(promoter_hits)],
  promoter_start = start(promoter_ranges)[subjectHits(promoter_hits)],
  promoter_end = end(promoter_ranges)[subjectHits(promoter_hits)],
  gene_strand = as.character(strand(promoter_ranges))[subjectHits(promoter_hits)]
)

write.table(
  promoter_table,
  file.path(table_dir, "peak_promoter_overlaps.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)
if (!"gene_id" %in% names(rna)) {
  names(rna)[1] <- "gene_id"
}
rna$gene_id <- as.character(rna$gene_id)
integrated <- merge(promoter_table, rna, by = "gene_id", all.x = TRUE)

integrated$is_de <- !is.na(integrated$padj) &
  integrated$padj < 0.05 &
  abs(integrated$log2FoldChange) >= 1

integrated$candidate_class <- ifelse(
  integrated$is_de,
  "DE gene with promoter-overlapping peak",
  "promoter-overlapping peak without DE evidence"
)

write.table(
  integrated,
  file.path(table_dir, "promoter_peak_rnaseq_integration.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

candidate_targets <- integrated[integrated$is_de, , drop = FALSE]
candidate_targets <- candidate_targets[order(candidate_targets$padj), , drop = FALSE]

write.table(
  candidate_targets,
  file.path(table_dir, "candidate_regulatory_relationships.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)
if (file.exists(peak_de_file)) {
  peak_de <- read.delim(peak_de_file, check.names = FALSE)

  peak_de_small <- peak_de[, c(
    "peak_id", "log2FoldChange", "padj", "significant"
  )]

  names(peak_de_small)[names(peak_de_small) == "log2FoldChange"] <- "chip_log2FoldChange"
  names(peak_de_small)[names(peak_de_small) == "padj"] <- "chip_padj"
  names(peak_de_small)[names(peak_de_small) == "significant"] <- "chip_significant"

  rna_chip <- merge(integrated, peak_de_small, by = "peak_id", all.x = TRUE)
  names(rna_chip)[names(rna_chip) == "log2FoldChange"] <- "rna_log2FoldChange"
  names(rna_chip)[names(rna_chip) == "padj"] <- "rna_padj"

  write.table(
    rna_chip,
    file.path(table_dir, "rna_chip_peak_integration.tsv"),
    sep = "\t", quote = FALSE, row.names = FALSE
  )

  plot_dt <- rna_chip[
    is.finite(rna_chip$rna_log2FoldChange) &
      is.finite(rna_chip$chip_log2FoldChange),
    , drop = FALSE
  ]

  if (nrow(plot_dt) > 0) {
    effect_plot <- ggplot(plot_dt, aes(chip_log2FoldChange, rna_log2FoldChange)) +
      geom_hline(yintercept = 0, linetype = 2) +
      geom_vline(xintercept = 0, linetype = 2) +
      geom_point(alpha = 0.7) +
      theme_bw() +
      labs(
        x = "ChIP-seq peak log2 fold change",
        y = "RNA-seq gene log2 fold change"
      )

    ggsave(
      file.path(plot_dir, "rna_vs_chip_log2foldchange.pdf"),
      effect_plot,
      width = 6, height = 5
    )
  }
}
open(genome)
peak_sequences <- scanFa(genome, param = peaks)
close(genome)

names(peak_sequences) <- peaks$peak_id
class(peak_sequences)
peak_sequences[1:3]
base_counts <- letterFrequency(
  peak_sequences,
  letters = c("A", "C", "G", "T"),
  as.prob = FALSE
)

sequence_width <- width(peak_sequences)
gc_fraction <- (base_counts[, "G"] + base_counts[, "C"]) / sequence_width
cpg_count <- vcountPattern("CG", peak_sequences, fixed = TRUE)

sequence_table <- data.frame(
  peak_id = names(peak_sequences),
  width = sequence_width,
  A = base_counts[, "A"],
  C = base_counts[, "C"],
  G = base_counts[, "G"],
  T = base_counts[, "T"],
  GC_fraction = gc_fraction,
  CpG_count = cpg_count,
  CpG_per_100bp = 100 * cpg_count / sequence_width
)

write.table(
  sequence_table,
  file.path(table_dir, "peak_sequence_composition.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)
gc_plot <- ggplot(sequence_table, aes(GC_fraction)) +
  geom_histogram(bins = 30) +
  theme_bw() +
  labs(x = "GC fraction", y = "Number of peaks")

ggsave(
  file.path(plot_dir, "peak_GC_fraction.pdf"),
  gc_plot,
  width = 6, height = 4
)

cpg_plot <- ggplot(sequence_table, aes(CpG_per_100bp)) +
  geom_histogram(bins = 30) +
  theme_bw() +
  labs(x = "CpG dinucleotides per 100 bp", y = "Number of peaks")

ggsave(
  file.path(plot_dir, "peak_CpG_density.pdf"),
  cpg_plot,
  width = 6, height = 4
)
writeLines(
  capture.output(sessionInfo()),
  file.path(table_dir, "sessionInfo.txt")
)
