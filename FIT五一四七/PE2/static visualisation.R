# setwd("/Users/SENMS/Desktop/5147/PE2")
# rm(list = ls())
library(ggplot2)
# read csv file
coral_data <- read.csv("assignment-02-data-formated.csv")

# modify the 'value' from factor to numeric
coral_data$value <- as.numeric(sub("%","",coral_data$value))

# order site by latitude
coral_data <- coral_data[order(coral_data$latitude, coral_data$location),]
# creating subsets
  # site 1-8
site01 <- subset(coral_data,location == "site01")
site02 <- subset(coral_data,location == "site02")
site03 <- subset(coral_data,location == "site03")
site04 <- subset(coral_data,location == "site04")
site05 <- subset(coral_data,location == "site05")
site06 <- subset(coral_data,location == "site06")
site07 <- subset(coral_data,location == "site07")
site08 <- subset(coral_data,location == "site08")
  
# corals types
blue_corals <- subset(coral_data, coralType == "blue corals")
hard_corals <- subset(coral_data, coralType == "hard corals")
soft_corals <- subset(coral_data, coralType == "soft corals")
sea_pens <- subset(coral_data, coralType == "sea pens")
sea_fans <- subset(coral_data, coralType == "sea fans")

# static visualisation using ggplot2
plot1 <- ggplot(coral_data, aes(year, value, color = coralType)) + 
  geom_point() + 
  geom_smooth(se = FALSE) + 
  facet_grid(vars(latitude),vars(coralType)) +
  ggtitle("Coral Bleaching Ratio of Great Barrier Reef over the last 8 years") +
  # modify the legend lable for X,Y axis
  xlab("Year of data collection") + 
  ylab ("Bleaching ratio in %") 
  # modify the lengend title (color legend)

# show the plot
plot1


