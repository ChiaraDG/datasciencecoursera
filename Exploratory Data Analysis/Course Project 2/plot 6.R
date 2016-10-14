library(dplyr)
library(ggplot2)

# import data
NEI <- readRDS("./Exploratory Data Analysis/Course Project 2/summarySCC_PM25.rds")
SCC <- readRDS("./Exploratory Data Analysis/Course Project 2/Source_Classification_Code.rds")

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
# Los Angeles County, California.í¿¼ðŸ¶ðŸ¹ðŸ½"). Which city has seen greater changes over time in motor vehicle emissions?

dat <- NEI %>% filter(fips == "24510" | fips == "06037") %>%
      group_by(fips, type, year) %>% summarise(totEmission = sum(Emissions, na.rm = T)) %>%
      filter(type == "ON-ROAD")

dat$fips <- factor(dat$fips)
levels(dat$fips) <- c("LA County", "Baltimore") 
dat$year <- factor(dat$year)

png(filename = "Plot6.png",width = 480, height = 480)
ggplot(dat, aes(x = year, y = totEmission, fill = fips)) + geom_bar(stat = "identity") +
      theme_bw() + ylab("Total Emissions of PM2.5 (tons)") + 
      ggtitle("Total Emissions of PM2.5 from vehicle") + facet_wrap(~fips, scales = "free")
dev.off()