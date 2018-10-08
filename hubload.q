#!/bin/bash

## Script for adding tracks with hubload.py
## Date: 8 Oct 2018 
##
## Example usage:
## inDir=/scratch/Users/ativ2716/bigwig/cohen2017_chip project=cohen2017_chip trackdb=~/hub/hg38/trackDb.txt sbatch --array 0-31 hubload.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=6:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J hubload
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu


# define query files
queries=($(ls $inDir/*.bw | xargs -n 1 basename))

# commands go here
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo "Project: "$project
echo "TrackDb: "$trackdb

echo $(date +"[%b %d %H:%M:%S] Adding tracks to hub...")

hubload.py --input ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]} --supertrack $project --trackDb $trackdb

echo $(date +"[%b %d %H:%M:%S] Done!")
