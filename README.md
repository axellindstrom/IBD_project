# GeoIBD
The concept of identity by descent (IBD) in genetics is where two individuals or populations are IBD at a genomic segment inherited from a common ancestor. Today large datasets are available that can help us understand health and disease outcomes. In order to understanding the genetic relationships between individuals on a population level, tools helping us analyze and visualize the data is needed. 

***GeoIBD*** is a web application allowing the user to choose populations and draw the IBD patterns on a map. This application help you visualize the IBD length between populations.

Note, this tool does not analyze the provided data, nor does it provide an explanation of the data. GeoIBD alone should only be used to visualize IBD patterns between populations rather than implying real connections between populations, which would require additional analysis. 


## Libraries used
    tidyverse v1.3.2        # Used for data manipulation.
    readxl v1.4.1           # Part of tidyverse but has to be loaded separately. used to read in xlsx files.
    leaflet v2.1.1          # Used to render and manipulate maps.
    shiny v1.7.4            # Used to build the ap user interface and server side.
    shinythemes v1.2.0      # Used to add themes to the app.
 
## Data used
The following data sets were collected from the BINP29 canvas page.

    inter_pop_mean_pairwise_ibd_length.csv
    IBD annotation.xlsx

*inter_pop_mean_pairwise_ibd_length.csv* contain IBD information and population names. *IBD annotation.xlsx* contains longitude and latitude coordinates, continent, and country of origin for each population.

## Clean and extract necessary data
The Rscript clean_data.R is used to pair the data from *inter_pop_mean_pairwise_ibd_length.csv* with the location data in *IBD annotation.xlsx*. *NAs* the new dataset is saved to as *geo_IBD_data.csv* in the 1_Filtered_Data folder. This data set contains pop1, pop2, mean IBD length, IBD length SE, pop size of pop2, continent, country, and latitude and longitude for each population in pop2.

## Functions
The Rscript *functions.R* contain functions to be used in the r shiny web application. 
    
    get_quantiles()
    plot_map()
    get_color()
    get_weight()
    update_map()
    filter_table() 
    tick_step()

**get_quantiles()** takes one argument, a complete data frame containing all the populations and their annotations that can be linked to the chosen population. Returns the IBD length at the quantile cut offs based on the IBD length distribution among all populations that can be linked to the chosen population in the dataset.

**plot_map()** renders an empty world map. 

**get_color()** Takes two arguments, 1) A complete data frame containing all the populations and their annotations that can be linked to the chosen population. 2) The new filtered data frame, only containing the populations that should be displayed on the map after filtering. Assign every population that can be linked to the chosen population a color based on what percentile it belongs to. The population will be displayed on the map with this color. **getColor()** is used in **update_map()** described below.

**get_weight()** is similar to **get_color()** but instead of a color the **get_weigth()** function return a value of 1, 10, 20 or 30 which then is used to specify the thickness of the line plotted to the map between 2 populaitons.

**update_map()** takes one argument of type *reactivevalues* containing all the input values from the user. The complete dataframe containing all the populations and their annotations that can be linked to the chosen population is filtered by the user specified filters and then added to the map again.

**filter_table()** takes two arguments 1) of type *reactivevalues* containing all the input values from the user. The complete dataframe containing all the populations and their annotations that can be linked to the chosen population is filtered by the user specified filters. 2) a boolean to specify how the data should be ordered. The filtered data is then returned as a dataframe ordered as specified by the user.


## Web application
R shiny is used for this web application. Let the user choose a population of interest and then plot related populations and display the name of the populations and their IBD length on a map.

Drop down menu let the user choose a population to display all the populations that can be linked to the chosen population on the map. 

Sliding bar let the user filter the IBD length to only display populations within the chosen range.

In addition, a table displaying the filtered data (including, populations linked to the chosen population, mean pairwise IBD length, population size, IBD length SE, continent and country of the linked populations) can be accessed in a second tab (*Tables*) at the top menu. Here, the quantile cut offs are also displayed. The user can also specify how the table should be sorted by changing the sorting method in the drop down meu to the right. 

## Running app
To run the app from the command line:

    Rscript -e 'library(methods); shiny::runApp("GeoIBD/", launch.browser = TRUE)'

Where **GeoIBD/** is the path to the directory containing the app (ui.R and server.R). 

Upon launch of the app the app will check if the necessary directories and files are in place. If the directory **Raw_data** or the files in **Raw_data** is missing the app will not be launched. Additionally, upon launch the app will check that the directory **1_Filtered_data** exist, if not, it will be created. if **1_Filtered_data** exist it will check that **geo_IBD_data.csv** exist in the **1_Filtered_data** directory, if not, the ***clean_data.R*** script will be called and **geo_IBD_data.csv** will be created. All necessary packages will also be installed if not already installed.

**Note**, R and the library shiny is required to be installed for the app to run. all other libraries will automatically be installed if needed.
