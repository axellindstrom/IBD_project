#!/usr/bin/env Rscript
rm(list=ls())

# Load necessary libraries
library(maps)
library('leaflet')

# Import geo data
geo <- read.csv('./Geo_data/pop_geo.csv', row.names = 1)


geo['Moldova-AJ',]


# Plot empty world map
par(mar=c(0,0,0,0))
maps::map('',
          col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05,
          mar=rep(0,4),border=0, ylim=c(-80,80) 
)

draw_pop_location <- function(pop_name){
  points(x=geo[pop_name,]$long, y=geo[pop_name,]$lat, col="red", cex=3, pch=20)
  
}

draw_pop_location('Moldova-AJ')



input <- 'Moldova-AJ'

matcher <- c('Hungary-AJ', 'Russia-AJ')

# Same stuff but using the %>% operator
m <- leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(lng = geo[input,]$long, 
                   lat = geo[input,]$lat,
                   color = 'red',
                   opacity = 0.7,
                   label = input
                   ) %>%
  addCircleMarkers(lng = geo[matcher,]$long, 
                   lat = geo[matcher,]$lat,
                   color = 'blue',
                   opacity = 0.7,
                   label = matcher) #%>%

for(i in 1:nrow(geo[matcher,])){
  xy_lines <- c(geo[input,]$lat, geo[input,]$long, geo[matcher,][i,1], geo[matcher,][i,2])

  m <- addPolylines(m, lat = as.numeric(xy_lines[c(1, 3)]), 
                       lng = as.numeric(xy_lines[c(2, 4)]))
}
m

