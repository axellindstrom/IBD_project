#!/usr/bin/env Rscript
#rm(list=ls())

# Load necessary libraries
#library(leaflet)

# Function takes a population name as an input and returns a map with related populations
plot_map_data <- function(input_population){

  input_pop <- geo_IBD_data[geo_IBD_data[,1] == input_population,]
  # Set icon style and color based on IBD value
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = getColor(input_pop))
  
  # Plot world map
  m <- leaflet() %>% 
    addTiles() %>%
    
    # Add red circle to location of chosen population
    addCircleMarkers(lng = geo_IBD_data[geo_IBD_data[,2] == input_population,][1,]$long, 
                     lat = geo_IBD_data[geo_IBD_data[,2] == input_population,][1,]$lat,
                     color = 'red',
                     opacity = 0.7,
                     label = input_population
    ) %>%
    # Add marker to all population related to chosen population
    addAwesomeMarkers(lng = input_pop$long, 
                      lat = input_pop$lat,
                      labelOptions = labelOptions(textsize = "12px",
                                                  style = list("color" = 'darkgray')),
                      icon=icons,
                      
                      # Cluster markers close together
                      clusterOptions = markerClusterOptions(),
                      label = paste(input_pop[,2],
                                    ':', 
                                    input_pop$mean_pairwise_IBD_length,
                                    'cM')) #%>%
  
  # Add line from chosen population to related populations
  #addPolylines(lat = lines_data_frame[,1],
  #             lng = lines_data_frame[,2])
  
  #return(m)
}


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
geo_IBD_data <- read.csv('../1_Filtered_data/geo_IBD_data.csv')

# Chose population 
#input <- 'Swede'


#m <- plot_map_data(input)
#m
population_id <- geo_IBD_data[order(geo_IBD_data$pop1),1]


