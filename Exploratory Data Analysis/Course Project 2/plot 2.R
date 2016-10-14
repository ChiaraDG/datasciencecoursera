library(dplyr)

# import data
NEI <- readRDS("./Exploratory Data Analysis/Course Project 2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory Data Analysis/Course Project 2/Source_Classification_Code.rds")

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland?

dat <- NEI %>% filter(fips == "24510") %>%
      group_by(year) %>% summarise(totEmission = sum(Emissions, na.rm = T))

png(filename = "Plot2.png",width = 480, height = 480)
with(dat,barplot(totEmission, xlab = c("year"), ylab = c("Total PM2.5 Emissions (tons) in Baltimore"),
                 names.arg = year, main = "Total PM2.5 Emissions by year"))
dev.off()
