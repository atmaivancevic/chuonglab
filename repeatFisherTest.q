#!/bin/bash

## Script for running repeat enrichment tests on bed files
## Date: 9 Oct 2018 
##
## Example usage:
## inDir=/scratch/Users/ativ2716/bedgraph/cohen2017_chip outDir=/scratch/Users/ativ2716/repFish/cohen2017_chip sbatch --array 0-31 repeatFisherTest.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --time=1:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J repeatFisher
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# define key variables
genomeAssembly="hg38" # hg38, hg19, mm10, mm9 on /scratch/Shares/chuong

# load modules
module load python/2.7.14/pybedtools/0.7.8 python/2.7.14/pandas/0.18.1 bedtools/2.25.0

# define query files
queries=($(ls $inDir/*.narrowPeak | xargs -n 1 basename))

# run the thing
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Running Fisher enrichment test...")

bed_repeat_enrichment_fisher.py -s $genomeAssembly -i ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]} -p 60 > ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]%.narrowPeak}.repFish.txt

echo $(date +"[%b %d %H:%M:%S] Done!")
