# README.md
**VCFinput folder** includes scripts and groupN example that involve in the procedure of generating input files for outlier methods(pcadapt, bayescan, vcftools for now)
## The flow 
**Original VCF (from variants caller)** ➡️ 1.subsetBYtype.sh ➡️ **VCF subsets** ➡️ 2.filteringVCF.sh ➡️ **filted VCF** ➡️ 3.BayescanFormat.sh ➡️ **bayesscan format input files**

## Arguments/Usages of scripts
### 1.subsetBYtype.sh
Usage: ./subsetBYtype.sh <original VCF>
For example, ./subsetBYtype.sh 12bufo.vcf
Output: 12bufo.INS.vcf (INS DEL DUP INV BND)

### 2.filteringVCF.sh
Usage: ./filteringVCF.sh <one type VCF> <sample size * 2>
For example, ./filteringVCF.sh 12bufo.INS.vcf 24
Output: 12bufo.INS.filted.vcf

### 3.BayescanFormat.sh
Usage ./bayescanFormat.sh <filted vcf> <group number> 
nested function: freq2bayescan (compiled from freq2bayescan.cppz)
For example, ./bayescanFormat.sh 12bufo.INS.filted.vcf 2
Other files needed: group1 group2 ... groupN
Output: 12bufo.INS.filted.bayescan