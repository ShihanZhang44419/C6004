# set working directory
  #setwd("/Users/SENMS/Desktop/5147/PE2")
# server.R
library(shiny)
library(htmltools)
library(leaflet)
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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #corals plot
  # blue
  plot_blue <- reactive({
    ggplot(blue_corals, aes(year, value, color = location)) + 
      geom_point() + 
      geom_smooth(method = input$method, span = input$spans) + 
      facet_grid(vars(latitude)) +
      ggtitle("Coral Bleaching Ratio of 'Blue corals' over the last 8 years") +
      # modify the legend lable for X,Y axis
      xlab("Year of data collection") + 
      ylab ("Bleaching ratio in %") 
  })
  # hard
  plot_hard <- reactive({
    ggplot(hard_corals, aes(year, value, color = location)) + 
      geom_point() + 
      geom_smooth(method = input$method, span = input$spans) + 
      facet_grid(vars(latitude)) +
      ggtitle("Coral Bleaching Ratio of 'Hard corals'' over the last 8 years") +
      # modify the legend lable for X,Y axis
      xlab("Year of data collection") + 
      ylab ("Bleaching ratio in %") 
  })
  # soft
  plot_soft <- reactive({
    ggplot(soft_corals, aes(year, value, color = location)) + 
      geom_point() + 
      geom_smooth(method = input$method, span = input$spans) + 
      facet_grid(vars(latitude)) +
      ggtitle("Coral Bleaching Ratio of 'Soft Corals' over the last 8 years") +
      # modify the legend lable for X,Y axis
      xlab("Year of data collection") + 
      ylab ("Bleaching ratio in %") 
  })
  # fans
  plot_fans <- reactive({
    ggplot(sea_fans, aes(year, value, color = location)) + 
      geom_point() + 
      geom_smooth(method = input$method, span = input$spans) +  
      facet_grid(vars(latitude)) +
      ggtitle("Coral Bleaching Ratio of 'Sea fans' over the last 8 years") +
      # modify the legend lable for X,Y axis
      xlab("Year of data collection") + 
      ylab ("Bleaching ratio in %") 
  })
  # 08
  plot_pens <- reactive({
    ggplot(sea_pens, aes(year, value, color = location)) + 
      geom_point() + 
      geom_smooth(method = input$method, span = input$spans) +  
      facet_grid(vars(latitude)) +
      ggtitle("Coral Bleaching Ratio of 'Sea pens' over the last 8 years") +
      # modify the legend lable for X,Y axis
      xlab("Year of data collection") + 
      ylab ("Bleaching ratio in %") 
  })
  
  # switch plot function
  graphInput <- reactive({
    switch(input$corals,
           "1" = plot_blue(),
           "2" = plot_hard(),
           "3" = plot_soft(),
           "4" = plot_fans(),
           "5" = plot_pens(),
    )
  })
  
  # radio button
  smootherInput <- reactive({
    method <- switch(input$method,
                     "loess"= loess,
                     "gam" = gam)
  })
  
  output$method <- reactive({
    method(smootherInput())
  })
  
  # render plot
  output$coralPlot <- renderPlot({ 
    graphInput()
  })
  
  #label for x , y axis
  output$info <- renderText({
    paste0("x=", coral_data$year, "\ny=", coral_data$value)
  })
  
  output$sitemap <- renderLeaflet({
    leaflet(coral_data) %>%
      addTiles() %>%
      #setView(coral_data$longitude, coral_data$latitude, zoom = 5) %>%
      addMarkers(site01$longitude, site01$latitude, 
                 label = "Site 01",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site02$longitude, site02$latitude, 
                 label = "Site 02",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site03$longitude, site03$latitude, 
                 label = "Site 03",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site04$longitude, site04$latitude, 
                 label = "Site 04",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site05$longitude, site05$latitude, 
                 label = "Site 05",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site06$longitude, site06$latitude, 
                 label = "Site 06",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site07$longitude, site07$latitude, 
                 label = "Site 07",
                 labelOptions = labelOptions(noHide = T)) %>%
      
      addMarkers(site08$longitude, site08$latitude, 
                 label = "Site 08",
                 labelOptions = labelOptions(noHide = T))
  })
  
})