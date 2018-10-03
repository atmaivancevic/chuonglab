#!/bin/bash

## Script for aligning single-ended fastq files
## Date: 3 Oct 2018 
##
## Example usage:
## inDir=/scratch/Shares/chuong/cohen2017_chip outDir=/scratch/Users/ativ2716/bam/cohen2017_chip sbatch --array 0-108 bwaAlignSingleEnded.q

# General settings
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 64
#SBATCH --time=3-00:00
#SBATCH --mem=70GB

# Job name and output
#SBATCH -J bwa-single
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# define key variables
bwaIndexDir=/scratch/Shares/chuong/genomes/hg38
bwaIndex=hg38.main.fa

# define query files
queries=($(ls $inDir/*.fastq.gz | xargs -n 1 basename))

# load modules
module load bwa/0.7.15 samtools/1.8

# run the thing
pwd; hostname; date

echo "Starting bwa alignment..."
echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}

bwa mem -t 64 ${bwaIndexDir}/${bwaIndex} ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]} \
| samtools view -Sb -q 10 - \
> ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]%.fastq.gz}.uniq.bam

echo $(date +"[%b %d %H:%M:%S] Done!")
