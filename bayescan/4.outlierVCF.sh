#!/bin/bash
#Usage: 

# Setting variables
ID_F=/Users/maxineliu/work/bufo/outlier_methods/bayescan.dir/12bufo.DUP.filtered.bayescan.pr10.outlier.id
PR_ODDS=10
IP_VCF=/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.vcf
#######################################
OP_VCF=`basename $IP_VCF .vcf`.bayescan.pr$PR_ODDS.outlier.vcf

## Outlier vcf
bcftools view -i ID==@$ID_F $IP_VCF -o $OP_VCF