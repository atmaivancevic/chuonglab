#!/bin/bash

## Script for calling peaks with macs2
## Date: 12 Oct 2018 
##
## Example usage:
## name=LTR7Y bed=/scratch/Shares/chuong/genomes/hg38/repeats/eachRep/LTR7Y.bed sbatch deeptools.q

# General settings
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --time=1-00:00
#SBATCH --mem=8GB

# Job name and output
#SBATCH -J deeptools
#SBATCH -o /Users/%u/slurmOut/slurm-%j.out
#SBATCH -e /Users/%u/slurmErr/slurm-%j.err

# Email notifications 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=atma.ivancevic@colorado.edu

# load modules
module load singularity

# define key variables
wigs=$(cat bigwigs.txt)

# run the thing
pwd; hostname; date

echo "Starting deeptools..."
echo $(date +"[%b %d %H:%M:%S] Compute matrix...")

# Use "computeMatrix" to generate data underlying heatmap
windowLeft=2000
windowRight=2000
binSize=10
numCPU=16

singularity exec --bind /scratch /scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img computeMatrix reference-point --referencePoint TSS --scoreFileName ${wigs} --regionsFileName ${bed} --beforeRegionStartLength ${windowLeft} --afterRegionStartLength ${windowRight} --binSize ${binSize} --missingDataAsZero -o ${name}.mat.gz -p ${numCPU}

echo $(date +"[%b %d %H:%M:%S] Plot heatmap...")

# Use "plotHeatmap" to create a png or pdf
samplesLabel=$(cat bigwigs.txt | xargs -n 1 basename | sed 's/.h3k27ac.uniq_treat_pileup//g')
zMin=0
yMin=0

singularity exec --bind /scratch /scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img plotHeatmap -m ${name}.mat.gz --outFileName ${name}.png --colorMap Blues --zMin $zMin --yMin $yMin --outFileSortedRegions ${name}.dt.bed --regionsLabel ${name}.bed --samplesLabel $samplesLabel --plotTitle ${name}_heatmap

echo $(date +"[%b %d %H:%M:%S] Done!")
