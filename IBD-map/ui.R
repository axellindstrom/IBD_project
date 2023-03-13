#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Known bugs: Some populations in the data set do not have any coordinates
# for example "Eritrean". However, the related populatins are still plotted to
# the map but the "home" destination is not displayed.
#

library(shiny)
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
source("../functions.R")
library(shinythemes)
#library(leaflet)

# Define UI for application that draws a histogram

fluidPage(fluidPage(div(class = 'sidebar',
                        tags$head(includeCSS("styles.css")),
                        navlistPanel(widths = c(10,5),'Sidebar Menu',
                                                         tabPanel(selectInput("Population", "Select population", c("Choose a population" = "", population_id))),
                                                         tabPanel(sliderInput("range",
                                                                     label = "Filter by IBD lenght:",
                                                                     min = 0, max = 100, value = c(0, 100)))),
                                                         
                                            
                                              tabsetPanel(div(class='side', tags$head(includeCSS("styles.css")),
                                                              navbarPage(title ='IBD patterns', 
                                                                         theme = shinytheme("flatly"),
                                                tabPanel("Map",
                                                         div(class="outer",
                                                             tags$head(includeCSS("styles.css")),
                                                             leafletOutput("mymap", height="66vh", width = '118vh'),
                                                             tableOutput('color_Table'),
                                                             textOutput('num_of_pop'))),
                                                tabPanel("Tables",
                                                         div(class="outer",
                                                             tags$head(includeCSS("styles.css")),
                                                         textOutput("quantiles_text"),
                                                         tableOutput("quantiles"),
                                                         
                                                         selectInput("Order_table", "Order by", colnames(filter_table(NULL))),
                                                         checkboxInput('descending', 'Descending', value = FALSE, width = NULL),
                                                         textOutput('selected_pop_size'),
                                                         tableOutput('Table')))))))
                                              ))




