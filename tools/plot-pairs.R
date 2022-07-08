library(reshape2)
library(GGally)
library(dplyr)
library(arrow)
data = read.csv("resources/ukr-mod-data.csv")
data.totals <- subset( data, select=-c(Delta))
data.totals$Date <- as.Date( paste0("2022.",data.totals$Date), format="%Y.%d.%m")
totals.shaped <- dcast(data.totals, Date ~ Item )

data.delta <- subset( data, select=-c(Total))
data.delta$Date <- as.Date( paste0("2022.",data.delta$Date), format="%Y.%d.%m")
delta.shaped <- dcast(data.delta, Date ~ Item )
delta.clean <- delta.shaped
delta.clean$` cruise missiles` <- NULL
delta.clean$` warships / boats` <- NULL
delta.clean <- delta.clean %>% slice(2:n())
delta.clean$Losses <- c((delta.clean %>% slice(2:n()))$` personnel`,0)
png("assets/delta-correlation-plot.png", height = 2048, width = 2048)
g <- ggpairs(delta.clean,columns=2:12, upper = list(continuous = wrap("cor", size = 14)) )
print(g)
dev.off()
write.csv(delta.clean, "resources/ukr-mod-deltas.csv")
write_parquet(delta.clean, "resources/ukr-mod-deltas.parquet")
write_feather(delta.clean, "resources/ukr-mod-deltas.feather")

