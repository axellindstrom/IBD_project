#!/usr/bin/env Rscript
rm(list=ls())

# Load necessary libraries
#library(leaflet)

# Assign a color based on which quantile it belongs to
getColor <- function(filtered_pop, all_pop) {
  quant <- quantile(all_pop$mean_pairwise_IBD_length)
  sapply(filtered_pop[,3], function(x) {
    if(x <= quant[1]) {
      "white"
    } else if(x <= quant[2]) {
      "lightblue"
    } else  if (x <= quant[3]){
      "green"
    } else  if (x <= quant[4]){
      "orange"
    } else{
      "red"
    }})
}


# Render an empty map
plot_map <- function(){
  # Plot world map
  m <- leaflet() %>% 
    addTiles() %>%
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
    markerColor = getColor(input_pop, input_pop1))
  
  leafletProxy("mymap") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    
    addAwesomeMarkers(lng = input_pop$long, 
                      lat = input_pop$lat,
                      labelOptions = labelOptions(textsize = "12px",
                                                  style = list("color" = 'darkgray')),
                      icon=icons,
                      
                      # Cluster markers close together
                     # clusterOptions = markerClusterOptions(),
                      label = paste(input_pop[,2],
                                    ':', 
                                    input_pop$mean_pairwise_IBD_length,
                                    'cM')) %>%
    addCircleMarkers(lng = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$long, 
                     lat = geo_IBD_data[geo_IBD_data[,2] == input$Population,][1,]$lat,
                     color = 'red',
                     opacity = 0.7,
                     label = input$Population)
  
}


# Calculate the percentlie cut offs based on IBD length
get_quantiles <- function(input_population){ 
  input_pop <- geo_IBD_data[geo_IBD_data[,1] == input_population,]
  quant_values <- t(as.data.frame(quantile(input_pop$mean_pairwise_IBD_length)))
  if (NA %in% quant_values){
    quant <- data.frame(col1 = numeric(),col2 = numeric(),col3 = numeric(),col4 = numeric(),col5 = numeric())
    colnames(quant) <- colnames(quant_values)
    return(quant)
  }else{
    return(quant_values)
  }

}


# Get all related populations in a data frame and filter based on IBD value
filter_table <- function(input, order_Data = FALSE){
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




# Import geo and IBD data
geo_IBD_data <- read.csv('../1_Filtered_data/geo_IBD_data2.csv')

# List of populations to be used as a drop down menu in app
population_id <- geo_IBD_data[order(geo_IBD_data$pop1),1]


