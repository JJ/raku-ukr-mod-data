library(reshape2)
library(GGally)

data = read.csv("resources/ukr-mod-data.csv")
data.totals <- subset( data, select=-c(Delta))
data.totals$Date <- as.Date( paste0("2022.",data.totals$Date), format="%Y.%d.%m")
totals.shaped <- dcast(data.totals, Date ~ Item )

data.delta <- subset( data, select=-c(Total))
data.delta$Date <- as.Date( paste0("2022.",data.delta$Date), format="%Y.%d.%m")
delta.shaped <- dcast(data.delta, Date ~ Item )
png("assets/delta-correlation-plot.png", height = 2048, width = 2048)
g <- ggpairs(delta.shaped,columns=2:12)
print(g)
dev.off()

