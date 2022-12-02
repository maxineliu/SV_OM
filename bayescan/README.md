# README.md
## The flow
**bayescan format inout** ➡️ 1.bayescan.sh ➡️ ***_fst.txt** ➡️ 2.plot_R.r ➡️ **fst-q plot, outliers index** ➡️ 3.outlierVCF.sh ➡️ ***.outlier.vcf**
## 1.bayescan.sh
`bayescan.sh` is a slurm script for running bayescan to detect outliers against population whole genome SVs dataset. 

The variables needed to customized are $INPUT $PR_ODDS

All the parameters of the chain used in this script are default except for burn-in (which is set to 100,000).
### Computational consume
| number of markers | RAM | CPU | time |
| ----------------- | --- | --- | ---- |
|         1424          |  4G   |  12   |   4 mins   |
|                   |     |     |      |
|                   |     |     |      |
## 2.plot_R.r
It is to plot Fst-q graph. And return an outlier index file. 
## 3.outlierVCF.sh
Return outlier VCF according to outlier index file.