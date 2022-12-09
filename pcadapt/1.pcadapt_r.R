# PCA-based outlier approach, Mahalanobis distance
# More details see 
# install.packages("pcadapt")
library(pcadapt)
library(CMplot)
library(dplyr)
# Step 1: Convert VCF to bed format that is PLINK binary biallelic genotype, using read.pcadapt function 
# load example input file
# path_to_file <- system.file("extdata", "geno3pops.bed", package = "pcadapt")
# filename <- read.pcadapt(path_to_file, type = "bed")
# setting variables
path_to_file <- "/Users/maxineliu/work/bufo/VCF_files/ins/12bufo.INS.filtered.bed"
###########################
filename <- read.pcadapt(path_to_file, type = "bed")

# Step 2: Perform PCA with a large enough number of principal components (K=20)
x <- pcadapt(input = filename, K = 10)
# We assume in the following that there are n individuals and L markers.
# scores is a (n,K) matrix corresponding to the projections of the individuals onto each PC.
# singular.values is a vector containing the K ordered square root of the proportion of variance explained by each PC.
# loadings is a (L,K) matrix containing the correlations between each genetic marker and each PC.
# zscores is a (L,K) matrix containing the 𝑧-scores.
# af is a vector of size L containing allele frequencies of derived alleles where genotypes of 0 are supposed to code for homozygous for the reference allele.
# maf is a vector of size L containing minor allele frequencies.
# chi2.stat is a vector of size L containing the rescaled statistics stat/gif that follow a chi-squared distribution with K degrees of freedom.
# gif is a numerical value corresponding to the genomic inflation factor estimated from stat.
# pvalues is a vector containing L p-values.
# pass A list of SNPs indices that are kept after exclusion based on the minor allele frequency threshold.
# stat is a vector of size L containing squared Mahalanobis distances by default.
# All of these elements are accessible using the $ symbol. For example, the p-values are contained in x$pvalues.

# Step 3: Choosing the number K of Principal Components
# 3.1 Scree plot
# The ‘scree plot’ displays in decreasing order the percentage of variance explained by each PC. Up to a constant, it corresponds to the eigenvalues in decreasing order. The ideal pattern in a scree plot is a steep curve followed by a bend and a straight line. The eigenvalues that correspond to random variation lie on a straight line whereas the ones that correspond to population structure lie on a steep curve. We recommend to keep PCs that correspond to eigenvalues to the left of the straight line (Cattell’s rule).
plot(x, option = "screeplot", K = 10)
# 3.2 Score plot
# Another option to choose the number of PCs is based on the ‘score plot’ that displays population structure. The score plot displays the projections of the individuals onto the specified principal components. Using the score plot, the choice of K can be limited to the values of K that correspond to a relevant level of population structure.
# When population labels are known, individuals of the same populations can be displayed with the same color using the pop argument, which should contain the list of indices of the populations of origin. Thus, a vector of indices or characters (population names) that can be provided to the argument pop should look like this:
poplist <- c(rep(1, 6), rep(2, 6))
# By default, if the values of i and j are not specified, the projection is done onto the first two principal components.
plot(x, option = "scores", i = 3, j = 4, pop = poplist)
# Find the Kth principal component do not ascertain population structure anymore.

# (Optional) Step 4: Linkage Disequilibrium (LD) thinning
# Thinning SNPs should perform with choosing K, not after choosing K.
# Linkage Disequilibrium can affect ascertainment of population structure (Abdellaoui et al. 2013). Users analyzing dense data such as whole genome sequence data or dense SNP data should account for LD in their genome scans.
# In pcadapt, there is an option to compute PCs after SNP thinning. SNP thinning make use of two parameters: window size (default 200 SNPs) and 𝑟2 threshold (default 0.1). The genome scan is then performed by looking at associations between all SNPs and PCs ascertained after SNP thinning.
par(mfrow = c(2, 2))
for (i in 1:4)
  plot(x$loadings[, i], pch = 19, cex = .3, ylab = paste0("Loadings PC", i))
# Here, if one or more figures show that PC is determined by a single region, which is likely to be a region of strong LD, we should therefore thin SNPs in order to compute the PCs.
x <- pcadapt(filename, K = 20, LD.clumping = list(size = 200, thr = 0.1))
# Then choose K value using 3.1 and/or 3.2. See loading PC again. For example, optimal K is 2.
res <- pcadapt(filename, K = 2, LD.clumping = list(size = 200, thr = 0.1))
par(mfrow = c(1, 2))
for (i in 1:2)
  plot(res$loadings[, i], pch = 19, cex = .3, ylab = paste0("Loadings PC", i))
