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
The Rscript clean_data.R is used to pair the data from *inter_pop_mean_pairwise_ibd_length.csv* with the location data in *IBD annotation.xlsx*. *NAs* and popoulations without any latitude and longitude data are removed and the new dataset is saved to *geo_IBD_data.csv*. This data set contains pop1, pop2, mean IBD length, pop size of pop2, continent, country, and latitude and longitude for each population in pop2.

## Functions
The Rscript *functions.R* contain functions to be used in the r shiny web application. 
    
    get_quantiles()
    plot_map()
    getColor()
    update_map()
    filter_table() 
    tick_step()

**get_quantiles()** takes one argument, a complete data frame containing all the populations and their annotations that can be linked to the chosen population. Returns the IBD length at the quantile cut offs based on the IBD length distribution among all populations that can be linked to the chosen population in the dataset.

**plot_map()** renders an empty world map. 

**getColor()** Takes two arguments, 1) A complete data frame containing all the populations and their annotations that can be linked to the chosen population. 2) The new filtered data frame, only containing the populations that should be displayed on the map after filtering. Assign every population that can be linked to the chosen population a color based on what percentile it belongs to. The population will be displayed on the map with this color. **getColor()** is used in **update_map()** described below.

**update_map()** takes one argument of type *reactivevalues* containing all the input values from the user. The complete data frame containing all the populations and their annotations that can be linked to the chosen population is filtered by the user specified filters and then added to the map again.

**filter_table()** takes one argument, of type *reactivevalues* containing all the input values from the user. The complete data frame containing all the populations and their annotations that can be linked to the chosen population is filtered by the user specified filters. The filtered data is then returned as a data fram ordered as specifed by the user.


## Web application
R shiny is used for this web application. Let the user choose a populaton of interest and then plot related populations and display the name of the populations and their IBD.

Drop down menu let the user choose a population to display all the populations that can be linked to the chosen population on the map. 

Sliding bar let the user filter the IBD length to only display populations within the choosen range.

In addition, a table displaying the filtered data (including, populations linked to the chosen population, mean pairwise IBD length, population size, IBD length SE, continent and country of the linked populations) can be accessed in a second tab (*Tables*) at the top menu. Here, the quantile cut offs are also displayed. The user can also specify how the table should be sorted by changing the sorting method in the drop down meu to the rigth. 