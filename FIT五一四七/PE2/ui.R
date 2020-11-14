# set working directory
  #setwd("/Users/SENMS/Desktop/5147/PE2")
# rm(list = ls())
# ui.R
library(shiny)
library(leaflet)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Coral Bleaching Ratio of Great Barrier Reef over the last 8 years"),
  
  # select coral type
  selectInput("corals", label = h3("Select Coral Type"), 
              choices = list("Blue Coral" = 1, "Hard Coral" = 2, "Soft Coral" = 3,
                             "Sea fans" = 4, "Sea pens" = 5), 
              selected = 1),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("corals"))),

  # radio button for line in plot 
  radioButtons("method", "Choice of smooth method:",
               list("loess","gam")),
  # contral panel
  conditionalPanel( condition = "output.method",
                    checkboxInput("default on loess","")),
  # slider for line span
  sidebarPanel(
      sliderInput("spans",
                  "Value of the span:",
                  min = 0.1,
                  max = 1.0,
                  value = 0.8)
    ),
  # main polt
  mainPanel(
    plotOutput("coralPlot")
  ),
  # map 
  leafletOutput("sitemap")
))


