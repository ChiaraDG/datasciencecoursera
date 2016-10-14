# Import data previously downloaded
dat <- read.table("household_power_consumption.txt",header = T, 
                  sep = ";",stringsAsFactors = T, na.strings = "?")

str(dat)

dat$Date <- as.Date(dat$Date, "%d/%m/%Y")
dat$Time <- strptime(paste(dat$Date, dat$Time), "%Y-%m-%d %H:%M:%S")

# subset data
dat <- subset(dat, Date == "2007-02-01" | Date == "2007-02-02")
dim(dat)

# Plot 4
png(filename = "Plot4.png",width = 480, height = 480)

par(mfrow = c(2,2))

plot(dat$Time,dat$Global_active_power,type = "l", ylab = "Global Active Power (kilowatts)")

plot(dat$Time,dat$Voltage,type = "l", xlab = "datetime", ylab = "Voltage")

plot(dat$Time,dat$Sub_metering_1, ylab = "Energy sub meetering", type = "l")
lines(dat$Time,dat$Sub_metering_2, col = "red")
lines(dat$Time,dat$Sub_metering_3, col = "blue")
legend("topright",paste("Sub_metering", c(1:3), sep = "_"), border = NA, cex = 0.75,
       lty = c(1,1,1), col = c("black","red","blue"),bty = "n")

plot(dat$Time,dat$Global_reactive_power,type = "l", ylab = "Global_reactive_power", xlab = "datetime")

dev.off()
