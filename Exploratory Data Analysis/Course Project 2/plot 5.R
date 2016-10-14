library(dplyr)
library(ggplot2)

# import data
NEI <- readRDS("./Exploratory Data Analysis/Course Project 2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory Data Analysis/Course Project 2/Source_Classification_Code.rds")

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

dat <- NEI %>% filter(fips == "24510" & type == "ON-ROAD") %>%
      group_by(type, year) %>% summarise(totEmission = sum(Emissions, na.rm = T))

png(filename = "Plot5.png",width = 480, height = 480)
ggplot(dat, aes(x = year, y = totEmission)) + geom_point() + geom_line() +
      theme_bw() + ylab("Total Emissions of PM2.5 (tons)") + 
      ggtitle("Total Emissions of PM2.5 from vehicle sources in Baltimore")
dev.off()
      