library(dplyr)
library(ggplot2)

# import data
NEI <- readRDS("./Exploratory Data Analysis/Course Project 2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory Data Analysis/Course Project 2/Source_Classification_Code.rds")

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# take combustions related sources
combsources <- c(grep("coal", SCC$Short.Name, ignore.case = TRUE))
datCoal <- SCC$SCC[combsources]
dat <- NEI[NEI$SCC %in% datCoal,]

dat <- dat %>% group_by(year) %>% summarise(totEmission = sum(Emissions, na.rm = T))

png(filename = "Plot4.png",width = 480, height = 480)
ggplot(dat, aes(x = year, y = totEmission)) + geom_point() + geom_line() +
      theme_bw() + ylab("Total Emissions of PM2.5 (tons)") + 
      ggtitle("Total Emissions of PM2.5 from coal related sources")
dev.off()