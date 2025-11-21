rm(list=ls())
setwd("XXX")
# Ensure you have moved the plink output from HPC to working directory
# Load tidyverse package - collection of packages designed for data science
library(tidyverse)
### See https://speciationgenomics.github.io/pca/ for further information

# Read in data
# Use combination of functions
pca <- read_table2("./stick.eigenvec", col_names = FALSE)
eigenval <- scan("./stick.eigenval")

# Some cleaning up needed first
# Remove nuisance column
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
## Edit the species names and populations
head(pca$ind)
# Individual name includes the original path, get rid of this first

# Assuming your dataframe is called df and the column is "ind"
pca$ind <- gsub("/share/snailomics/raw/stick/bam/", "", pca$ind)
pca$ind <- gsub("\\.rmd\\.bam$", "", pca$ind)

head(spp)
# Create a vector for species (spp), fill with NA initially
spp <- rep(NA, length(pca$ind))
# Assign species names based on patterns
spp[grep("Cist", pca$ind)] <- "cist"
spp[grep("Obse", pca$ind)] <- "obse"
spp[grep("Obsm", pca$ind)] <- "obsm"
spp[grep("Scad", pca$ind)] <- "scad"
# Create a vector for locations (loc)
loc <- rep(NA, length(pca$ind))
loc[grep("Cist", pca$ind)] <- "lochcist"
loc[grep("Obs", pca$ind)] <- "lochobs"
loc[grep("Scad", pca$ind)] <- "lochscad"
print(loc)
# Combine species and location into one label
spp_loc <- paste0(spp, "_", loc)
print(spp_loc)
# Remake dataframe, using as.tibble for easy summaries
# remake data.frame
library(tibble)
pca <- as_tibble(data.frame(pca, spp, loc, spp_loc))

########################
# Plotting the data

# Convert to percentage variance explained
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)

# Make bar plot
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()

# Calculate the cumulative sum of the percentage variance explained
cumsum(pve$pve)
# First three axes explain about 30% of the variation

# Plot PCA

# plot pca
b <- ggplot(pca, aes(PC1, PC2, col = spp, shape = loc)) + geom_point(size = 3)
b <- b + scale_colour_manual(values = c("red", "blue", "green", "yellow"))
b <- b + coord_equal() + theme_light()
b + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
