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
      tabPanel("Map", leafletOutput("mymap"),
               sidebarLayout(position = "right",
                             sidebarPanel('',
                                          sliderInput("range",
                                                      label = "Filter by IBD lenght:",
                                                      min = 0, max = 100, value = c(0, 100))),
                             mainPanel("main panel",
                                       selectInput("Population", "Select population", c("Choose a population" = "", population_id))))), 
      tabPanel("Summary", 
               textOutput("Quantiles"),
               tableOutput("quantiles"),
               selectInput("Population", "Select population", c("Choose a population" = "", population_id))), 
      tabPanel("Table", textOutput("selected_pop_range"),
               sidebarLayout(position = "left",
                             sidebarPanel("sidebar panel",
                                          selectInput("Population", "Select population", c("Choose a population" = "", population_id)),
                                          sliderInput("pop_range", 
                                                      label = "Filter by IBD lenght:",
                                                      min = 0, max = 100, value = c(0, 100))),
                             mainPanel("main panel"))),
      tabPanel('test', textOutput('selected_var'))
    )),

  
)
