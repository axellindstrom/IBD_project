#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Known bugs: Some populations in the data set do not have any coordinates
# for example "Eritrean". However, the related populations in the dataset are 
# still plotted to the map but the selected population is not displayed.
#



# Set working directory to directory current script is located in
parent_d <- dirname(getwd())

# Vector containing all the packages used in for the app to run
list.of.packages <- c("shiny", 
                      "leaflet", 
                      "tidyverse", 
                      "shinythemes",
                      "readxl")


# Check if all the packages are installed
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]


# If required package not installed, install the missing packages
if(length(new.packages)) install.packages(new.packages)


# Load in all the required packages
for(pkg in list.of.packages){
  eval(bquote(library(.(pkg))))
}






# Store names of required directories
required_dir <- c('/Raw_data', '/1_Filtered_data')

# Check if the directory containing the raw data exist
if (!dir.exists(paste0(parent_d,required_dir[1])) || !file.exists(paste0(parent_d,required_dir[1],'/inter_pop_mean_pairwise_ibd_length.csv'))){
  
  # If directory do not exist stop the app and print error message
  stop('Missing data \n Expected dataset in "Raw_data": directory do not contain required dataset or no such directory exist.')
}


# Check if directory 1_Filtered_data exist
if (!dir.exists(paste0(parent_d,required_dir[2]))){
  # If directory do not exist print warning
  warning(paste(paste0(parent_d,required_dir[2]), 'do not exist.','\n','Directory created'))
  # Create directory 1_Filtered_data
  dir.create(paste0(parent_d,required_dir[2]))
}


# Check if the required data in the required directory exist
if (!file.exists(paste0(parent_d, required_dir[2],'/geo_IBD_data.csv'))){
  # If if data do not exist print warning
  warning('Expected dataset in "1_Filtered_data: no such directory exist. \n Creating datasets')
  
  # Load in required function to create required data
  source(paste0(parent_d,'/Scripts/clean_data.R'))
  
  # Run function to merge datsets into required dataset
  merge_data(parent_d, required_dir[2])
  
  
}



# Load in all the functions to be used
source(paste0(parent_d,"/Scripts/functions.R"))






# List of populations to be used as a drop down menu in app
population_id <- geo_IBD_data[order(geo_IBD_data$pop1),1]






# Define UI for application 
fluidPage(
  # Define a sidebar to be used as a side menu
  fluidPage(div(class = 'sidebar',
                        tags$head(includeCSS("styles.css")),
                
                # Create a nave list to store the side menu filters in        
                navlistPanel(widths = c(10,5),'Sidebar Menu',
                             
                             # Create a section of the side menu with a drop down menu
                             # with all populations to chose from
                             tabPanel(selectInput("Population",
                                                  "Select population",
                                                  c("Choose a population" = "", population_id))),
                             
                             # Add slider to let user filter the populations 
                             # based on IBD length
                             tabPanel(sliderInput("range",
                                                  label = "Filter by IBD lenght:",
                                                  min = 0,
                                                  max = 100,
                                                  value = c(0, 100)))),
                        
                # Add tabs and title      
                tabsetPanel(div(class='side', 
                                        tags$head(includeCSS("styles.css")),
                                
                                # Add title and theme to the tabs        
                                navbarPage(title ='IBD patterns',
                                           theme = shinytheme("flatly"),
                                           
                                           # Add a main tab called "Map"
                                           tabPanel('Map',
                                                    # Set bounds for the map
                                                    div(class="outer",
                                                        tags$head(includeCSS("styles.css")),
                                                        leafletOutput("mymap", height="66vh", width = '118vh'),
                                                        
                                                        # Add colored icons and values tunder map
                                                        div(style="display: inline-block;vertical-align:top; width: 150px;",h4(tags$style(".circle1 {color:#2243E8}"),
                                                             icon("circle", class = 'circle1'), textOutput('bluecolor'))),
                                                            div(style="display: inline-block;vertical-align:top; width: 150px;",h4(tags$style(".circle2 {color:#177D14}"),
                                                             icon("circle", class = 'circle2'),
                                                             textOutput('greencolor'))),
                                                            p(),
                                                            div(style="display: inline-block;vertical-align:top; width: 150px;",h4(tags$style(".circle3 {color:#E8a922}"),
                                                             icon("circle", class = 'circle3'),
                                                             textOutput('orangecolor'))),
                                                            div(style="display: inline-block;vertical-align:top; width: 150px;",h4(tags$style(".circle4 {color:#E82222}"),
                                                             icon("circle", class = 'circle4'),
                                                             textOutput('redcolor')))
                                                            )),
                                           
                                           # Add second main tab called "Tables"     
                                           tabPanel("Tables",
                                                    div(class="outer",
                                                        tags$head(includeCSS("styles.css")),
                                                        
                                                        # Add title to quantile table
                                                        h3('Quantiles'),
                                                        
                                                        # Add quantile table
                                                        tableOutput("quantiles"),
                                                        
                                                        # Add drop down menu to select how to order data
                                                        selectInput("Order_table", "Order by", colnames(filter_table(NULL))),
                                                        
                                                        # Add checkbox to select how to order data in table
                                                        checkboxInput('descending', 'Descending', value = FALSE, width = NULL),
                                                        
                                                        # Add text about number of individuals in selected population
                                                        textOutput('selected_pop_size'),
                                                        
                                                        # Add table of related populations
                                                        tableOutput('Table')))))))
                                              ))




