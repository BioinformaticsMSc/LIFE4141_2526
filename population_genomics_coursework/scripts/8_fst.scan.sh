#!/bin/bash
#SBATCH --partition=XXX
#SBATCH --nodes=1
#SBATCH --job-name=fst.scan
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1G
#SBATCH --time=2:00:00
#SBATCH --mail-user=YOUR.NAME@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail

module load vcftools-uoneasy/0.1.16-GCC-12.3.0

# Use this command to extract individual names (which will include path)
# module load bcftools-uoneasy/1.18-GCC-13.2.00
# bcftools query -l $YOURVCF
# Basic script to estimate Fst in windows across the genome
# Example code for vcftools Fst window scan in obse vs obsm contrast

vcftools --gzvcf vcf/stick.100b.vcf.gz \
--max-missing 0.8 \
--maf 0.05 \
--weir-fst-pop obse.txt \
--weir-fst-pop obsm.txt \
--fst-window-size 5000 \
--fst-window-step 5000

# Best practice to keep only sites with less than 20% of the data missing
# MAF as before - both MAF and missing should have no impact because already filtered on this basis
# A suggested window size; you may experiment to see if you can reduce this to the point that adjacent outlier (top 1%) windows start to get similar values.
# Means windows will not overlap with the above window-size. Change in concert with that value.

# Plain text files required for the above according to vcftools manual, list of the membership of each population:

