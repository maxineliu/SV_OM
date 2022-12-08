#! /bin/bash
# This script is used to calculate an Fst estimate from Weir and Cockerham’s 1984 paper using vcftools. Running this script needs files listed as: 1) The VCF 2) group file per group
# setting varibles
IP_VCF=/Users/maxineliu/work/bufo/VCF_files/ins/12bufo.INS.filtered.vcf
GP_NUM=2
GP1_F=/Users/maxineliu/work/bufo/VCF_files/group1
######################################

OP_suffix=`basename $IP_VCF .vcf`
for ((i=1; i<=$GP_NUM; i++))
do
GP_CMD=$GP_CMD" --weir-fst-pop ${GP1_F%/*}/group$i"
done
## per-site basis Fst estimate
vcftools --vcf $IP_VCF --out $OP_suffix $GP_CMD # output is *.weir.fst

## windowed basis 
# vcftools --vcf $IP_VCF --fst-window-size 1000000 --fst-window-step 10000 --out $OP_suffix $GP_CMD # output is *.windowed.weir.fst

## SV ID list
bcftools view -H $IP_VCF | cut -f3 > ${OP_suffix}_ID.txt
