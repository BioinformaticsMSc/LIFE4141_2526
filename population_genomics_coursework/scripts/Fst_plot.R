rm(list=ls())
setwd("XXX")
# Ensure you have moved the vcftools fst output from HPC to working directory

# Load libraries
library(ggplot2)
library(dplyr)

# Import the data (assuming tab-delimited file with header)
fst_data <- read.table("out.windowed.weir.fst", header = TRUE)

# Filter for chromosome chrI
# Just plot chrI
chrI_data <- fst_data %>% filter(CHROM == "chrI")

# Basic plot: position vs mean Fst
ggplot(chrI_data, aes(x = BIN_START, y = MEAN_FST)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  labs(title = "Fst across chrI",
       x = "Position",
       y = "Mean Fst") +
  theme_minimal()