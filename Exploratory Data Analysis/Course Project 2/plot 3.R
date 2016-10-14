library(dplyr)
library(ggplot2)

# import data
NEI <- readRDS("./Exploratory Data Analysis/Course Project 2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory Data Analysis/Course Project 2/Source_Classification_Code.rds")


# Of the four types of sources, which of these four sources have seen 
# decreases in emissions from 1999–2008 for Baltimore City?

dat <- NEI %>% filter(fips == "24510") %>%
      group_by(type, year) %>% summarise(totEmission = sum(Emissions, na.rm = T))

png(filename = "Plot3.png",width = 480, height = 480)
ggplot(dat, aes(x = year, y = totEmission, col = type)) + geom_point() + geom_line() +
      theme_bw() + ylab("Total Emissions of PM2.5 (tons)") + 
      ggtitle("Total Emissions of PM2.5 in Baltimore according to source type")
dev.off()