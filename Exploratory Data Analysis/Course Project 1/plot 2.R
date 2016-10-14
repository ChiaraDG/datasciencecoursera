dat <- read.table("./Exploratory Data Analysis/Course Project 1/household_power_consumption.txt",header = T, 
                  sep = ";",stringsAsFactors = T, na.strings = "?")

str(dat)

dat$Date <- as.Date(dat$Date, "%d/%m/%Y")
dat$Time <- strptime(paste(dat$Date, dat$Time), "%Y-%m-%d %H:%M:%S")

# subset data
dat <- subset(dat, Date == "2007-02-01" | Date == "2007-02-02")
dim(dat)

# change language to English
Sys.setlocale("LC_TIME", "en_US")

# Plot 2
png(filename = "Plot2.png",width = 480, height = 480)
with(dat, plot(Time, Global_active_power, type = "l",
               ylab = c("Global Active Power (kilowatts)")))
dev.off()
