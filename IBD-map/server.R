#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("../plot_map.R")
library(leaflet)
 
# Define server logic required to draw a histogram
function(input, output, session) {
  output$mymap <- renderLeaflet(plot_map_data(input$Population))
  
}
