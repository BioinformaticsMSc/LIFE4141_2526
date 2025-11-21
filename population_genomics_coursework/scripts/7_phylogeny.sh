#!/bin/bash
#SBATCH --partition=XXX
#SBATCH --nodes=1
#SBATCH --job-name=phylogeny
#SBATCH --ntasks-per-node=8
#SBATCH --mem=5G
#SBATCH --time=12:00:00
#SBATCH --mail-user=YOUR.NAME@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail

# Script to make quick phylogeny 
# First step is to convert vcf to phylip format using python script
REF=vcf/stick.100b
#python vcf2phylip.py -i $REF.vcf.gz -o $REF.phy

# Use raxml to make bootstrapped phylogeny
module load raxml-ng-uoneasy/1.2.0-GCC-12.3.0
# This may take some time to run even with small datasets
# GTR is model of evolution assumed
raxml-ng --all --msa $REF.phy --threads 8 --force perf_threads --model GTR --prefix $REF --bs-trees 100
# many softwares available to visualise tree, output is Newick Standard Format  
