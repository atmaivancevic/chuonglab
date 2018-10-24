#!/bin/bash

## Script to generate a giggle index dir for each repeat
## Date: 23 Oct 2018 
##
## Example usage:
## sbatch giggleIndex.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=6:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J giggleIndex
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# load modules
module load bedtools samtools

# run the thing
pwd; hostname; date

cd /Users/ativ2716/testing/eachRep_sorted

for i in *.bed.gz; 
do 	
	echo $i; 
	giggle index -i $i -o /Users/ativ2716/testing/${i%.bed.gz}_index -f -s; 
done

echo $(date +"[%b %d %H:%M:%S] Done!")
