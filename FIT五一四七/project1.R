setwd("/Users/SENMS/Desktop/5147/VIC_baby")
rm(list = ls())
# read excel file 
library("xlsx")
 # load VIC DATA
vic_2019 <- read.xlsx("Top 100 Baby Names 2019.xlsx", 1)
vic_2018 <- read.xlsx("Top 100 Baby Names 2018.xlsx", 1)
vic_2017 <- read.xlsx("Top 100 Baby Names 2017.xlsx", 1)
vic_2016 <- read.xlsx("Top 100 Baby Names 2016.xlsx", 1)
vic_2015 <- read.xlsx("Top 100 Baby Names 2015.xlsx", 1)
vic_2014 <- read.xlsx("Top 100 Baby Names 2014.xlsx", 1)
vic_2013 <- read.xlsx("Top 100 Baby Names 2013.xlsx", 1)
 # load QLD DATA
qld_2019 <- read.csv("bdm-top-100-baby-names-2019.csv")
qld_2018 <- read.csv("20190129_bdm_top-100-baby-names-2018.csv")
qld_2017 <- read.csv("20180123_bdm_top-100-baby-names-2017.csv")
qld_2016 <- read.csv("20170119_bdm_top-100-baby-names-2016.csv")
qld_2015 <- read.csv("20160201_bdm_top-100-baby-names-2015.csv")
qld_2014 <- read.csv("20150309_bdm_top-100-baby-names-2014.csv")
qld_2013 <- read.csv("20150309_bdm_top-100-baby-names-2013.csv")
  # load SA DATA
sa_2019 <- read.csv("female_cy2019_top100.csv")
sa_2018 <- read.csv("female_cy2018_top100.csv")
sa_2017 <- read.csv("cusersjacksm01desktopfemalecy2017top.csv")
sa_2016 <- read.csv("femalecy2016top.csv")
sa_2015 <- read.csv("femalecy2015top.csv")
sa_2014 <- read.csv("femalecy2014top.csv")
sa_2013 <- read.csv("female_cy2013_top.csv")

### if can not ready excel file please install
### install.packages('xlsx')

# process data wrangling 
library(tidyverse)
### if tidyverse not installed 
### install.packages("tidyverse")


############################ VIC DATA #######################################
# only keep first 15th data for each df. as the lean data
lean_v2013<- head(vic_2013,-85)
lean_v2014<- head(vic_2014,-85)
lean_v2015<- head(vic_2015,-85)
lean_v2016<- head(vic_2016,-85)
lean_v2017<- head(vic_2017,-85)
lean_v2018<- head(vic_2018,-85)
lean_v2019<- head(vic_2019,-85)

# rename columns
lean_v2019 <- lean_v2019 %>%
  rename(Name_male = Name...Male, Name_female = Name...Female,
         Count_male = Count, Count_female = Count.1)

lean_v2018 <- lean_v2018 %>%
  rename(Name_male = NA., Count_male = NA..1,
         Name_female = NA..4, Count_female = NA..5)

lean_v2017 <- lean_v2017 %>%
  rename(Name_male = NA., Count_male = NA..1,
         Name_female = NA..4, Count_female = NA..5)

lean_v2016 <- lean_v2016 %>%
  rename(Name_male = NA., Count_male = NA..1,
         Name_female = NA..4, Count_female = NA..5)

lean_v2015 <- lean_v2015 %>%
  rename(Name_male = NA., Count_male = NA..1,
         Name_female = NA..4, Count_female = NA..5)

lean_v2014 <- lean_v2014 %>%
  rename(Name_male = NA., Count_male = NA..1,
         Name_female = NA..4, Count_female = NA..5)

lean_v2013 <- lean_v2013 %>%
  rename(Name_male = NA., Count_male = NA..1,
         Name_female = NA..4, Count_female = NA..5)
# add year
lean_v2013$Year <- 2013
lean_v2014$Year <- 2014
lean_v2015$Year <- 2015
lean_v2016$Year <- 2016
lean_v2017$Year <- 2017
lean_v2018$Year <- 2018
lean_v2019$Year <- 2019

# remove empty columns
lean_v2019$Rank <- NULL
lean_v2019$Rank.1 <- NULL
lean_v2018$NA..2 <- NULL
lean_v2018$NA..3 <- NULL
lean_v2017$NA..2 <- NULL
lean_v2017$NA..3 <- NULL
lean_v2016$NA..2 <- NULL
lean_v2016$NA..3 <- NULL
lean_v2015$NA..2 <- NULL
lean_v2015$NA..3 <- NULL
lean_v2014$NA..2 <- NULL
lean_v2014$NA..3 <- NULL
lean_v2013$NA..2 <- NULL
lean_v2013$NA..3 <- NULL

