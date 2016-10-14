library(dplyr)

# import data
NEI <- readRDS("./Exploratory Data Analysis/Course Project 2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory Data Analysis/Course Project 2/Source_Classification_Code.rds")

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

dat <- NEI %>% group_by(year) %>% summarise(totEmission = sum(Emissions, na.rm = T))

png(filename = "Plot1.png",width = 480, height = 480)
with(dat,barplot(totEmission, xlab = c("year"), ylab = c("Total PM2.5 Emissions (tons)"),
     names.arg = year, main = "Total PM2.5 Emissions by year"))
dev.off()
