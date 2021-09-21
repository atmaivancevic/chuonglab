#!/bin/bash

## Script for sorting and indexing bam files
## Date: 15 Oct 2018 
##
## Example usage:
## inDir=/scratch/Users/ativ2716/bam/cohen2017_chip/treatment sbatch --array 0-31 bamSortAndIndex.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --time=1-00:00
#SBATCH --mem=64GB

# Job name and output
#SBATCH -J bamSortAndIndex
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# define query bam files
queries=($(ls $inDir/*.bam | xargs -n 1 basename))

# load modules
module load samtools/1.8

# run the thing
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Sorting bam file...")

samtools sort ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]} -o ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]}.sorted

echo $(date +"[%b %d %H:%M:%S] Indexing bam file...")

samtools index ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]}.sorted

echo $(date +"[%b %d %H:%M:%S] Done!")