# remove unecessary columns
lean_v2018$Top.100.Baby.Names...2018 <- NULL
lean_v2017$Top.100.Baby.Names...2017. <- NULL
lean_v2016$Top.100.Baby.Names...2016. <- NULL
lean_v2015$Top.100.Baby.Names...2015. <- NULL
lean_v2014$Top.100.Baby.Names...2014. <- NULL
lean_v2013$Top.100.Baby.Names...2013 <- NULL

 # remove first 2 rows
lean_v2018 <- tail(lean_v2018, -2)
lean_v2017 <- tail(lean_v2017, -2)
lean_v2016 <- tail(lean_v2016, -2)
lean_v2015 <- tail(lean_v2015, -2)
lean_v2014 <- tail(lean_v2014, -2)
lean_v2013 <- tail(lean_v2013, -2)

#convert to factor for mergeing
lean_v2018$Count_female <- as.numeric(levels(lean_v2018$Count_female))[lean_v2018$Count_female]
lean_v2018$Count_male <- as.numeric(levels(lean_v2018$Count_male))[lean_v2018$Count_male]

lean_v2017$Count_female <- as.numeric(levels(lean_v2017$Count_female))[lean_v2017$Count_female]
lean_v2017$Count_male <- as.numeric(levels(lean_v2017$Count_male))[lean_v2017$Count_male]

lean_v2016$Count_female <- as.numeric(levels(lean_v2016$Count_female))[lean_v2016$Count_female]
lean_v2016$Count_male <- as.numeric(levels(lean_v2016$Count_male))[lean_v2016$Count_male]

lean_v2015$Count_female <- as.numeric(levels(lean_v2015$Count_female))[lean_v2015$Count_female]
lean_v2015$Count_male <- as.numeric(levels(lean_v2015$Count_male))[lean_v2015$Count_male]

lean_v2014$Count_female <- as.numeric(levels(lean_v2014$Count_female))[lean_v2014$Count_female]
lean_v2014$Count_male <- as.numeric(levels(lean_v2014$Count_male))[lean_v2014$Count_male]

lean_v2013$Count_female <- as.numeric(levels(lean_v2013$Count_female))[lean_v2013$Count_female]
lean_v2013$Count_male <- as.numeric(levels(lean_v2013$Count_male))[lean_v2013$Count_male]
# merge all df(lean data)
vic34 <- merge(lean_v2013, lean_v2014, all = TRUE)
vic56 <- merge(lean_v2015, lean_v2016, all = TRUE)
vic78 <- merge(lean_v2017, lean_v2018, all = TRUE)

vic3456 <- merge(vic34, vic56, all = TRUE)
vic789  <- merge(vic78, lean_v2019, all = TRUE)
# final df for VIC 13-19
vic_6y <- merge(vic3456, vic789, all =TRUE)

############################ END OF VIC DATA #################################


############################ QLD DATA ########################################
  # get lean data 
 lean_q2013 <- head(qld_2013,-88)
 lean_q2014 <- head(qld_2014,-86)
 lean_q2015 <- head(qld_2015,-88)
 lean_q2016 <- head(qld_2016,-85)
 lean_q2017 <- head(qld_2017,-85)
 lean_q2018 <- head(qld_2018,-88)
 lean_q2019 <- head(qld_2019,-86)
  # add year
 lean_q2013$Year <- 2013
 lean_q2014$Year <- 2014
 lean_q2015$Year <- 2015
 lean_q2016$Year <- 2016
 lean_q2017$Year <- 2017
 lean_q2018$Year <- 2018
 lean_q2019$Year <- 2019
  # rename table
  #qld_list <- list(lean_q2013, lean_q2014, lean_q2015,
                   #lean_q2016, lean_q2017, lean_q2018, lean_q2019)
  lean_q2013 <- lean_q2013 %>%
   rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
          Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  lean_q2014 <- lean_q2014 %>%
    rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
           Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  lean_q2015 <- lean_q2015 %>%
    rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
           Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  lean_q2016 <- lean_q2016 %>%
    rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
           Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  lean_q2017 <- lean_q2017 %>%
    rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
           Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  lean_q2018 <- lean_q2018 %>%
    rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
           Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  lean_q2019 <- lean_q2019 %>%
    rename(Name_male = Boy.Names, Count_male = Count.of.Boy.Names,
           Name_female = Girl.Names, Count_female = Count.of.Girl.Names)
  # merge all df(lean data)
  qld34 <- merge(lean_q2013, lean_q2014, all = TRUE)
  qld56 <- merge(lean_q2015, lean_q2016, all = TRUE)
  qld78 <- merge(lean_q2017, lean_q2018, all = TRUE)
  
  qld3456 <- merge(qld34, qld56, all = TRUE)
  qld789  <- merge(qld78, lean_q2019, all = TRUE)
  # final df for VIC 13-19
  qld_6y <- merge(qld3456, qld789, all =TRUE)
  
