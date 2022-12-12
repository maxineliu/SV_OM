# Intersection of bayescan, pcadapt, vcftools and VennDiagram

library(ggVennDiagram) # Tutorial: https://swcyo.rbind.io/course/veen-upset/
library(ggplot2)library(dplyr) # Tutorial: https://blog.51cto.com/yijiaobani/5330522

# Data input
outlier_INS_bayes <- read.table("/Users/maxineliu/work/bufo/outlier_methods/Sniffles/bayescan.dir/results_plots/12bufo.DUP.filtered_pr10_outlier_fst.txt", header = T, col.names = c("ID", "bayes_prob", "bayes_log10.PO.", "bayes_q", "bayes_alpha", "bayes_fst"))
outlier_INS_pca <- read.table("/Users/maxineliu/work/bufo/outlier_methods/Sniffles/pcadapt/results_plots/12bufo.DUP.filtered.outlier.qval.txt", header = T, col.names = c("ID", "Chr", "Pos", "pca_q")) 
outlier_INS_weir <- read.table("/Users/maxineliu/work/bufo/outlier_methods/Sniffles/VCFtools/results_plots/12bufo.DUP.filtered.outlier.weir.fst", header = T, col.names = c("ID", "Chr", "Pos", "vcft_fst"))
gp1_frq <- read.table("/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.gp1.frq", header = T, row.names = NULL, col.names = c("CHROM", "POS",	"N_ALLELES", "N_CHR", "FREQ", "gp1_AF"))
gp2_frq <- read.table("/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.gp2.frq", header = T, row.names = NULL, col.names = c("CHROM", "POS",	"N_ALLELES", "N_CHR", "FREQ", "gp2_AF"))
id <- read.table("/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.ID.txt", col.names = "ID")
###################################################
frq <- data.frame(id, gp1_frq$gp1_AF, gp2_frq$gp2_AF)
# VennDiagram
list <- list(bayes = outlier_INS_bayes$ID, pca = outlier_INS_pca$ID, weir = outlier_INS_weir$ID)
p <- ggVennDiagram(list)
p + labs(title = "INSERTOPN",
  caption = Sys.Date())

# Intersection of outlier pcadapt, vcftools, bayescan, AF
intersection <- inner_join(outlier_INS_bayes, outlier_INS_pca, by = "ID")
intersection <- inner_join(intersection, outlier_INS_weir, by = "ID")
intersection <- inner_join(intersection, frq, by = "ID")
intersection <- intersection[, c(1, 7, 8, 9, 12, 4, 13, 14, 6, 5, 2, 3)]
colnames(intersection) <- c("ID", "Chr", "Pos", "pca_q", "vcft_fst", "bayes_q", "gp1_AF", "gp2_AF", "bayes_fst", "bayes_alpha", "bayes_prob", "bayes_log10.PO.")
write.table(intersection, file = "/Users/maxineliu/work/bufo/outlier_methods/Sniffles/12bufo.DEL.outlier.intsect.tsv", sep = "\t", eol = "\n", row.names = F, quote = F)
