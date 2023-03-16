#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#




# Define server logic required to draw a histogram
function(input, output, session) {
  
  # Render an empty map
  output$mymap <- renderLeaflet(plot_map())
  
  # Render table of the quantiles
  output$quantiles <- renderTable({
    get_quantiles(input$Population)
    })
  
  # Print information of the populations size of the selected population
  output$selected_pop_size <- renderText({ 
    paste0('Number of individuals included in chosen population (',
           input$Population,
           '): ',
           geo_IBD_data[geo_IBD_data[,2] == input$Population, 5][1])
  })
  
  # Track updates of the slider and drop down menue in the side menu
  event_trigger <- reactive({
    list(input$range, input$Population)
  })
  
  # If selected population or IBD length range change update map
  observeEvent(ignoreInit = TRUE, event_trigger(),{
    if (input$Population %in% geo_IBD_data[,1]){
    update_map(input)}
    })
  
  # Render a table of information about related populations
  output$Table <- renderTable(width = '80%', {
    pop_table <- filter_table(input, input$descending)
    pop_table})
  
  # Add explanation of color on the map
  output$bluecolor <- renderText({
    color_table <- get_quantiles(input$Population)
    colror_range_max <- round(color_table[,1], 2)
    paste('<', colror_range_max)
    })
  
  output$greencolor <- renderText({
    color_table <- get_quantiles(input$Population)
    color_range_min <- round(color_table[,1], 2)
    colror_range_max <- round(color_table[,2], 2)
    paste(color_range_min, '-', colror_range_max)
  })
  
  output$orangecolor <- renderText({
    color_table <- get_quantiles(input$Population)
    color_range_min <- round(color_table[,2], 2)
    colror_range_max <- round(color_table[,3], 2)
    paste(color_range_min, '-', colror_range_max)
  })
  
  output$redcolor <- renderText({
    color_table <- get_quantiles(input$Population)
    color_range_min <- round(color_table[,3], 2)
    paste('>', color_range_min)
  })
  
  # Update slider range depending on the minimum and maximum IBD length 
  # among all the related populations.
  # Only updates when a new population is selected
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



