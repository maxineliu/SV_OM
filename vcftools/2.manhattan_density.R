#!/usr/bin/env Rscript

# args=commandArgs(TRUE)
# if (length(args) != 2) {
#           print ("usage: <Fst>   <out.prefix> ")
#   q()
# }
# 
# input <- args[1]
# #max_y <- as.numeric(args[3])
# prefix <- args[2]

library(CMplot)
library(dplyr)

# Setting variables
input_F <- "/Users/maxineliu/work/bufo/outlier_methods/Sniffles/VCFtools/results_plots/12bufo.DUP.filtered.weir.fst" #fst file
input_ID <- "/Users/maxineliu/work/bufo/outlier_methods/Sniffles/VCFtools/results_plots/12bufo.DUP.filtered_ID.txt" # ID list
# cutoff in line 36
# n in line 38
# file name in line 40
################################

data_F <- read.table(input_F, header = T);
data_ID <- read.table(input_ID, header = F)

Fst <-data.frame(ID = data_ID,
                 chr = data_F[,1],
                 pos = data_F[,2],
                 val = data_F[,3])

colnames(Fst) <- c("ID", "chr", "pos", "val")

Fst[Fst$val <0, 4] <- 0

cutoff <- quantile(Fst$val,0.99)
length(which(Fst$val > cutoff)) #outlier个数
outlier <- Fst %>% slice_max(val, n=14) #return rows with the biggest N Fst
ID_outlier <- outlier[,1]
write(ID_outlier, file = "/Users/maxineliu/work/bufo/outlier_methods/VCFtools/12bufo.DUP.filtered.outlier.id", sep = "\n") # extract outlier records from VCF
write.table(arrange(outlier, desc(val)), file = "/Users/maxineliu/work/bufo/outlier_methods/VCFtools/12bufo.DUP.filtered.outlier.weir.fst", sep = "\t", eol = "\n", row.names = F, quote = F)
chr_name <- c("NC_058080.1", "NC_058081.1", "NC_058082.1", "NC_058083.1", "NC_058084.1", "NC_058085.1", "NC_058086.1", "NC_058087.1", "NC_058088.1", "NC_058089.1", "NC_058090.1", "NC_008410.1")
# subset <- c("Fst1",	"Fst2",	"Fst3",	"Fst4",	"Fst5", "Fst6", "Fst7", "Fst8", "Fst9", "Fst10", "Fst11", "FstMito")

# png(paste(prefix, "_Fst.png", sep = ""), width=960, height=480)
# pdf(paste("ins1", "_Fst.pdf", sep = ""), width=10, height=5)

## SV density plot
CMplot(Fst,
         type = "p", #a character, could be "p"(point), "l"(line), "h"(vertical lines) and so on, is thesame with "type" in <plot>
         plot.type = "d", #"d",SNP density; "c", circle-Manhattan; "m", Manhattan; "q", Q-Q plot; "b", circle-Manhattan, Manhattan and Q-Q plots; c("m","q"), Manhattan and Q-Q plots
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = cutoff , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="Fst",
         file.output = F )

## Manhattan plot
par(mfrow = c(4, 1))
for (i in 1:4) {
  CMplot(Fst[Fst$chr == chr_name[i],],
         type = "p",
         plot.type = "m",
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = cutoff , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="Fst",
         file.output = F )
}

par(mfrow = c(4, 1))
for (i in 5:8) {
  CMplot(Fst[Fst$chr == chr_name[i],],
         type = "p",
         plot.type = "m",
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = cutoff , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="Fst",
         file.output = F )
}

par(mfrow = c(4, 1))
for (i in 9:12) {
  CMplot(Fst[Fst$chr == chr_name[i],],
         type = "p",
         plot.type = "m",
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = cutoff , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="Fst",
         file.output = F )
}

# dev.off()

# pdf(paste(prefix, "_Fst.pdf", sep = ""), width=10, height=5)
# CMplot(Fst,
#        type = "h",
#        plot.type = "m",
#        LOG10 = F,
#        col = c("blue4", "orange3"),
#        cex = 0.2,
#        band = 0.5,
#        ylab.pos = 2, 
#        cex.axis = 1,
#        threshold = cutoff , ## 显著性阈值
#        threshold.col = 'red',  ## 阈值线颜色
#        threshold.lty = 2, ## 阈值线线型
#        threshold.lwd = 1, ## 阈值线粗细
#        amplify = F,  ## 放大
#        ylab="Fst",
#        file.output = F )
# dev.off()


