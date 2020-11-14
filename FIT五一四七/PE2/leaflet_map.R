# set working directory
#setwd("/Users/SENMS/Desktop/5147/PE2")
#rm(list = ls())
# leaft map
library(leaflet)
# read csv file
coral_data <- read.csv("assignment-02-data-formated.csv")

# sites locations(with Leaflet)
coral_map <- leaflet(coral_data) %>% addTiles() %>%
  # add location marks
  addMarkers(~longitude, ~latitude, popup = ~as.character(location))

# show map
coral_map