# If the distribution of the loadings is now evenly distributed, we can have a look at the genome scan, which correctly identifies regions involved in adaptation. Other wise, modify the parameters in LD.clumping.

# Step 5: Perform PCA with optimal LD parameters and K value
# res <- pcadapt(filename, K = 2, LD.clumping = list(size = 200, thr = 0.1))
res <- pcadapt(filename, K = 1)

# Step 6: Multiple comparisons adjustment
# To provide a list of outliers and choose a cutoff for outlier detection, there are three methods that are listed below from the less conservative one to the more conservative one.
# 6.1 q-values
## try http if https is not available
# BiocManager::install("qvalue")
# library(qvalue)
# qval <- qvalue(res$pvalues)$qvalues
# alpha <- 0.1
# outliers <- which(qval < alpha)
# length(outliers)
# 6.2 Benjamini-Hochberg Procedure
# padj <- p.adjust(res$pvalues,method="BH")
# alpha <- 0.1
# outliers <- which(padj < alpha)
# length(outliers)
# 6.3 Bonferroni correction (most conservative amomg 3)
padj <- p.adjust(res$pvalues,method="bonferroni")
alpha <- 0.01
length(which(padj <= alpha)) # number of outliers 

# Step 7: Graphical tools
# Manhattan Plot
plot(res , option = "manhattan") # pcadapt内置


# system("vcffile=/Users/maxineliu/work/bufo/VCF_files/ins/12bufo.INS.filtered.vcf")
# system("bcftools query -f '%ID\t%CHROM\t%POS\n' $vcffile > ${TMPDIR}out.tsv")
# 以上两条,未知原因在r中无法成功运行,自行复制去terminal
ManData <- read.table("/var/folders/b0/5wlh4ctx5ln29qw23gtf3gch0000gn/T/out.tsv", header = F, col.names = c("ID", "CHR", "POS"))
ManData$Qval <- padj
ManData <- ManData[complete.cases(ManData),]

write.table(arrange(ManData[ManData$Qval<= alpha,], Qval), file = "/Users/maxineliu/work/bufo/outlier_methods/Sniffles/pcadapt/12bufo.INS.filtered.outlier.qval.txt", sep = "\t", eol = "\n", row.names = F, quote = F)

ManData$log10.q <- -log10(ManData$Qval)
ManData <- ManData[,-4]
# png(paste(prefix, "_pcadapt.png", sep = ""), width=960, height=480)
# CMplot(ManData,
#        type = "h",
#        plot.type = "m",
#        LOG10 = F,
#        col = c("blue4", "orange3"),
#        cex = 0.2,
#        band = 0.5,
#        ylab.pos = 2, 
#        cex.axis = 1,
#        threshold = 0.05 , ## 显著性阈值
#        threshold.col = 'red',  ## 阈值线颜色
#        threshold.lty = 2, ## 阈值线线型
#        threshold.lwd = 1, ## 阈值线粗细
#        amplify = F,  ## 放大
#        ylab="-log10(q)",
#        file.output = F )

chr_name <- c("NC_058080.1", "NC_058081.1", "NC_058082.1", "NC_058083.1", "NC_058084.1", "NC_058085.1", "NC_058086.1", "NC_058087.1", "NC_058088.1", "NC_058089.1", "NC_058090.1", "NC_008410.1")

par(mfrow = c(4, 1))
for (i in 1:4) {
  CMplot(subset(ManData, CHR == chr_name[i]),
         type = "p",
         plot.type = "m",
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = -log10(alpha) , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="-log10(q)",
         file.output = F )
}

par(mfrow = c(4, 1))
for (i in 5:8) {
  CMplot(subset(ManData, CHR == chr_name[i]),
         type = "p",
         plot.type = "m",
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = -log10(alpha) , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="-log10(q)",
         file.output = F )
}

par(mfrow = c(4, 1))
for (i in 9:12) {
  CMplot(subset(ManData, CHR == chr_name[i]),
         type = "p",
         plot.type = "m",
         LOG10 = F,
         col = c("blue4"),
         cex = 0.2,
         band = 0,
         ylab.pos = 2, 
         cex.axis = 1,
         threshold = -log10(alpha) , ## 显著性阈值
         threshold.col = 'red',  ## 阈值线颜色
         threshold.lty = 2, ## 阈值线线型
         threshold.lwd = 1, ## 阈值线粗细
         amplify = F,  ## 放大
         ylab="-log10(q)",
         file.output = F )
}

# Q-Q plot, Histograms of the test statistic and of the p-values, see https://bcm-uga.github.io/pcadapt/articles/pcadapt.html




