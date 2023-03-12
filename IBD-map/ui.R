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
                                                                     min = 0, max = 100, value = c(0, 100))),
                                            mainPanel(
                                              tabsetPanel(
                                                tabPanel("Map", leafletOutput("mymap"),
                                                         tableOutput('color_Table'),
                                                         textOutput('num_of_pop')),
                                                tabPanel("Tables", 
                                                         textOutput("quantiles_text"),
                                                         tableOutput("quantiles"),
                                                         
                                                         selectInput("Order_table", "Order by", colnames(filter_table(NULL))),
                                                         checkboxInput('descending', 'Descending', value = FALSE, width = NULL),
                                                         textOutput('selected_pop_size'),
                                                         tableOutput('Table')),
                                              ))))))




