# Import data previously downloaded
dat <- read.table("household_power_consumption.txt",header = T, 
                  sep = ";",stringsAsFactors = T, na.strings = "?")

str(dat)

dat$Date <- as.Date(dat$Date, "%d/%m/%Y")
dat$Time <- strptime(paste(dat$Date, dat$Time), "%Y-%m-%d %H:%M:%S")

# subset data
dat <- subset(dat, Date == "2007-02-01" | Date == "2007-02-02")
dim(dat)

# change language to English
Sys.setlocale("LC_TIME", "en_US")

# plot 3
png(filename = "Plot3.png",width = 480, height = 480)
with(dat, plot(Time, Sub_metering_1, type = "l",
               ylab = c("Energy sub metering"),xlab = ""))
with(dat, lines(Time, Sub_metering_2, type = "l",col = "red"))
with(dat, lines(Time, Sub_metering_3, type = "l",col = "blue"))
legend("topright", c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       col =c("black","red","blue"), lty = c(1,1,1))
dev.off()
