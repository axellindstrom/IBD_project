#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("../functions.R")
library(leaflet)

# Define UI for application that draws a histogram
fluidPage(titlePanel('IBD patterns'),
          fluidPage(mainPanel(sidebarLayout(position = "left",
                                            sidebarPanel('',
                                                         selectInput("Population", "Select population", c("Choose a population" = "", population_id)),
                                                         sliderInput("range",
                                                                     label = "Filter by IBD lenght:",
                                                                     min = 0, max = 100, value = c(0, 100)),
                                                         selectInput("Order_table", "Order by", colnames(filter_table(NULL)))),
                                            mainPanel(
                                              tabsetPanel(
                                                tabPanel("Map", leafletOutput("mymap")),
                                                tabPanel("Tables", 
                                                         textOutput("quantiles_text"),
                                                         tableOutput("quantiles"),
                                                         textOutput('selected_pop_size'),
                                                         tableOutput('Table')),
                                              ))))))




