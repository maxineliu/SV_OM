#!/bin/bash

# Setting variables
OUTLIER_Q=/Users/maxineliu/work/bufo/outlier_methods/Sniffles/pcadapt/12bufo.INS.filtered.outlier.qval.txt
IP_VCF=/Users/maxineliu/work/bufo/VCF_files/ins/12bufo.INS.filtered.vcf
#######################################
OP_prefix=`basename $IP_VCF .vcf`

## list of outlier IDs
cut -f1 $OUTLIER_Q | tail -n +2 > $OP_prefix.outlier.id 
## Outlier vcf
bcftools view -i ID==@$OP_prefix.outlier.id $IP_VCF -o $OP_prefix.outlier.vcf