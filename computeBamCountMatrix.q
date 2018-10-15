#!/bin/bash

## Script for computing bam alignment count matrix
## Date: 15 Oct 2018 
##
## Example usage:
## project=cohen2017 bed=/scratch/Users/ativ2716/bedgraphBroad/broadPeak/all.broadPeaks.sorted.merged.labelled sbatch computeBamCountMatrix.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --time=1-00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J bamCountMatrix
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# load modules
module load bedtools

# define key variables
bams=$(cat bams.txt)

# run the thing
pwd; hostname; date

echo "Starting bedtools..."
echo $(date +"[%b %d %H:%M:%S] Computing matrix of bam alignment counts...")

# Compute a matrix of bam alignment counts for each region of interest

bedtools multicov -bams ${bams} -bed ${bed} > bamCountsPerRegion_${project}.tab

echo $(date +"[%b %d %H:%M:%S] Done!")
