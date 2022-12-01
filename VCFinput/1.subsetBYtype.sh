#! /bin/bash

#Usage: subsetBYtype.sh <original VCF>

filename=`basename $1 .vcf`

if [ $# -lt 1 ]; then
    echo "Error. Usage: subsetBYtype.sh <original VCF>"
fi

## Subset original VCF by SV types (INS DEL DUP INV BND)
# ('INS' 'DEL' 'DUP' 'INV' 'BND')
# SV_type=(INS DEL DUP INV BND)
for type in "'INS'" "'DEL'" "'DUP'" "'INV'" "'BND'"
do
bcftools view -i "INFO/SVTYPE=$type" $1 -o $filename.${type:1:3}.vcf
done