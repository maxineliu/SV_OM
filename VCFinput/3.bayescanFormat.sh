#! /bin/bash
# Usage ./bayescanFormat.sh <filted vcf> <group number>, for example, ./bayescanFormat.sh 12bufo.INS.filted.vcf 2
# Files needed when running this script, 1) input vcf, 2) group file named as group1 group2 group3 group4..., where list all samples belong to the Nth group, one line one sample 
# This script is to 1) split VCF by sample groups, 2) generate bayescan format input. Group information is needed, which are saved in file group1, group2 and restored with this scripted.

filename=`basename $1 .vcf`

if [ $# -lt 2 ]; then
    echo "Command is error. Usage: ./bayescanFormat.sh <filted vcf> <group number>"
fi

## Step 1: Slipt VCF by groups and generate "vcftools -freq2" output
for i in {1..$2}
do
bcftools view -S group$i $1 -o $filename.gp$i.vcf
vcftools --vcf $filename.gp$i.vcf --freq2 --out $filename.gp$i # output are "$vcf_file.gp$i.frq" and a log file with same prefix
done

## Step 2: convert frq file to bayescan input format
# freq2bayescan is coded by c++. Usage: 
./
