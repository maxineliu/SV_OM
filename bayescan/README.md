# README.md
## The flow
**bayescan format input** ➡️ 1.bayescan.sh (on cluster) + 2.vcf_id.sh ➡️ **\*_fst.txt + SV IDs list** ➡️ 3.plot_R.r ➡️ **fst-q plot, ouliers fst list** 
**outliers id** ➡️ 3.outlierVCF.sh ➡️ ***.outlier.vcf**
## 1.bayescan.sh
`bayescan.sh` is a slurm script for running bayescan to detect outliers against population whole genome SVs dataset. 

The variables needed to customized are $INPUT $PR_ODDS

All the parameters of the chain used in this script are default except for burn-in (which is set to 100,000).
### Computational consume
| number of markers | RAM | CPU | time |
| ----------------- | --- | --- | ---- |
|         1424          |  4G   |  12   |   4 mins   |
|         788,011            |  4G   |  36   |   1 day 7.5 hours   |
|         691,936          |  4G   |   36  |   1 day 5.1 hours   |
## 3.plot_R.r
It is to plot Fst-q graph. And return an outlier index file. 
## 4.outlierVCF.sh
Return outlier VCF according to outlier index file.