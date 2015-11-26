# http://walkerke.github.io/2014/06/rcharts-pyramids/

install.packages(c('XML', 'reshape2', 'devtools', 'plyr'))
library(devtools)
install.packages("base64enc")
install_github('ramnathv/rCharts@dev')

source('https://raw.githubusercontent.com/walkerke/teaching-with-datavis/master/pyramids/rcharts_pyramids.R')

nPyramid('QA', 2014, colors = c('darkred', 'silver'))