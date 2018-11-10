#!/bin/bash

## Script to search for repeat enrichment using giggle
## Date: 29 Oct 2018 
##
## Example usage:
## inDir=/Users/ativ2716/testing/broadPeak inFile=c28.h3k27ac.uniq_peaks.broadPeak.bed.gz sbatch giggleSearch.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --time=6:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J giggleSearch
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# run the thing
pwd; hostname; date

cd $inDir

for i in $(cat repeats.txt); 
do
	giggle search -i /Users/ativ2716/testing/eachRep_index/"$i"_index -q $inFile -s; 
done > ${inFile%.bed.gz}.giggleStats

echo $(date +"[%b %d %H:%M:%S] Done!")
