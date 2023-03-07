#!/usr/bin/env Rscript
rm(list=ls())

# Load necessary libraries
#library(maps)
library(leaflet)

# function to set color of marker based on IBD
getColor <- function(geo_IBD_data) {
  sapply(geo_IBD_data[,3], function(x) {
    if(x <= 0.5) {
      "green"
    } else if(x <= 1) {
      "orange"
    } else {
      "red"
    } })
}
# Import geo and IBD data
geo <- read.csv('./1_Filtered_data/pop_geo.csv', row.names = 1)
IBD <- read.csv('./1_Filtered_data/filtered_inter.csv')

# Chose population 
input <- 'Swede'

# Extract data from chosen population
IBD_matcher <- IBD[IBD[,1] == input,2:3]
matching_geo <- na.omit(geo[IBD_matcher[,1],])

# Order population names
IBD_matcher <- IBD_matcher[order(IBD_matcher$pop2),]
matching_geo <- matching_geo[order(rownames(matching_geo)),]

IBD_matcher$pop2 == row.names(matching_geo)

geo_IBD_data <- cbind(matching_geo, IBD_matcher$mean_pairwise_IBD_length)



# Set icon style and color based on IBD value
icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(geo_IBD_data))


# Extract all geo locations from populations of interest
lines_data_frame <- data.frame()
for(i in 1:nrow(geo_IBD_data)){
  new_xy <- c(geo_IBD_data[i,1], geo_IBD_data[i,2])
  home_xy <- c(geo[input,]$lat, geo[input,]$long)
  lines_data_frame <- rbind(lines_data_frame, home_xy)
  lines_data_frame <- rbind(lines_data_frame, new_xy)
}

# Plot world map
m <- leaflet() %>% 
  addTiles() %>%
  
  # Add red circle to location of chosen population
  addCircleMarkers(lng = geo[input,]$long, 
                   lat = geo[input,]$lat,
                   color = 'red',
                   opacity = 0.7,
                   label = input
                   ) %>%
  # Add marker to all population related to chosen population
  addAwesomeMarkers(lng = geo_IBD_data$long, 
                    lat = geo_IBD_data$lat,
                    labelOptions = labelOptions(textsize = "12px",
                                                style = list("color" = 'darkgray')),
                    icon=icons,
                    
                    # Cluster markers close together
                    clusterOptions = markerClusterOptions(),
                    label = paste(rownames(geo_IBD_data),
                                  ':', 
                                  geo_IBD_data$`IBD_matcher$mean_pairwise_IBD_length`,
                                  'cM')) #%>%
  
  # Add line from chosen population to related populations
 #addPolylines(lat = lines_data_frame[,1],
  #             lng = lines_data_frame[,2])

m


