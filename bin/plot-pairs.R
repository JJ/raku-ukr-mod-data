library(reshape2)

data = read.csv("resources/ukr-mod-data.csv")
data.totals <- subset( data, select=-c(Delta))
data.totals$Date <- as.Date( paste0("2022.",data.totals$Date), format="%Y.%d.%m")
data.shaped <- dcast(data.totals, Date ~ Item )
pairs(data.shaped)