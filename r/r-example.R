setwd("~/Documents/Code/netflow-dev/r/")
getwd()
list.files()
df = read.csv(file="../data/testdata.csv",stringsAsFactors = FALSE)

library(dplyr)

customfunction <- function(x) {
  y = x*2
  return(y)
}

topsIP = df %>% group_by(sIP) %>%
  summarise("n"=n()) %>%
  filter(n>3) %>% 
  mutate("n2"=customfunction(n)) 

sIPtype = df %>% group_by(sIP,type) %>% 
  summarise(m=n()) %>%
  ungroup() %>%
  left_join(topsIP,by="sIP")

r1 <- rPlot(n ~ m | sIP, data = sIPtype, type = "point", color = "gear")
r1
  