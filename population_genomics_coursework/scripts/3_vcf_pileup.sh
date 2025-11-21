#!/bin/bash
# Script for mpileup in bcftools to generate VCF / BCF file
#SBATCH --partition=XXX
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=stickpileupMQ20
#SBATCH --mem=20g
#SBATCH --time=24:00:00
#SBATCH --array=0-19 #20 individual chromosomes
#SBATCH --mail-user=YOUR.NAME@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
module load bcftools-uoneasy/1.18-GCC-13.2.0

# This took ~30 minutes to run

# Load chromosomes names into an array
# Note that for simplicity we are not using chrM (mitochondria), chrY (male sex chr) and chr19 (X chr). 
mapfile -t ROOTS < chr.names.txt
SAMPLE=${ROOTS[$SLURM_ARRAY_TASK_ID]}

# Reference genome and regions
REF=XXX/genome/stickleback_v5_assembly.fa
# Run as an array so one vcf file for each chromosomes
OUT=XXX/vcf/stick.MQ20.${SAMPLE}.vcf.gz
# txt file listing all bam files, including path 
BAMLIST=bam_list.txt

# Run bcftools mpileup and variant calling
bcftools mpileup \
  --threads 20 \
  -Ou \
  -f "$REF" \
  --min-MQ 20 \
  --min-BQ 30 \
  --platforms ILLUMINA \
  --annotate FORMAT/DP,FORMAT/AD \
  --bam-list "$BAMLIST" \
  -r "${SAMPLE}" | \
bcftools call \
  --threads 20 \
  -m \
  -v \
  -a GQ,GP \
  -Oz \
  -o "$OUT"
bcftools index $OUT

