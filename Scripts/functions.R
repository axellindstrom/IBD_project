#!/usr/bin/env Rscript'

# Description: This script contains all functions used in the Shiny app 
# Author: Axel Lindström
# Date: 2023-03-14
# Version: 1.0



# Assign a color based on which quantile it belongs to
get_color <- function(filtered_pop, all_pop) {
  # Get quantiles based on the IBD length
  quant <- quantile(all_pop$mean_pairwise_IBD_length)
  # Assign a color to each population based on which quantile they belong to
  sapply(filtered_pop[,3], function(x) {
    if(x < quant[2]) {
      "blue"
    } else if(x < quant[3]) {
      "green"
    } else  if (x < quant[4]){
      "orange"
    } else  if (x >= quant[4]){
      "red"
    }})
}


# Render an empty map
plot_map <- function(){
  # Plot world map
  m <- leaflet() %>% 
    addTiles() %>%
    # Set initial view to Lund, Sweden at a zoom level= 2
    setView(lng=13.191128010559968, lat=55.705926544548944, zoom=2)
  
  # Return the leaflet object   
  return(m)
}


# Updates map with markers based on user input
update_map <- function(input){
  # Extract all related populations to the chosen population (input$Population)
  input_pop1 <- geo_IBD_data[geo_IBD_data[,1] == input$Population, ]
  
  # Only extract populations that fall in the IBD length range the user 
  # has defined
  input_pop <- input_pop1[input_pop1[,3] >= input$range[1], ]
  input_pop <- input_pop[input_pop[,3] <= input$range[2], ]
  
  # Update map with filtered data
  prox <- leafletProxy("mymap") %>%
    clearMarkers() %>%  # Clear all markers from map
    clearShapes()   # Clear all shapes from map (Necessary for removing lines)
  
  # Making sure there are populations to plot
  if (nrow(input_pop) > 0){
    
    # Define empty dataframe to store the coordinates for all related 
    # populations in 
    line_coordinates <- data.frame()
    
    # Extract coordinates for selected population and all related populations
    for (pop in input_pop[,2]){
      # Get coordinates for selected population
      home_coordinates <- geo_IBD_data[geo_IBD_data[,2] == input$Population, ][1,c(3,7,8)]
      
      # Add coordinates for selected population to line_coordinates for each
      # related population. Starting point for each line plotted to the map
      line_coordinates <- rbind(line_coordinates, home_coordinates)
      
      # Get coordinates for each population linked to selected population
      pop2 <- input_pop[input_pop[,2] == pop, ][1,c(3,7,8)]
      
      # Add coordinates for each related population. End point for each line 
      # plotted to the map
      line_coordinates <- rbind(line_coordinates,pop2)
    }
    
    # For every pair of start- and end-point add line to map
    for (num in seq(2,nrow(line_coordinates),by=2)){
      # addPolylines() uses the start and end-points to draw a line between 2 
      # points
      prox %>% addPolylines(lng = line_coordinates[(num-1):num,3], 
                            lat = line_coordinates[(num-1):num,2], 
                            
                            # The thickness of the lines are set using the 
                            # quantiles as cut offs
                            weight = get_weight(line_coordinates[num,1],input_pop1),
                            color = 'darkgrey')
    }
    
    # Add a marker to the map on the coordinates of the selected population
    prox %>% addMarkers(lng = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$long, 
                              lat = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$lat,
                              label = input$Population)
    
    # Add circles to the coordinates of the related populations
    prox %>%
      addCircleMarkers(lng = input_pop$long, 
                       lat = input_pop$lat,
                       labelOptions = labelOptions(textsize = "12px",
                                                   style = list("color" = 'darkgray')),
                       
                       # The color of the circles are set using the 
                       # quantiles as cut offs
                       color = get_color(input_pop, input_pop1),
                       
                       # Add a label that will be visible when hovering over 
                       # the circles
                       label = paste(input_pop[,2],
                                     ':', 
                                     input_pop$mean_pairwise_IBD_length,
                                     'cM')) 
    
  }
  # If  there are no related populations to plot, just add a marker to the 
  # coordinates of the selected population
  else{
    prox %>% addMarkers(lng = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$long, 
                        lat = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$lat,
                        label = input$Population)
  }
    }


# Assign a weight used to specify the thickness of the line plotted tot the map
get_weight <- function(line_coordinates, all_pop ) {
  # Get quantiles based on the IBD length
  quant <- quantile(all_pop$mean_pairwise_IBD_length)
  # Assign a weight based on which quantile they belong to
  weight <- as.numeric(line_coordinates)
    if(weight < quant[2]) {
      return(1)
    } else if(weight < quant[3]) {
      return(10)
    } else  if (weight < quant[4]){
      return(20)
    } else  if (weight >= quant[4]){
      return(30)
    }
}


# Calculate the quantile cut offs based on IBD length
get_quantiles <- function(input_population){ 
  
  # Extract all populations related to the selected population
  input_pop <- geo_IBD_data[geo_IBD_data[,1] == input_population,]
  
  # Define an empty dataframe to store quantile cut offs in
  quant <- data.frame(col1 = numeric(),
                      col2 = numeric(),
                      col3 = numeric(),
                      col4 = numeric(),
                      col5 = numeric())
  
  # Calculate the quantile cut offs based on the IBD length among all 
  # populations related  to the selected population in the dataset
  quant_values <- t(as.data.frame(quantile(input_pop$mean_pairwise_IBD_length)))
  
  # If no populations has been selected an empty dataframe will be returned
  # the column names will be printed in the app
  if (NA %in% quant_values){
    colnames(quant) <- colnames(quant_values)
    return(quant[,2:5])
  }
  
  # If quantiles have been calculated they will be returned as a dataframe
  else{
    # Set the names of the columns
    colnames(quant) <- colnames(quant_values)
    # Get values of quantiles intop the dataframe
    quant_values <- rbind(quant,quant_values)
    return(quant_values[,2:5])
  }

}


# Get all related populations in a data frame and filter based on IBD value
filter_table <- function(input, order_Data = FALSE){
  # Check that order_Data is a boolean. (This logic statement is needed since
  # on startup order_Data take on a different class for unknown reasons)
  if (class(order_Data) == 'logical'){
    order_Data <- order_Data}
  
  # Extract all data linked to chosen population and apply filter
  input_pop <- geo_IBD_data[geo_IBD_data[,1] == input$Population, ] %>%
    .[.[,3] >= input$range[1], ] %>%
    .[.[,3] <= input$range[2], c(2,3,5,6,9,10)]
  
  # Change column names
  colnames(input_pop) <- c('Population', 
                           'Mean pairwise IBD length', 
                           'Pop size', 
                           'IBD length SE', 
                           'Continent', 
                           'Country')
  
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






# Import geo and IBD data. This line would be better to have in the ui or 
# server script. However, if moved to the ui or server script 
# geo_IBD_data is unable to be loaded.
geo_IBD_data <- read.csv('../1_Filtered_data/geo_IBD_data.csv')






