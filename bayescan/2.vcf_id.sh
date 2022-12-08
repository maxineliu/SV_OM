#! /bin/bash
# setting varibles
IP_VCF=/Users/maxineliu/work/bufo/VCF_files/dup/12bufo.DUP.filtered.vcf
################
OP_suffix=`basename $IP_VCF .vcf`

## SV ID list
bcftools view -H $IP_VCF | cut -f3 > ${OP_suffix}_ID.txt
