#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("../functions.R")
library(leaflet)

# Define server logic required to draw a histogram
function(input, output, session) {
  # Render empty map
  output$leaf=renderUI({
    leafletOutput('myMap', width = "10%", height = 1000)
  })
  output$mymap <- renderLeaflet(plot_map())
  
  # Render table
  output$quantiles <- renderTable({
    get_quantiles(input$Population)
    })
  output$selected_pop_size <- renderText({ 
    paste0('Number of individuals included in chosen population (',
           input$Population,
           '): ',
           geo_IBD_data[geo_IBD_data[,2] == input$Population, 5][1])
  })
  output$quantiles_text <- renderText({
    'Quantiles'
    
  })
  event_trigger <- reactive({
    list(input$range, input$Population)
  })
  observeEvent(ignoreInit = TRUE, event_trigger(),{
    if (input$Population %in% geo_IBD_data[,1]){
    update_map(input)}
    })
  output$Table <- renderTable(filter_table(input, input$descending))
  
  observeEvent(ignoreInit = TRUE, input$Population, {
    if (input$Population %in% geo_IBD_data[,1]){
      max_val <- ceiling(max(geo_IBD_data[geo_IBD_data[,1]==input$Population,3]))
      updateSliderInput(session, 
                        "range", 
                        value = NULL,
                        min = 0, 
                        max = max_val, 
                        step = tick_step(max_val))
    }
    
  })
  
}



