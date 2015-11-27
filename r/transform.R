library(dplyr)    # data munging package
library(rCharts)  # api to d3.js plots
library(ggplot2)  # png image plots
library(ggthemes) # predefined themes for ggplot, see https://github.com/jrnold/ggthemes

setwd("~/R/netflow-dev")
#setwd("~/Documents/Code/netflow-dev/data/")
list.files()

df = read.csv("testdata-epoch.csv",stringsAsFactors = FALSE)

head(df)

df$startTime <- as.POSIXct(df$sTime,origin="1970-01-01")
df$startHour <- format(strptime(df$startTime, "%Y-%m-%d %H:%M:%OS"),"%H")
df$startDate <- format(strptime(df$startTime, "%Y-%m-%d %H:%M:%OS"),"%Y-%m-%d")

table(df$startDate)

today <- "2015-10-26"

# summarized historical data to create the baseline avg and confidence intervals
countByHour <- df %>%
  filter(startDate < today) %>% #in-time hold out
  group_by(startDate,startHour) %>%
  #summarise(n=sum(packets)) %>%
  summarise(n=n()) %>%
  ungroup() %>%
  group_by(startHour) %>%
  summarise(count=sum(n),
            std=sd(n)) %>%
  mutate(lcl=count-2*std,
         ucl=count+2*std)

countByHour

# summarizes todays today 
countByHourHoldOut <- df %>%
  filter(startDate >= today) %>% #in-time hold out
  group_by(startDate,startHour) %>%
  #summarise(n=sum(packets)) %>%
  summarise(n=n()) %>%
  ungroup() %>%
  group_by(startHour) %>%
  summarise(count=sum(n))


# rChart with no std
p6 <- nPlot(count ~ startHour, data = countByHour, type = 'lineChart')
p6

# ggplot with 2 std
ggplot(countByHour, aes(x=startHour, y=count, group=1)) + 
  geom_errorbar(aes(ymin=lcl, ymax=ucl), width=.1) +
  geom_line() +
  geom_point()

# ggplot with confidence interval bands
ggplot(countByHour, aes(x=startHour, y=count,group=1)) + 
  geom_ribbon(aes(ymin=lcl, ymax=ucl), alpha=0.3) +
  geom_line() +
  geom_point(data=countByHourHoldOut,aes(x=startHour, y=count)) +
  geom_line(data=countByHourHoldOut,aes(x=startHour, y=count),colour = 'darkblue', size = 2) +
  xlab("Time of Day (Hours)") + 
  ylab("Count") +
  ggtitle("Traffic Count Relative to Baseline") + 
  theme_economist() + # see https://github.com/jrnold/ggthemes
  scale_colour_economist()  # see https://github.com/jrnold/ggthemes

  
  