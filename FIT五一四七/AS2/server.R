#setwd("/Users/SENMS/Desktop/5147/AS2")
#rm(list = ls())
# Import data source 
au_baby <- read.csv("au_baby.csv")

library(shiny)

library(leaflet)

library(tidyverse)

library(ggplot2)

library(plotly)

library(forcats)

# shiny app
shinyServer(function(input, output) {
  
##### Tab 1 -> "Each Year" ######
  # male naming plot
  male_ttl_year <- reactive({
    # trim data frame
    au_baby <- au_baby[,c(2:3,6:9)]
    # subset by target year
    au_baby <- subset(au_baby, Year == input$year)
    # sum up the name counts
    x <- aggregate(au_baby$Count_male, by = list(Name = au_baby$Name_male), FUN=sum)
    # order by top ranking
    x <- head(arrange(x, desc(x)), n = radioIn())
    # order by desc
    p <- x %>% mutate(Name = fct_reorder(Name, x)) %>%
    # set up the tooltops
    mutate(text = paste("Name: ", Name, "\nAmount: ", x, "\nYear: ",input$year, sep="")) %>%
    # plotting the graph
    ggplot( mapping = aes(x, Name, size = x, color = Name, text = text)) + 
      # hide big ulgy legend
      guides(size=FALSE) + 
      # draw point with scale
      geom_point(alpha=0.7) +  scale_size(range = c(10, 25)) + 
      # modify labels for x,y axis
      xlab("Counts of Name") + ylab("Name") + 
      # modify title
      labs(title = "Male Names Ranking", subtitle = input$year) +
      # theme config
      theme(
              plot.title = element_text(color = "black", hjust = 0.5, size = 25, face = "bold"),
              plot.subtitle = element_text(color = "black", hjust = 0.5, size = 22),
              plot.caption = element_text(color = "black", size = 15, hjust = 0, face = "italic"),
              axis.title.x = element_text(color="black", size=14, face="bold"),
              axis.title.y = element_text(color="black", size=14, face="bold"),
              legend.title = element_blank(),
              legend.text = element_text(size = 12, face = "bold")
          )
    
    pp <- ggplotly(p, tooltip = "text")
    pp
  })
  # female naming plot
  female_ttl_year <- reactive({
    # trim data frame
    au_baby <- au_baby[,c(4:9)]
    # subset by target year value 
    au_baby <- subset(au_baby, Year == input$year)
    # sum up the name counts
    x <- aggregate(au_baby$Count_female, by = list(Name = au_baby$Name_female), FUN=sum)
    # order by top ranking
    x <- head(arrange(x, desc(x)), n = radioIn())
    # get median number
    med <- median(x$x)
    # order by desc
    p <- x %>% mutate(Name = fct_reorder(Name, x)) %>%
      # set up the tooltops
      mutate(text = paste("Name: ", Name, "\nAmount: ", x, "\nYear: ",input$year, sep="")) %>%
      # plotting the graph
      ggplot( mapping = aes(x, Name, size = x, color = Name, text = text)) + 
      # hide big ulgy legend
      guides(size=FALSE) + 
      # draw point with scale
      geom_point(alpha=0.7) +  scale_size(range = c(10, 25)) + 
      # modify labels for x,y axis
      xlab("Counts of Name") + ylab("Name") + 
      # modify title
      labs(title = "Female Names Ranking", subtitle = input$year) + 
      # theme config
      theme(
        plot.title = element_text(color = "black", hjust = 0.5, size = 25, face = "bold"),
        plot.subtitle = element_text(color = "black", hjust = 0.5, size = 22),
        plot.caption = element_text(color = "black", size = 15, hjust = 0, face = "italic"),
        axis.title.x = element_text(color="black", size=14, face="bold"),
        axis.title.y = element_text(color="black", size=14, face="bold"),
        legend.title = element_blank(),
        legend.text = element_text(size = 12, face = "bold")
      )
    
    pp <- ggplotly(p, tooltip = "text")
    pp
    

    
  })
###### End of Tab1 ######
  
  # switch plot by gender function
  graphInput <- reactive({
    switch(input$gender,
           "1" = male_ttl_year(),
           "0" = female_ttl_year()
    )
  })
  
  # radio switch
  radioIn <- reactive({
    switch(input$ranking,
           "T3" = 3,
           "T5" = 5,
           "T10" = 10
    )
  })
  
  # render each year(tab1) plot
  output$eachYear <- renderPlotly({graphInput()})

##### Tab 2 -> "Single Year" ######
  # male naming plot
  male_single_year <- reactive({
    # trim data frame
    au_baby <- au_baby[,c(2:3,6:9)]
    # subset by target year
    au_baby <- subset(au_baby, Year == input$T2year1 | Year == input$T2year2)
    # convert year to factor
    au_baby$Year <- as.factor(au_baby$Year)
    # sum up the name counts
    x <- aggregate(au_baby$Count_male, by=list(Name = au_baby$Name_male, Year = au_baby$Year), FUN=sum)
    # order by top ranking
    x <- head(arrange(x, desc(x)), n = 21)
    # order by desc
    p<- x %>%  mutate(Name = fct_reorder(Name, x)) %>%
      # set up the tooltops
      mutate(text = paste("Name: ", Name, "\nAmount: ", x, sep="")) %>%
      # plotting the graph
      ggplot(mapping = aes(Name, x, fill = Year, text = text)) + 
        geom_bar(stat="identity", position=position_dodge()) + 
        # switch plot style
        T2radioIn() + theme_bw() +
        # modify labels for x,y axis
        ylab("Counts of Name") + xlab("Name") +
        # modify title
        labs(title = "Compare Single Years Male names counts", subtitle = paste(input$T2year1, "and",input$T2year2)) + 
        # theme config
        theme(
          plot.title = element_text(color = "black", hjust = 0.5, size = 14, face = "bold"),
          plot.caption = element_text(color = "black", size = 15, hjust = 0, face = "italic"),
          axis.title.x = element_text(color="black", size=12, face="bold"),
          axis.title.y = element_text(color="black", size=12, face="bold"),
          legend.title = element_blank(),
          legend.text = element_text(size = 12, face = "bold")
        )
    pp <- ggplotly(p, tooltip = "text")
    pp
  })
  
  # female naming plot
  female_single_year <- reactive({
    # trim data frame
    au_baby <- au_baby[,c(4:9)]
    # subset by target year
    au_baby <- subset(au_baby, Year == input$T2year1 | Year == input$T2year2)
    # convert year to factor
    au_baby$Year <- as.factor(au_baby$Year)
    # sum up the name counts
    x <- aggregate(au_baby$Count_female, by=list(Name = au_baby$Name_female, Year = au_baby$Year), FUN=sum)
    # order by top ranking
    x <- head(arrange(x, desc(x)), n = 21)
    # order by desc
    p<- x %>%  mutate(Name = fct_reorder(Name, x)) %>%
      # set up the tooltops
      mutate(text = paste("Name: ", Name, "\nAmount: ", x, sep="")) %>%
      # plotting the graph
      ggplot(mapping = aes(Name, x, fill = Year, text = text)) + 
      geom_bar(stat="identity", position=position_dodge()) + 
      # switch plot style
      T2radioIn() + theme_bw() +
      # modify labels for x,y axis
      ylab("Counts of Name") + xlab("Name") +
      # modify title
      labs(title = "Compare Single Years Female names counts", subtitle = paste(input$T2year1, "and",input$T2year2)) + 
      # theme config
      theme(
        plot.title = element_text(color = "black", hjust = 0.5, size = 14, face = "bold"),
        plot.caption = element_text(color = "black", size = 15, hjust = 0, face = "italic"),
        axis.title.x = element_text(color="black", size=12, face="bold"),
        axis.title.y = element_text(color="black", size=12, face="bold"),
        legend.title = element_blank(),
        legend.text = element_text(size = 12, face = "bold")
      )
    pp <- ggplotly(p, tooltip = "text")
    pp
  })
###### End of Tab2 ######
  # switch plot by gender function
  T2graphInput <- reactive({
    switch(input$T2gender,
           "1" = male_single_year(),
           "0" = female_single_year()
    )
  })
  
  # T2 radio switch
  T2radioIn <- reactive({
    switch(input$style,
           "BC" = coord_flip(),
           "CC" = theme_bw()
    )
  })
  # render single year(tab2) plot
  output$singYear <- renderPlotly({T2graphInput()})

##### Tab 3 -> "sudden" ###### 
  # male naming plot
  male_T3 <- reactive({
    # subset by gender 
    getSingYear <- au_baby[,c(2:3,6:9)]
    # subset by state
    getSingYear <- subset(getSingYear, getSingYear$State == input$state)
    # make new df for plot
    makeDf <- function(year){
      k = year + 1
      IV <- subset(getSingYear$Count_male, getSingYear$Year == year)
      FV <- subset(getSingYear$Count_male, getSingYear$Year == k)
      CAGR <- (((FV/IV)^(1/2))-1)*100
      getYear <- c(k)
      getlong <- subset(getSingYear$long, getSingYear$Year == k)
      getlat <- (subset(getSingYear$lat, getSingYear$Year == k))
      getName <- subset(getSingYear$Name_male, getSingYear$Year == k)
      df <- data.frame(getName, CAGR, getYear, getlong, getlat)
    }
    # make dfs
    t3_13 <- makeDf(2013)
    t3_14 <- makeDf(2014)
    t3_15 <- makeDf(2015)
    t3_16 <- makeDf(2016)
    t3_17 <- makeDf(2017)
    t3_18 <- makeDf(2018)
    # merg DFs
    t3_ttl <- merge(t3_13,t3_14, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_15, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_16, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_17, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_18, all = TRUE)
    
    # remove negtive 
    t3_ttl$getYear <- as.factor(t3_ttl$getYear)
    male_mean <- mean(t3_ttl$CAGR)
    
      # set up the tooltops
      p<- t3_ttl %>% mutate(text = paste("Year: " ,getYear,"\nName: ", 
                                         getName, "\nCAGR: ", CAGR, sep="")) %>%
      # plotting graph
      ggplot(mapping = aes(reorder(getName, CAGR), CAGR, fill = getYear, text = text))  + geom_bar(stat = "identity") +
      # add compare line(median * 2.5)
      geom_hline(yintercept = male_mean , 
                 color = "red", size=1) +  coord_flip() +
      # add label
      # modify labels for x,y axis
      ylab("%Compound Annual Growth Rate(CAGR)") + xlab("Name") +
      # modify title
      labs(title = "CAGR of Each Male Names with each year", subtitle = paste(input$state, "over 6 Years")) + 
      # theme config
      theme(
        plot.title = element_text(color = "black", hjust = 0.5, size = 14, face = "bold"),
        plot.subtitle = element_text(color = "black", hjust = 0.5, size = 22),
        plot.caption = element_text(color = "black", size = 12, hjust = 0, face = "italic"),
        axis.title.x = element_text(color="black", size=10, face="bold"),
        axis.title.y = element_text(color="black", size=10, face="bold"),
        legend.title = element_blank(),
        legend.text = element_text(size = 12, face = "bold")
      )
    pp <- ggplotly(p, tooltip = "text")
    pp
  })
  
  # female naming plot
  female_T3 <- reactive({
    # subset by gender 
    getSingYear <- au_baby[,c(4:9)]
    # subset by state
    getSingYear <- subset(getSingYear, getSingYear$State == input$state)
    # make new df for plot
    makeDf <- function(year){
      k = year + 1
      IV <- subset(getSingYear$Count_female, getSingYear$Year == year)
      FV <- subset(getSingYear$Count_female, getSingYear$Year == k)
      CAGR <- (((FV/IV)^(1/2))-1)*100
      getYear <- c(k)
      getlong <- subset(getSingYear$long, getSingYear$Year == k)
      getlat <- (subset(getSingYear$lat, getSingYear$Year == k))
      getName <- subset(getSingYear$Name_female, getSingYear$Year == k)
      df <- data.frame(getName, CAGR, getYear, getlong, getlat)
    }
    # make DFs
    fet3_13 <- makeDf(2013)
    fet3_14 <- makeDf(2014)
    fet3_15 <- makeDf(2015)
    fet3_16 <- makeDf(2016)
    fet3_17 <- makeDf(2017)
    fet3_18 <- makeDf(2018)
    # merg DFs
    fet3_ttl <- merge(fet3_13,fet3_14, all = TRUE)
    fet3_ttl <- merge(fet3_ttl,fet3_15, all = TRUE)
    fet3_ttl <- merge(fet3_ttl,fet3_16, all = TRUE)
    fet3_ttl <- merge(fet3_ttl,fet3_17, all = TRUE)
    fet3_ttl <- merge(fet3_ttl,fet3_18, all = TRUE)
    
    # remove negtive 
    fet3_ttl$getYear <- as.factor(fet3_ttl$getYear)
    female_mean <- mean(fet3_ttl$CAGR)
    # set up the tooltops
    p<- fet3_ttl %>% mutate(text = paste("Year: " ,getYear,"\nName: ", 
                                       getName, "\nCAGR: ", CAGR, sep="")) %>%
      # plotting graph
      ggplot(mapping = aes(reorder(getName, CAGR), CAGR, fill = getYear, text = text))  + geom_bar(stat = "identity") +
      # add compare line(median * 2.5)
      geom_hline(yintercept = female_mean, 
                 color = "red", size= 1) +  coord_flip() +
      # add label
      # modify labels for x,y axis
      ylab("%Compound Annual Growth Rate(CAGR)") + xlab("Name") +
      # modify title
      labs(title = "CAGR of Each Female Names with each year", subtitle = paste(input$state, "over 6 Years")) + 
      # theme config
      theme(
        plot.title = element_text(color = "black", hjust = 0.5, size = 14, face = "bold"),
        plot.subtitle = element_text(color = "black", hjust = 0.5, size = 22),
        plot.caption = element_text(color = "black", size = 15, hjust = 0, face = "italic"),
        axis.title.x = element_text(color="black", size=10, face="bold"),
        axis.title.y = element_text(color="black", size=10, face="bold"),
        legend.title = element_blank(),
        legend.text = element_text(size = 12, face = "bold")
      )
    pp <- ggplotly(p, tooltip = "text")
    pp
  })
########end of T3 plot ########
  
  # switch plot by gender function
  T3graphInput <- reactive({
    switch(input$T3gender,
           "1" = male_T3(),
           "0" = female_T3()
    )
  })

  # T3 radio switch
  T3radioIn <- reactive({
    switch(input$state,
           "Victoria" = "Victoria",
           "Queensland" = "Queensland",
           "South Australia" = "South Australia"
    )
  })
  
  # render sudden(tab3) plot
  output$sudden <- renderPlotly({T3graphInput()})
  
########################### MAP #########################  
  # leaflet map
    male_map <- reactive({
      # subset by gender 
      getSingYear <- au_baby[,c(2:3,6:9)]
      # subset by state
      getSingYear <- subset(getSingYear, getSingYear$State == input$state)
      # make new df for plot
      makeDf <- function(year){
        k = year + 1
        IV <- subset(getSingYear$Count_male, getSingYear$Year == year)
        FV <- subset(getSingYear$Count_male, getSingYear$Year == k)
        CAGR <- (((FV/IV)^(1/2))-1)*100
        getYear <- c(k)
        getlong <- subset(getSingYear$long, getSingYear$Year == k)
        getlat <- (subset(getSingYear$lat, getSingYear$Year == k))
        getName <- subset(getSingYear$Name_male, getSingYear$Year == k)
        df <- data.frame(getName, CAGR, getYear, getlong, getlat)
      }
      t3_13 <- makeDf(2013)
      t3_14 <- makeDf(2014)
      t3_15 <- makeDf(2015)
      t3_16 <- makeDf(2016)
      t3_17 <- makeDf(2017)
      t3_18 <- makeDf(2018)
      # merg DFs
      t3_ttl <- merge(t3_13,t3_14, all = TRUE)
      t3_ttl <- merge(t3_ttl,t3_15, all = TRUE)
      t3_ttl <- merge(t3_ttl,t3_16, all = TRUE)
      t3_ttl <- merge(t3_ttl,t3_17, all = TRUE)
      t3_ttl <- merge(t3_ttl,t3_18, all = TRUE)
      
      # remove negtive 
      t3_ttl <- subset(t3_ttl, t3_ttl$CAGR > 0)
      sudden <- subset(t3_ttl, t3_ttl$CAGR  > median(t3_ttl$CAGR)*2.5)
      # sampling locations within the states
      for(i in 1:nrow(sudden)){
        sudden$getlong[i] <- (sudden$getlong[i] + (runif(1, 0.01, 0.08)))
        sudden$getlat[i] <- (sudden$getlat[i] + (runif(1, 0.01, 0.08)))
      }
      # create level for coloing
      sudden$range = cut(sudden$CAGR,
                         breaks = c(10,20,30,40,50,60,70,80,Inf), right = FALSE,
                         labels = c("0-20","20-30","30-40","40-50","50-60",
                                    "60-70","70-80","80+"))
      
      pal <- colorFactor(palette = c("blue","green","black","brown",
                                     "orange","pink","red","black"),
                         domain = sudden$range)
      
      # create map with marker
      leaflet(sudden) %>%
        addTiles() %>%
        addCircleMarkers(
          ~getlong,
          ~getlat,
          radius = ~CAGR,
          color = ~pal(range),
          label = ~getName, 
          stroke = FALSE, fillOpacity = 0.8
        ) %>%
        addLegend("bottomright", pal = pal, values = ~range,
                  title = "CAGR index",
                  opacity = 1
        )
    })
  
  
  # leaflet map
  female_map <- reactive({
    # subset by gender 
    getSingYear <- au_baby[,c(4:9)]
    # subset by state
    getSingYear <- subset(getSingYear, getSingYear$State == input$state)
    # make new df for plot
    makeDf <- function(year){
      k = year + 1
      IV <- subset(getSingYear$Count_female, getSingYear$Year == year)
      FV <- subset(getSingYear$Count_female, getSingYear$Year == k)
      CAGR <- (((FV/IV)^(1/2))-1)*100
      getYear <- c(k)
      getlong <- subset(getSingYear$long, getSingYear$Year == k)
      getlat <- (subset(getSingYear$lat, getSingYear$Year == k))
      getName <- subset(getSingYear$Name_female, getSingYear$Year == k)
      df <- data.frame(getName, CAGR, getYear, getlong, getlat)
    }
    t3_13 <- makeDf(2013)
    t3_14 <- makeDf(2014)
    t3_15 <- makeDf(2015)
    t3_16 <- makeDf(2016)
    t3_17 <- makeDf(2017)
    t3_18 <- makeDf(2018)
    # merg DFs
    t3_ttl <- merge(t3_13,t3_14, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_15, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_16, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_17, all = TRUE)
    t3_ttl <- merge(t3_ttl,t3_18, all = TRUE)
    
    # remove negtive 
    t3_ttl <- subset(t3_ttl, t3_ttl$CAGR > 0)
    sudden <- subset(t3_ttl, t3_ttl$CAGR > median(t3_ttl$CAGR)*2.5)
    # sampling locations within the states
    for(i in 1:nrow(sudden)){
      sudden$getlong[i] <- (sudden$getlong[i] + (runif(1, 0.01, 0.08)))
      sudden$getlat[i] <- (sudden$getlat[i] + (runif(1, 0.01, 0.08)))
    }
    # create level for coloing
    sudden$range = cut(sudden$CAGR,
                       breaks = c(10,20,30,40,50,60,70,80,Inf), right = FALSE,
                       labels = c("0-20","20-30","30-40","40-50","50-60",
                                  "60-70","70-80","80+"))
    
    pal <- colorFactor(palette = c("blue","green","black","brown",
                                   "orange","pink","red","black"),
                       domain = sudden$range)
    
    # create map with marker
    leaflet(sudden) %>%
      addTiles() %>%
      addCircleMarkers(
        ~getlong,
        ~getlat,
        radius = ~CAGR,
        color = ~pal(range),
        label = ~getName,
        stroke = FALSE, fillOpacity = 0.8
      ) %>%
      addLegend("bottomright", pal = pal, values = ~range,
                title = "CAGR index",
                opacity = 1
      )
  })
  
  # T3 map switch
  MapradioIn <- reactive({
    switch(input$map,
           "MN" = male_map(),
           "FN" = female_map()
    )
  })
  
  output$namemap <- renderLeaflet({MapradioIn()})
  
})
