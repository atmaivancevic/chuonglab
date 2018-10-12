#!/bin/bash

## Script for calling peaks with macs2
## Date: 3 Oct 2018 
##
## Example usage:
## inDir=/scratch/Users/ativ2716/bam/cohen2017_chip outDir=/scratch/Users/ativ2716/bedgraphBroad name=V411.h3k27ac.uniq chipFile=SRR3157792_1.uniq.bam controlFile=SRR3157865_1.uniq.bam genome=hs sbatch callPeaks_broad.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --time=3:00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J macs2-call
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# load modules
module load python/2.7.14/MACS/2.1.1

# run the thing
pwd; hostname; date

echo "Starting macs2 peak calling..."
echo "Processing chip library: "$name
echo "Treatment file: "$chipFile
echo "Control file: "$controlFile
echo "Genome: "$genome

# --SPMR and -B are to make a normalized bedgraph file
# -g hs sets genome size to homo sapiens (2.7e9). This is the default.
# Effective genome size can be a number: e.g. 1.0e+9 or 1000000000,
#                          or shortcuts: 'hs' for human (2.7e9), 
#                                        'mm' for mouse (1.87e9), 
#                                        'ce' for C. elegans (9e7), 
#                                        'dm' for fruitfly (1.2e8).

macs2 callpeak -t $inDir/$chipFile -c $inDir/$controlFile -n $name  -g $genome --SPMR -B --broad --outdir $outDir

# use "-f BAMPE" if using paired end data

echo $(date +"[%b %d %H:%M:%S] Done!")
