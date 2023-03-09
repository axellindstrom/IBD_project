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
  # Render empty map
  output$mymap <- renderLeaflet(plot_map())
  
  # Render table
  output$quantiles <- renderTable({
    get_quantiles(input$Population)
    })
  output$selected_pop_range <- renderText({ 
    paste("You have selected", input$pop_range)
  })
  output$Quantiles <- renderText({
    'Quantiles'
  })
  event_trigger <- reactive({
    list(input$range, input$Population)
  })
  observeEvent(ignoreInit = TRUE, event_trigger(),{
    update_map(input)
  })
}



