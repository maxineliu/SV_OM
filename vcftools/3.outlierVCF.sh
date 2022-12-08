#!/bin/bash

# Setting variables
ID_F=/Users/maxineliu/work/bufo/outlier_methods/VCFtools/12bufo.DUP.filtered.outlier.id
IP_VCF=/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.vcf
#######################################
OP_VCF=`basename $IP_VCF .vcf`.vcftools.outlier.vcf

## Outlier vcf
bcftools view -i ID==@$ID_F $IP_VCF -o $OP_VCF