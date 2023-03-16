
rm(list=ls())


setwd(dirname(rstudioapi::getSourceEditorContext()$path))
required_dir <- c('/Raw_data', '/1_Filtered_data')

parent_d <- dirname(dirname(rstudioapi::getSourceEditorContext()$path))
print(getwd())

if (!dir.exists(paste0(parent_d,required_dir[1]))){
  stop('Missing data \n Expected dataset in "Raw_data": no such directory exist.')
}

if (!dir.exists(paste0(parent_d,required_dir[2]))){
    warning(paste(paste0(parent_d,required_dir[2]), 'do not exist.','\n','Directory created'))
    dir.create(paste0(parent_d,required_dir[2]))
}

if (!file.exists(paste0(parent_d, required_dir[2],'/geo_IBD_data.csv'))){
  warning('Expected dataset in "1_Filtered_data: no such directory exist. \n Creating datasets')
  source(paste0(parent_d,'/clean_data.R'))
  merge_data(parent_d, required_dir[2])
}

















# Set working directory to directory current script is located in
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
parent_d <- dirname(dirname(rstudioapi::getSourceEditorContext()$path))

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
if (!dir.exists(paste0(parent_d,required_dir[1]))){
  
  # If directory do not exist stop the app and print error message
  stop('Missing data \n Expected dataset in "Raw_data": no such directory exist.')
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
  source(paste0(parent_d,'/clean_data.R'))
  
  # Run function to merge datsets into required dataset
  merge_data(parent_d, required_dir[2])
  
  
}


