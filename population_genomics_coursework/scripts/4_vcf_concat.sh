#!/bin/bash
# Script for mpileup in bcftools to generate VCF / BCF file
#SBATCH --partition=XXX
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=stickpileupMQ20
#SBATCH --mem=20g
#SBATCH --time=24:00:00
#SBATCH --mail-user=YOUR.NAME@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
module load bcftools-uoneasy/1.18-GCC-13.2.0

# Concatenate all vcf files into a single vcf file
bcftools concat --file-list vcf.list.txt -Oz --output XXX/vcf/stick.vcf.gz
bcftools index XXX/vcf/stick.vcf.gz

