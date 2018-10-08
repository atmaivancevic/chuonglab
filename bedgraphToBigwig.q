#!/bin/bash

## Script for converting bedgraphs to bigwigs
## Date: 8 Oct 2018 
##
## Example usage:
## inDir=/scratch/Users/ativ2716/bedgraph/cohen2017_chip outDir=/scratch/Users/ativ2716/bigwig/cohen2017_chip sbatch --array 0-31 bedgraphToBigwig.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=6:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J bedgraphToBigwig
#SBATCH -o /Users/%u/slurmOut/slurm-%A_%a.out
#SBATCH -e /Users/%u/slurmErr/slurm-%A_%a.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# define key variables
chromSizesFile=/scratch/Shares/chuong/genomes/hg38/hg38.chrom.sizes

# define query files
queries=($(ls $inDir/*treat*.bdg | xargs -n 1 basename))

# run the thing
pwd; hostname; date

echo "Processing file: "${queries[$SLURM_ARRAY_TASK_ID]}
echo $(date +"[%b %d %H:%M:%S] Sorting bedgraph...")

sort -k1,1 -k2,2n ${inDir}/${queries[$SLURM_ARRAY_TASK_ID]} > ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]%.bdg}.sorted.bdg

echo $(date +"[%b %d %H:%M:%S] Converting sorted bedgraph to bigwig...")

bedGraphToBigWig ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]%.bdg}.sorted.bdg $chromSizesFile ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]%.bdg}.bw

echo $(date +"[%b %d %H:%M:%S] Removing sorted bedgraph")

rm ${outDir}/${queries[$SLURM_ARRAY_TASK_ID]%.bdg}.sorted.bdg

echo $(date +"[%b %d %H:%M:%S] Done!")
