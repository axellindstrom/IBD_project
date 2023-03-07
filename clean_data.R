#!/usr/bin/env Rscript

rm(list=ls())
# Load necessary libraries
library(tidyverse)
library(readxl)

# Import intra IBD data
intra <- read.csv2('./Raw_Data/intra_pop_mean_pairwise_ibd_length.csv', sep = ',')

# Import inter IBD data
inter <- read.csv2('./Raw_Data/inter_pop_mean_pairwise_ibd_length.csv', sep = ',')

# Import annotation of IBD data
suppressWarnings(annotation <- as.data.frame(read_excel('./Raw_data/IBD annotation.xlsx')))

# Extract all unique names of populations
populations <- as.data.frame(unique(annotation$fid))

# Create empty data frame to store geographical data for each population in
geolocation <- data.frame()

# Extract geo data from annotation and append it to the geolocation data frame
# If there is more than one instance of geo data, an average will be calculated
# Note! I have no knowledge of the populations historical background and origins 
# Taking an average might place some populations in areas where they never been. 
for (pop in populations[,1]){
  lat = round(sum(annotation[annotation[,1] == pop,2])/length(annotation[annotation[,1] == pop,1]),2)
  long = round(sum(annotation[annotation[,1] == pop,3])/length(annotation[annotation[,1] == pop,3]),2)
  pop_geo <- c(pop, lat, long)
  geolocation <- rbind(geolocation,pop_geo)
}

# Rename the columns in the geo data frame
colnames(geolocation) <- c('pop1', 'lat','long')

# Remove NAs from the data
geolocation <- na.omit(geolocation)


# Write IBD data and location data to a csv
write_csv(geolocation, './Geo_data/pop_geo.csv')



