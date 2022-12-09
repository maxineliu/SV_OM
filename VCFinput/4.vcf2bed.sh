#!/bin/bash
# Usage: plink *.filted.vcf

OP_prefix=`basename $1 .vcf`

~/BIO-SOFTWARE/plink2 --vcf $1 --make-bed --allow-extra-chr --out $OP_prefix