############################ END OF QLD DATA #################################

  
############################# SA DATA ########################################
  # # get lean data
  lean_s2013 <- head(sa_2013,-2777)
  lean_s2014 <- head(sa_2014,-2821)
  lean_s2015 <- head(sa_2015,-2880)
  lean_s2016 <- head(sa_2016,-2789)
  lean_s2017 <- head(sa_2017,-2749)
  lean_s2018 <- head(sa_2018,-85)
  lean_s2019 <- head(sa_2019,-85)
  # # remove unnecessary colunms
  lean_s2013$Position <- NULL
  lean_s2013$Position.1 <- NULL
  lean_s2014$Position <- NULL
  lean_s2014$Position.1 <- NULL
  lean_s2015$Position <- NULL
  lean_s2015$Position.1 <- NULL
  lean_s2016$Position <- NULL
  lean_s2016$Position.1 <- NULL
  lean_s2017$Position <- NULL
  lean_s2017$Position.1 <- NULL
  lean_s2018$Position <- NULL
  lean_s2018$Position.1 <- NULL
  lean_s2019$Position <- NULL
  lean_s2019$Position.1 <- NULL
  # # add year 
  lean_s2013$Year <- 2013
  lean_s2014$Year <- 2014
  lean_s2015$Year <- 2015
  lean_s2016$Year <- 2016
  lean_s2017$Year <- 2017
  lean_s2018$Year <- 2018
  lean_s2019$Year <- 2019
  # # rename columns
  lean_s2013 <- lean_s2013 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
            Name_female = Given.Name, Count_female = Amount)
  lean_s2014 <- lean_s2014 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
           Name_female = Given.Name, Count_female = Amount)
  lean_s2015 <- lean_s2015 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
           Name_female = Given.Name, Count_female = Amount)
  lean_s2016 <- lean_s2016 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
           Name_female = Given.Name, Count_female = Amount)
  lean_s2017 <- lean_s2017 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
           Name_female = Given.Name, Count_female = Amount)
  lean_s2018 <- lean_s2018 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
           Name_female = Given.Name, Count_female = Amount)
  lean_s2019 <- lean_s2019 %>%
    rename(Name_male = Given.Name.1, Count_male = Amount.1,
           Name_female = Given.Name, Count_female = Amount)
  # merge all df(lean data)
  sa34 <- merge(lean_s2013, lean_s2014, all = TRUE)
  sa56 <- merge(lean_s2015, lean_s2016, all = TRUE)
  sa78 <- merge(lean_s2017, lean_s2018, all = TRUE)
  
  sa3456 <- merge(sa34, sa56, all = TRUE)
  sa789  <- merge(sa78, lean_s2019, all = TRUE)
  # final df for VIC 13-19
  sa_6y <- merge(sa3456, sa789, all =TRUE)
############################ END OF SA DATA ################################## 
  
############################ Final merge #####################################
  
  # adding location & latitude , longitude 
  vic_6y$State <- "Victoria"
  vic_6y$long <- 144.948955
  vic_6y$lat <- -37.794048
  
  qld_6y$State <- "Queensland"
  qld_6y$long<- 153.026583
  qld_6y$lat <- -27.483962
  
  sa_6y$State <- "South Australia"
  sa_6y$long <- 138.599826
  sa_6y$lat <- -34.911363

  # conver varibales type
  vic_6y$State <- as.factor(vic_6y$State)
  
  qld_6y$State <- as.factor(qld_6y$State)
  
  sa_6y$State <- as.factor(sa_6y$State)
  
  # VIC + QLD
  vic_qld <- merge(vic_6y, qld_6y, all = TRUE)
  #au_baby$Country <- "Australia" 
  # FINAL 
  au_baby <- merge(vic_qld, sa_6y, all = TRUE)
  
  # reformat all the names to same foramati
  CapStr <- function(c) {
    c <- tolower(c)
    paste(toupper(substring(c, 1,1)), substring(c, 2), sep="", collapse=" ")
  }
  
  au_baby$Name_male <- sapply(au_baby$Name_male, CapStr)
  au_baby$Name_female <- sapply(au_baby$Name_female, CapStr)

############################ END OF Final Merge ##############################
  # Export the df to csv file
  write.csv(au_baby, "au_baby.csv")
  