# IBD project
Develop a web application to choose populations and draw the IBD patterns 
on a map.

# Libraries used
maps v3.4.1
tidyverse v1.3.2
readxl v1.4.1

# Data used
The following data sets were collected from the BINP29 canvas page.

    intra_pop_mean_pairwise_ibd_length.csv
    inter_pop_mean_pairwise_ibd_length.csv
    IBD annotation.xlsx

# Clean and extract necessary data
The Rscript clean_data.R is used to pair the data from *inter_pop_mean_pairwise_ibd_length.csv* with the location data in *IBD annotation.xlsx*. *NAs* are removed and the new dataset is saved as *IBD_geo.csv*