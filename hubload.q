#!/bin/bash

## Script for adding tracks with hubload.py
## Date: 8 Oct 2018 
##
## Example usage:
## inDir=/scratch/Users/ativ2716/bigwig/cohen2017_chip project=cohen2017_chip trackdb=~/hub/hg38/trackDb.txt sbatch hubload.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=1:00:00
#SBATCH --mem=1GB

# Job name and output
#SBATCH -J hubload
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# commands go here
pwd; hostname; date

echo "Project: "$project
echo "TrackDb: "$trackdb

echo $(date +"[%b %d %H:%M:%S] Adding tracks to hub...")

for i in $inDir/*.bw 
do
	echo "Processing file: "$i
	hubload.py --input $i --supertrack $project --trackDb $trackdb
	echo $(date +"[%b %d %H:%M:%S] Done")
done

echo $(date +"[%b %d %H:%M:%S] All done!")
