#!/bin/bash
#Usage: 

# Setting variables
ID_F=/Users/maxineliu/work/bufo/outlier_methods/VCFtools/results_plots/12bufo.DUP.filtered.outlier.index
IP_VCF=/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.vcf
#######################################
OP_VCF=`basename $IP_VCF .vcf`.bayescan.pr$PR_ODDS.outlier.vcf
bcftools view -h $IP_VCF > $OP_VCF

cat $ID_F | while read LINE || [[ -n $LINE ]]
do 
bcftools view -H $IP_VCF | sed -n "${LINE}p" >> $OP_VCF
done