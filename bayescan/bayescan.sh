#!/bin/bash
#SBATCH --time=2-00:00:00 #e.g. 24:00:00, 1-13:00:00
#SBATCH --job-name=bayescan_ins
#SBATCH --mem=4G #e.g. 100G
#SBATCH --account=def-jfu
#SBATCH --cpus-per-task=36
#SBATCH --mail-type=All #Valid type values are NONE, BEGIN, END, FAIL, REQUEUE, ALL (equivalent to BEGIN, END, FAIL, INVALID_DEPEND, REQUEUE, and STAGE_OUT), INVALID_DEPEND (dependency never satisfied), STAGE_OUT (burst buffer stage out and teardown completed), TIME_LIMIT, TIME_LIMIT_90 (reached 90 percent of time limit), TIME_LIMIT_80 (reached 80 percent of time limit), TIME_LIMIT_50 (reached 50 percent of time limit) and ARRAY_TASKS (send emails for each array task).
#SBATCH --mail-user=rliu13@uoguelph.ca
##SBATCH --array=1-2 #e.g.--array=0,6,16-32, --array=0-15:4 (equivalent to --array=0,4,8,12), --array=0-15%4 (limit number of simultaneously running jobs) 

# Environmrntal Vatiables: $SLURM_CPUS_PER_TASK $SLURM_JOB_ID
set -xv
start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`

# echo "Starting task $SLURM_ARRAY_TASK_ID"

cd /home/maxine91/bayescan.dir
module load StdEnv/2020 bayescan/2.1

INPUT=/home/maxine91/bayescan.dir/input.dir/12bufo.INS.filtered.bayescan
OUTPUT=`basename $INPUT .bayescan`
# PR_ODDS=$(sed -n "${SLURM_ARRAY_TASK_ID}p" pr.txt)
PR_ODDS=1000

bayescan_2.1 $INPUT -o ${OUTPUT}_pr$PR_ODDS -n 5000 -thin 10 -nbp 20 -pilot 5000 -burn 100000 -pr_odds $PR_ODDS -threads $SLURM_CPUS_PER_TASK

finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))
dhours=`echo "scale=5;a=$duration/3600;if(length(a)==scale(a)) print 0;print a"|bc`

echo "this shell script execution duration: $duration sec"
echo "this shell script execution duration: $dhours hours"


