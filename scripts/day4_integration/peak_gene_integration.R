#!/usr/bin/env Rscript

required <- c("GenomicRanges", "rtracklayer", "ggplot2")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Missing R packages: ", paste(missing, collapse = ", "))

peak_file <- "results/day3_chipseq/peaks/consensus/day4_consensus_peaks.bed"
annotation_file <- "reference_genome/annotation.gff3"
rna_file <- "results/day2_rnaseq/deseq2/deseq2_results.tsv"
chip_file <- "results/day3_chipseq/differential_peaks/differential_peak_results.tsv"
table_dir <- "results/day4_integration/tables"
plot_dir <- "results/day4_integration/plots"

for (input_file in c(peak_file, annotation_file, rna_file)) {
  if (!file.exists(input_file)) stop("Required input not found: ", input_file)
}
dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(plot_dir, recursive = TRUE, showWarnings = FALSE)

peaks <- rtracklayer::import(peak_file, format = "BED")
annotation <- rtracklayer::import(annotation_file)
rna <- read.delim(rna_file, check.names = FALSE)
if (!length(peaks)) stop("No peaks were imported")

genes <- annotation[annotation$type == "gene"]
if (!length(genes)) genes <- annotation[annotation$type == "CDS"]
if (!length(genes)) stop("No gene or CDS features were imported")
if (!length(intersect(as.character(GenomicRanges::seqnames(peaks)),
                      as.character(GenomicRanges::seqnames(genes))))) {
  stop("Peak and annotation sequence names do not overlap")
}

gene_id <- S4Vectors::mcols(genes)$gene_id
if (is.null(gene_id)) gene_id <- S4Vectors::mcols(genes)$ID
if (is.null(gene_id)) gene_id <- S4Vectors::mcols(genes)$locus_tag
if (is.null(gene_id) || anyNA(gene_id)) stop("Annotation lacks a complete gene identifier column")

peak_id <- S4Vectors::mcols(peaks)$name
if (is.null(peak_id) || anyNA(peak_id) || any(peak_id == "")) {
  peak_id <- sprintf("peak_%04d", seq_along(peaks))
}

nearest <- GenomicRanges::nearest(peaks, genes, ignore.strand = TRUE)
if (anyNA(nearest)) stop("At least one peak has no gene on the same sequence")
distance_to_gene <- GenomicRanges::distance(peaks, genes[nearest], ignore.strand = TRUE)

promoters <- GenomicRanges::promoters(genes, upstream = 500, downstream = 100)
GenomicRanges::start(promoters) <- pmax(1L, GenomicRanges::start(promoters))
nearest_promoter <- promoters[nearest]
promoter_overlap <-
  as.character(GenomicRanges::seqnames(peaks)) == as.character(GenomicRanges::seqnames(nearest_promoter)) &
  GenomicRanges::start(peaks) <= GenomicRanges::end(nearest_promoter) &
  GenomicRanges::end(peaks) >= GenomicRanges::start(nearest_promoter)

links <- data.frame(
  peak_id = as.character(peak_id),
  peak_chr = as.character(GenomicRanges::seqnames(peaks)),
  peak_start = GenomicRanges::start(peaks),
  peak_end = GenomicRanges::end(peaks),
  gene_id = as.character(gene_id[nearest]),
  distance_to_gene = distance_to_gene,
  promoter_overlap = promoter_overlap,
  stringsAsFactors = FALSE
)
write.table(links, file.path(table_dir, "peak_nearest_gene.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)

if (!"gene_id" %in% names(rna)) names(rna)[1] <- "gene_id"
rna$gene_id <- as.character(rna$gene_id)
combined <- merge(links, rna, by = "gene_id", all.x = TRUE, sort = FALSE)

if (file.exists(chip_file)) {
  chip <- read.delim(chip_file, check.names = FALSE)
  chip <- chip[, c("peak_id", "log2FoldChange", "padj")]
  names(chip) <- c("peak_id", "chip_log2FoldChange", "chip_padj")
  combined <- merge(combined, chip, by = "peak_id", all.x = TRUE, sort = FALSE)
} else {
  combined$chip_log2FoldChange <- NA_real_
  combined$chip_padj <- NA_real_
  warning("Differential peak table not found; ChIP-change columns will be NA")
}

combined$is_de <- !is.na(combined$padj) & combined$padj < 0.05 & abs(combined$log2FoldChange) >= 1
combined$is_nearby <- combined$promoter_overlap | combined$distance_to_gene <= 500
combined$candidate_class <- ifelse(
  combined$is_de & combined$is_nearby,
  "DE gene with promoter-proximal peak",
  "Insufficient combined evidence"
)

write.table(combined, file.path(table_dir, "peak_gene_deseq2_join.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
candidates <- combined[combined$is_de & combined$is_nearby, , drop = FALSE]
candidates <- candidates[order(candidates$padj, candidates$distance_to_gene), , drop = FALSE]
write.table(candidates, file.path(table_dir, "candidate_direct_targets.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)

distance_plot <- ggplot2::ggplot(links, ggplot2::aes(distance_to_gene)) +
  ggplot2::geom_histogram(bins = 40) +
  ggplot2::theme_bw() +
  ggplot2::labs(x = "Distance from peak to nearest gene (bp)", y = "Number of peaks")
ggplot2::ggsave(file.path(plot_dir, "peak_gene_distance_histogram.pdf"),
                distance_plot, width = 7, height = 5)

if (any(!is.na(combined$chip_log2FoldChange) & !is.na(combined$log2FoldChange))) {
  quadrant_plot <- ggplot2::ggplot(
    combined,
    ggplot2::aes(chip_log2FoldChange, log2FoldChange, colour = is_de & is_nearby)
  ) +
    ggplot2::geom_hline(yintercept = 0, colour = "grey70") +
    ggplot2::geom_vline(xintercept = 0, colour = "grey70") +
    ggplot2::geom_point(alpha = 0.7, na.rm = TRUE) +
    ggplot2::scale_colour_manual(values = c("grey60", "#B2182B"), guide = "none") +
    ggplot2::theme_bw() +
    ggplot2::labs(x = "ChIP-seq log2 fold change", y = "RNA-seq log2 fold change")
  ggplot2::ggsave(file.path(plot_dir, "rna_chip_change_quadrant.pdf"),
                  quadrant_plot, width = 6, height = 5)
}
