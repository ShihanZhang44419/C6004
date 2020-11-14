library(tidyverse)
library(ggplot2)

# load timestamp data
timestamp <- read.csv("C:/Users/SENMS/Desktop/tunnel/timestamp.txt")

timestamp <- strptime(timestamp$posted_at, format = "%Y-%m-%d %H:%M:%S", tz ="")

hist(x = timestamp, breaks = "month", freq = TRUE, ylim = range(0:1000))


BQ3 <- read_csv("C:/Users/SENMS/Desktop/tunnel/BQ3.txt")


ggplot(BQ3, aes(shares_count, likes_count)) + geom_point() + geom_smooth()


ggplot(BQ3, aes(shares_count, likes_count)) + geom_point() + geom_smooth(method = lm)


lean_BQ3 <- subset(BQ3, shares_count < 7500)

ggplot(lean_BQ3, aes(shares_count, likes_count)) + geom_point() + geom_smooth(method = lm)

ggplot(lean_BQ3, aes(shares_count, likes_count)) + geom_point()  + stat_smooth(method="lm", se=TRUE, fill=NA,
                                                                               formula=y ~ poly(x, 3, raw=TRUE))

var(lean_BQ3$shares_count)
var(lean_BQ3$likes_count)


linear_model = lm(formula = BQ3$likes_count ~ BQ3$shares_count, data = BQ3)

Share_for_predict <- data.frame(c(0,100,1000,10000,100000))

predict(linear_model, newdata = Share_for_predict)

