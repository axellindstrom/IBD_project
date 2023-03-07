#!/usr/bin/env Rscript
rm(list=ls())

# Load necessary libraries
#library(maps)
library(leaflet)


# Import geo data
geo <- read.csv('./Geo_data/pop_geo.csv', row.names = 1)
IBD <- read.csv('./Raw_Data/inter_pop_mean_pairwise_ibd_length.csv')


# Plot empty world map
#par(mar=c(0,0,0,0))
#maps::map('',
#          col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05,
#          mar=rep(0,4),border=0, ylim=c(-80,80) 
#)

#draw_pop_location <- function(pop_name){
#  points(x=geo[pop_name,]$long, y=geo[pop_name,]$lat, col="red", cex=3, pch=20)
  
#}

#draw_pop_location('Moldova-AJ')



input <- 'Swede'

matcher <- IBD[IBD[,1] == input,2:3]

# Same stuff but using the %>% operator
m <- leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(lng = geo[input,]$long, 
                   lat = geo[input,]$lat,
                   color = 'red',
                   opacity = 0.7,
                   label = input
                   )# %>%
  #addCircleMarkers(lng = geo[matcher[,1],]$long, 
   #                lat = geo[matcher[,1],]$lat,
    #               color = 'blue',
     #              opacity = 0.7,
      #             label = matcher)


for (i in 1:nrow(geo[matcher[,1],])){
  lable_lenght <- matcher[i, 1:2]
  m <- addCircleMarkers(m, lng = geo[matcher[i,1],]$long, 
                   lat = geo[matcher[i,1],]$lat,
                   color = 'blue',
                   opacity = 0.7,
                   label = paste(lable_lenght[,1],':', lable_lenght[2], 'cM'),
                   labelOptions = labelOptions(textsize = "12px",
                                               style = list("color" = 'darkgray')),
                   clusterOptions = T )
} 




for(i in 1:nrow(geo[matcher[,1],])){
  xy_lines <- c(geo[input,]$lat, geo[input,]$long, geo[matcher[,1],][i,1], geo[matcher[,1],][i,2])

  m <- addPolylines(m, lat = as.numeric(xy_lines[c(1, 3)]), 
                       lng = as.numeric(xy_lines[c(2, 4)]))
}
m


