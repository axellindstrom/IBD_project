# IBD project
Develop a web application to choose populations and draw the IBD patterns 
on a map.

## Libraries used
    tidyverse v1.3.2
    readxl v1.4.1
    leaflet v2.1.1
    shiny v1.7.4

## Data used
The following data sets were collected from the BINP29 canvas page.

    intra_pop_mean_pairwise_ibd_length.csv
    inter_pop_mean_pairwise_ibd_length.csv
    IBD annotation.xlsx

## Clean and extract necessary data
The Rscript clean_data.R is used to pair the data from *inter_pop_mean_pairwise_ibd_length.csv* with the location data in *IBD annotation.xlsx*. *NAs* and popoulations without any latitude and longitude data are removed and the new dataset is saved to *geo_IBD_data.csv*. This data set contains pop1, pop2, mean IBD length, latitude and longitude for each population in pop2.

## Plot map
The Rscript *plot_map.R* takes a population as an inpput and plots the related populations and their IBD to a map. For each choosen populaton the quantiles for IBD legnth is calculated based on all related population to then be used to color markers depending of the relative length of IBD. The functions defined in this script will be implemented in the web application. All populations are saved to a list that can be used in the applicatoin as a drop down menu.

## Web application
R shiny is used for this web application. Let the user choose a populaton of interest and then plot related populations and display the name of the populations and their IBD.