#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("../plot_map.R")
library(leaflet)
# Define UI for application that draws a histogram
fluidPage(
  mainPanel(
    titlePanel("IBD distance"),
    tabsetPanel(
      tabPanel("Map", leafletOutput("mymap")), 
      tabPanel("Summary", 
               textOutput("Quantiles"),
               tableOutput("quantiles")), 
      tabPanel("Table", tableOutput("table")),
      tabPanel('test', textOutput('selected_var'))
    )),
    
  #leafletOutput("mymap"),
  selectInput("Population", "Select population", c("Choose a population" = "", population_id)),
  sliderInput("range", 
              label = "Filter by IBD lenght:",
              min = 0, max = 100, value = c(0, 100))
)
