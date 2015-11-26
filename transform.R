library(dplyr)
library(rCharts)
library(ggplot2)

setwd("~/R/netflow-dev")
list.files()

df = read.csv("testdata-epoch.csv",stringsAsFactors = FALSE)

head(df)

df$startTime <- as.POSIXct(df$sTime,origin="1970-01-01")
df$startHour <- format(strptime(df$startTime, "%Y-%m-%d %H:%M:%OS"),"%H")
df$startDate <- format(strptime(df$startTime, "%Y-%m-%d %H:%M:%OS"),"%Y-%m-%d")

countByHour <- df %>%
  group_by(startDate,startHour) %>%
  summarise(n=n()) %>%
  ungroup() %>%
  group_by(startHour) %>%
  summarise(count=sum(n),
            std=sd(n)) %>%
  mutate(lcl=count-2*std,
         ucl=count+2*std)

countByHour

p6 <- nPlot(count ~ startHour, data = countByHour, type = 'lineChart')
p6

ggplot(countByHour, aes(x=startHour, y=count)) + 
  geom_errorbar(aes(ymin=lcl, ymax=ucl), width=.1) +
  geom_line() +
  geom_point()


  
  