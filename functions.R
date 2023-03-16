#!/usr/bin/env Rscript'

# Description: This script contains all functions used in the Shiny app 
# Author: Axel Lindström
# Date: 2023-03-14
# Version: 1.0

# rm(list=ls())

# Assign a color based on which quantile it belongs to
get_color <- function(filtered_pop, all_pop) {
  quant <- quantile(all_pop$mean_pairwise_IBD_length)
  sapply(filtered_pop[,3], function(x) {
    if(x <= quant[2]) {
      "blue"
    } else if(x <= quant[3]) {
      "green"
    } else  if (x <= quant[4]){
      "orange"
    } else  if (x > quant[4]){
      "red"
    }})
}


# Render an empty map
plot_map <- function(){
  # Plot world map
  m <- leaflet() %>% 
    addTiles() %>%
    setView(lng=13.191128010559968, lat=55.705926544548944, zoom=2)
    return(m)
}


# Updates map with markers based on user input
update_map <- function(input){
  input_pop1 <- geo_IBD_data[geo_IBD_data[,1] == input$Population, ]
  input_pop <- input_pop1[input_pop1[,3] >= input$range[1], ]
  input_pop <- input_pop[input_pop[,3] <= input$range[2], ]
 
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = get_color(input_pop, input_pop1))
  
  prox <- leafletProxy("mymap") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    clearShapes() 
  
  if (nrow(input_pop) > 0){
    line_coordinates <- data.frame()
    for (pop in input_pop[,2]){
      # Get coordinates for selected population
      home_coordinates <- geo_IBD_data[geo_IBD_data[,2] == input$Population, ][1,c(3,7,8)]
      line_coordinates <- rbind(line_coordinates, home_coordinates)
      # Get coordinates for each population linked to selected population
      pop2 <- input_pop[input_pop[,2] == pop, ][1,c(3,7,8)]
      line_coordinates <- rbind(line_coordinates,pop2)
    }
    for (num in seq(2,nrow(line_coordinates),by=2)){
      prox %>% addPolylines(lng = line_coordinates[(num-1):num,3], 
                            lat = line_coordinates[(num-1):num,2], 
                            weight = get_weight(line_coordinates[num,1],input_pop1),
                            color = 'darkgrey')
    }
    prox %>% addMarkers(lng = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$long, 
                              lat = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$lat,
                              label = input$Population)
    prox %>%
      addCircleMarkers(lng = input_pop$long, 
                       lat = input_pop$lat,
                       labelOptions = labelOptions(textsize = "12px",
                                                   style = list("color" = 'darkgray')),
                       #icon=icons,
                       color = get_color(input_pop, input_pop1),
                       # Cluster markers close together
                       # clusterOptions = markerClusterOptions(),
                       label = paste(input_pop[,2],
                                     ':', 
                                     input_pop$mean_pairwise_IBD_length,
                                     'cM')) 
    
  }else{
    prox %>% addCircleMarkers(lng = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$long, 
                              lat = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$lat,
                              color = 'red',
                              opacity = 0.7,
                              label = input$Population)
  }
    }


get_weight <- function(line_coordinates, all_pop ) {
  quant <- quantile(all_pop$mean_pairwise_IBD_length)
  weight <- as.numeric(line_coordinates)
    if(weight <= quant[2]) {
      return(1)
    } else if(weight <= quant[3]) {
      return(10)
    } else  if (weight <= quant[4]){
      return(20)
    } else  if (weight > quant[4]){
      return(30)
    }
}


# Calculate the percentlie cut offs based on IBD length
get_quantiles <- function(input_population){ 
  input_pop <- geo_IBD_data[geo_IBD_data[,1] == input_population,]
  quant <- data.frame(col1 = numeric(),col2 = numeric(),col3 = numeric(),col4 = numeric(),col5 = numeric())
  quant_values <- t(as.data.frame(quantile(input_pop$mean_pairwise_IBD_length)))
  if (NA %in% quant_values){
    colnames(quant) <- colnames(quant_values)
    return(quant[,2:5])
  }else{
    colnames(quant) <- colnames(quant_values)
    quant_values <- rbind(quant,quant_values)
    return(quant_values[,2:5])
  }

}


# Get all related populations in a data frame and filter based on IBD value
filter_table <- function(input, order_Data = FALSE, geo_IBD_data){
  if (class(order_Data) == 'logical'){
    order_Data <- order_Data}
  
  # Extract all data linked to chosen population and apply filter
  input_pop <- geo_IBD_data[geo_IBD_data[,1] == input$Population, ] %>%
    .[.[,3] >= input$range[1], ] %>%
    .[.[,3] <= input$range[2], c(2,3,5,6,9,10)]
  
  # Change column names
  colnames(input_pop) <- c('Population', 'Mean pairwise IBD length', 'Pop size', 'IBD length SE', 'Continent', 'Country')
  
  # Order data based on users choice
  input_pop[order(input_pop[,input$Order_table], decreasing = order_Data),]
  
}


# Change the the tick step of the slider depending on the range of IBD
tick_step <- function(x){
  if (x>5){
    return(1)
  }else{
    return(0.5)
  }
}


check_requirments <- function(parent_d){
  # Vector containing all the packages used in for the app to run
  list.of.packages <- c("shiny", 
                        "leaflet", 
                        "tidyverse", 
                        "shinythemes",
                        "readxl")
  
  
  # Check if all the packages are installed
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  
  
  # If required package not installed, install the missing packages
  if(length(new.packages)) install.packages(new.packages)
  
  
  # Load in all the required packages
  for(pkg in list.of.packages){
    eval(bquote(library(.(pkg))))
  }
  
  
  
  
  
  
  # Store names of required directories
  required_dir <- c('/Raw_data', '/1_Filtered_data')
  
  # Check if the directory containing the raw data exist
  if (!dir.exists(paste0(parent_d,required_dir[1]))){
    
    # If directory do not exist stop the app and print error message
    stop('Missing data \n Expected dataset in "Raw_data": no such directory exist.')
  }
  
  
  # Check if directory 1_Filtered_data exist
  if (!dir.exists(paste0(parent_d,required_dir[2]))){
    # If directory do not exist print warning
    warning(paste(paste0(parent_d,required_dir[2]), 'do not exist.','\n','Directory created'))
    # Create directory 1_Filtered_data
    dir.create(paste0(parent_d,required_dir[2]))
  }
  
  
  # Check if the required data in the required directory exist
  if (!file.exists(paste0(parent_d, required_dir[2],'/geo_IBD_data3.csv'))){
    # If if data do not exist print warning
    warning('Expected dataset in "1_Filtered_data: no such directory exist. \n Creating datasets')
    
    # Load in required function to create required data
    source(paste0(parent_d,'/clean_data.R'))
    
    # Run function to merge datsets into required dataset
    merge_data(parent_d, required_dir[2])
    

  }
}

