#!/bin/bash

## Script for generating a fastq quality control report
## Date: 2 Oct 2018 
##
## Example usage:
## INDIR=/scratch/Shares/chuong/cohen2017_chip OUTDIR=/Users/ativ2716/testing sbatch --array 0-108 fastqReport.q

#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=1-00:00
#SBATCH --mem=32GB

# Notification configuration 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=%u@adelaide.edu.au

# define query files
QUERIES=($(ls $INDIR/*.fastq.gz | xargs -n 1 basename))

# load modules
module load fastqc/0.11.5

# run the thing
pwd; hostname; date
echo $(date +"[%b %d %H:%M:%S] Starting fastqc")
echo "Processing file: "${QUERIES[$SLURM_ARRAY_TASK_ID]}

fastqc -o ${OUTDIR} -f fastq -t 8 ${INDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}

echo $(date +"[%b %d %H:%M:%S] Done!")
