fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filedestination <- "coursera.zip"
download.file(fileurl, filedestination)
unzip(filedestination, list = FALSE) #unzip the file
unlink(filedestination) #remove the zip file after it has been unzipped

library(data.table)
skip = 66637 # 1/2/2007 starts on the following row
nrows = 60*24*2 # Minutes/hr * Hours/day * Days
a <- fread("household_power_consumption.txt", na.strings = "?", nrows = nrows, skip = skip)
## Marke sure there are no extraneous values included
a[!(V1 %in% c("1/2/2007", "2/2/2007"))]  # This should return nothing
## Create vector with current column names
oldcolnames <- names(a)
## Create vector with new column names
newcolnames <- c("date", "time", "global_active_power", "global_reactive_power", "voltage", "global_intensity", 
                 "sub_metering1", "sub_metering2", "sub_metering3")
# Change column names
setnames(a, oldcolnames, newcolnames)
# Convert time to POSIXct format by combining the date and time strings first
a[, time := as.POSIXct(strptime(paste(date, time), format = "%d/%m/%Y %H:%M:%S"))]
# Convert the date to Date format
a[, date := as.Date(date, "%d/%m/%Y")]

# Plot 3
png(filename = "plot3.png", width = 480, height = 480)
a[, plot(time, sub_metering1, type = "l", xlab = "", ylab = "Energy sub metering")]
a[, lines(time, sub_metering2, col = "red")]
a[, lines(time, sub_metering3, col = "blue")]
legend("topright", col = c("black", "red", "blue"), lty = 1, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()