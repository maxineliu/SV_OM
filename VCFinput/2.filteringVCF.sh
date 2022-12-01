#! /bin/bash

# Usage: ./filteringVCF.sh <one type VCF> <sample size * 2>, for example, ./filteringVCF.sh 12bufo.INS.vcf 24
# This script is used to filter original VCF generated from SVs caller. It takes ONLY ONE type SVs VCF as input (type: INS, DEL, DUP) and then remove SVs that 1) fail to pass one or more filters in VCF filter column, 2) exclude SVs that located in identical locus (more possible because of bad calling), 3) filter out records that AN / 2N < 0.8 (where N is sample size), 4) exclude markers with minor allele frequency less than 0.05, 5) exclude SVs located on unmapped scaffolds.

# Global variable 
filename=`basename $1 .vcf`

if [ $# -lt 2 ]; then
    echo "Command is error. Usage: filteringVCF.sh <one type VCF> <sample size * 2>"
fi
## Step 1: pass filter
bcftools view -f "PASS" $1 -o $filename.pass.vcf

## Step 2: exclude SVs that located in identical locus
### print out duplicates CHROM and POS 
bcftools view -H $filename.pass.vcf | cut -f 1,2 | uniq -d > $TMPDIR/dupPOS.txt

### make a subset of repetitive SVs
bcftools view -T ${TMPDIR}/dupPOS.txt $filename.pass.vcf -o $filename.pass.rpt.vcf

### make a subset of excluding repetitions
bcftools view -T ^"${TMPDIR}/dupPOS.txt" $filename.pass.vcf -o $filename.pass.nrpt.vcf

## Step 3: filter out records that AN / 2N < 0.8 && MAF < 0.05
bcftools view -e "INFO/AN / $2 < 0.8 || MAF < 0.05" $filename.pass.nrpt.vcf -o $filename.pass.nrpt.ms20.maf0.05.vcf

## Step 4: compress and index vcf
bgzip -k $filename.pass.nrpt.ms20.maf0.05.vcf
bcftools index $filename.pass.nrpt.ms20.maf0.05.vcf.gz

## Step 4: exclude SVs located on unmapped scaffolds
bcftools view -r NC_058080.1,NC_058081.1,NC_058082.1,NC_058083.1,NC_058084.1,NC_058085.1,NC_058086.1,NC_058087.1,NC_058088.1,NC_058089.1,NC_058090.1,NC_008410.1 $filename.pass.nrpt.ms20.maf0.05.vcf.gz -o $filename.pass.filtered.vcf