#!/usr/bin/env Rscript

# Read and merge the annotation dataset with the IBD dataset
merge_data <- function(path, destination_d){
  
  # Import inter IBD data
  inter <- read.csv2(paste0(path,'/Raw_Data/inter_pop_mean_pairwise_ibd_length.csv'), sep = ',')
  
  # Remove population with no geo-data
  inter <- inter[inter[,1] != 'mixed-AJ',]
  inter <- inter[inter[,2] != 'mixed-AJ',]
  
  # Import annotation of IBD data
  suppressWarnings(annotation <- as.data.frame(read_excel(paste0(path,'/Raw_data/IBD annotation.xlsx'))))
  #annotation <- annotation[annotation[,1] != 'mixed-AJ'||'Eritrean',] 
  
  
  populations <- unique(c(inter[,1],inter[,2]))
  # Extract all unique names of populations
  #populations <- as.data.frame(unique(annotation$fid))
  
  # Create empty data frame to store geographical data for each population in
  geolocation <- data.frame()
  
  # Extract geo data from annotation and append it to the geolocation data frame
  # If there is more than one instance of geo data, an average will be calculated
  # Note! I have no knowledge of the populations historical background and origins 
  # Taking an average might place some populations in areas where they never been. 
  for (pop in populations){
    if (pop %in% annotation[,1]){
      lat = round(sum(annotation[annotation[,1] == pop,2])/length(annotation[annotation[,1] == pop,1]),2)
      long = round(sum(annotation[annotation[,1] == pop,3])/length(annotation[annotation[,1] == pop,3]),2)
      continent_country <- annotation[annotation[,1] == pop,6:7][1,]
      pop_geo <- c(pop, lat, long, continent_country$continent, continent_country$country)
      geolocation <- rbind(geolocation,pop_geo)
    }else{
      next
    }
  }
  
  # Change col names to match column names in inter data set
  colnames(geolocation) <- c('pop2','lat','long', 'continent','country')
  
  # Merge inter and geo data, geo data relates to pop2
  geo_IBD_data <- inter[,1:6] %>% left_join(geolocation, by = 'pop2')
  write_csv(geo_IBD_data, paste0(path, destination_d, '/geo_IBD_data.csv'))
}





