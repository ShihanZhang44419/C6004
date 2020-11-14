#setwd("/Users/SENMS/Desktop/5147/AS2")
#rm(list = ls())
# Import data source 
au_baby <- read.csv("au_baby.csv")
library(shiny)
library(leaflet)
library(plotly)
shinyUI(fluidPage(
  # navigation bar for UI
  navbarPage(
    # title for page
    "Australian newborn naming analysis",
    # first tab bar
    # title for first tab
    tabPanel("Names Ranking of Each Year",
      fluid = TRUE,
################# T1 selector panel
      sidebarLayout(
        sidebarPanel(
          # panel title
          titlePanel("Selection Panel"),
          # panel for select gender
          fluidRow(column(
            8,
            selectInput("gender",
              label = p("Select Gender"),
              choices = list("Female" = 0, "Male" = 1),
              selected = 0
            ),

            # panel for year slider
            sliderInput(
              label = "Select Year",
              inputId = "year",
              min = 2013,
              max = 2019,
              value = 2015,
              sep = ""
            ),

            # panel for ranking
            radioButtons("ranking", "Select Ranking:",
              c(
                "Top 3" = "T3",
                "Top 5" = "T5",
                "Top 10" = "T10"
              ),
              selected = "T10"
            ),
            hr(),
            titlePanel("Data Source"),
            h5("Victoria: "),
            h6("https://www.bdm.vic.gov.au/births/naming-your-child/popular-baby-names-in-victoria"),
            h5("Queensland: "),
            h6("https://www.data.qld.gov.au/dataset/top-100-baby-names"),
            h5("South Australia: "),
            h6("https://data.sa.gov.au/data/dataset/popular-baby-names"),
            titlePanel("Meta info."),
            h5("Author: Shihan Zhang"),
            h5("Student Id: 31268102"),
            h5("Date of Last Update: 2020-06-18")
          )),
          hr(),
          
        ),
        # main panel to show plot
        mainPanel(
          fluidRow(column(
            12,
            helpText("Tip: Moving the mouse over the plots will display the relative information."),
            hr(),
            plotlyOutput("eachYear", width = '100%', height = "750px"),
            
          ))
        ),
      )
    ),
    # second tab bar
    tabPanel("Compare Single Years",
      fluid = TRUE,
################# T2 selector panel
      sidebarLayout(
        sidebarPanel(
          # panel title
          titlePanel("Selection Panel"),
          # panel for select gender
          fluidRow(column(
            8,
            selectInput("T2gender",
              label = p("Select Gender"),
              choices = list("Female" = 0, "Male" = 1),
              selected = 0
            ),

            # panel for ranking
            radioButtons("style", "Select Plot:",
              c(
                "Bar Chart" = "BC",
                "Column Chart" = "CC"
              ),
              selected = "BC"
            ),
            column(
              6,
              # panel for year 1 slider
              radioButtons(
                label = "Select Year 1",
                inputId = "T2year1",
                c(
                  "2013" = "2013",
                  "2014" = "2014",
                  "2015" = "2015",
                  "2016" = "2016"
                ),
                selected = "2013"
              )
            ),
            # panel for year 2 slider
            column(
              6,
              radioButtons(
                label = "Select Year 2",
                inputId = "T2year2",
                c(
                  "2017" = "2017",
                  "2018" = "2018",
                  "2019" = "2019"
                ),
                selected = "2018"
              )
            )
          )),
          titlePanel("Data Source"),
          h5("Victoria: "),
          h6("https://www.bdm.vic.gov.au/births/naming-your-child/popular-baby-names-in-victoria"),
          h5("Queensland: "),
          h6("https://www.data.qld.gov.au/dataset/top-100-baby-names"),
          h5("South Australia: "),
          h6("https://data.sa.gov.au/data/dataset/popular-baby-names"),
          titlePanel("Meta info."),
          h5("Author: Shihan Zhang"),
          h5("Student Id: 31268102"),
          h5("Date of Last Update: 2020-06-18")
        ),
        # main panel to show plot
        mainPanel(
          fluidRow(column(
            10,
            helpText("Tip: Moving the mouse over the plots will display the relative information."),
            hr(),
            plotlyOutput("singYear", height = "750px")
           
          ))
        ),
      )
    ),
    # third tab bar
    tabPanel("CAGR of Names",
      fluid = TRUE,
################# T3 selector panel
      sidebarLayout(
        sidebarPanel(
          # panel title
          titlePanel("Selection Panel"),
          fluidRow(column(
            8,
            # panel for select gender
            selectInput("T3gender",
                        label = p("Select State"),
                        choices = list("Female" = 0, "Male" = 1),
                        selected = 1
            ),
            # select state
            radioButtons("state", "Select State:",
                         c(
                           "Victoria" = "Victoria",
                           "Queensland" = "Queensland",
                           "South Australia" = "South Australia"
                         ),
                         selected = "Victoria"
            ),
            
            # swwitch map
            radioButtons("map", "Select Map:",
                         c(
                           "Male Name" = "MN",
                           "Female Name" = "FN"
                         ),
                         selected = "MN"
            ),
            titlePanel("Data Source"),
            h5("Victoria: "),
            h6("https://www.bdm.vic.gov.au/births/naming-your-child/popular-baby-names-in-victoria"),
            h5("Queensland: "),
            h6("https://www.data.qld.gov.au/dataset/top-100-baby-names"),
            h5("South Australia: "),
            h6("https://data.sa.gov.au/data/dataset/popular-baby-names"),
            titlePanel("Meta info."),
            h5("Author: Shihan Zhang"),
            h5("Student Id: 31268102"),
            h5("Date of Last Update: 2020-06-18")
          ))
        ),
        # main panel to show plot
        mainPanel(
          fluidRow(column(
            10,
            helpText("Tip: Moving the mouse over the plots will display the relative information."),
            plotlyOutput("sudden", height = "500px"),
            helpText("\nTips: The red line indicate the mean value of CAGR"),
            helpText("What is CAGR?"),
            helpText("Compound annual growth rate (CAGR) is the rate of return that 
                     would be required for an investment to grow from its beginning 
                     balance to its ending balance."),
            helpText("No investment is involved in our case, 
                     we just use CAGR to reflect the growth of the data, less than 0 means decressed,
                     grater than 0 means incresed"),
            hr(),
            h4("Location of the Names with Large CAGR"),
            wellPanel(
            leafletOutput("namemap"))
           
            
          ))
        ),
      )
    )
  )
))
