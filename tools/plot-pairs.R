library(reshape2)
library(GGally)
library(dplyr)
library(arrow)
library(ggplot2)
library(ggthemes)

data = read.csv("resources/ukr-mod-data.csv")
data.totals <- subset( data, select=-c(Delta))
data.totals$Date <- as.Date( paste0("2022.",data.totals$Date), format="%Y.%d.%m")
totals.shaped <- dcast(data.totals, Date ~ Item )

ggplot( totals.shaped, aes(x=Date,y=` tanks`, color=` APV`))+geom_point()+theme_economist()
ggsave("assets/tank-apv-evolution.png")
data.delta <- subset( data, select=-c(Total))
data.delta$Date <- as.Date( paste0("2022.",data.delta$Date), format="%Y.%d.%m")
delta.shaped <- dcast(data.delta, Date ~ Item )
delta.clean <- delta.shaped
delta.clean$` cruise missiles` <- NULL
delta.clean$` warships / boats` <- NULL
delta.clean <- delta.clean %>% slice(2:n())
delta.clean$Losses <- c((delta.clean %>% slice(2:n()))$` personnel`,0)
png("assets/delta-correlation-plot.png", height = 2048, width = 2048)
g <- ggpairs(delta.clean,columns=2:13, upper = list(continuous = wrap("cor", size = 14)) )
print(g)
dev.off()
ggplot( delta.clean, aes(y=` personnel`,x=` APV`, color=` tanks`))+geom_point()+theme_economist()
ggsave("assets/apv-personnel-tank-correlation.png")
write.csv(delta.clean, "resources/ukr-mod-deltas.csv")
write_parquet(delta.clean, "resources/ukr-mod-deltas.parquet")
write_feather(delta.clean, "resources/ukr-mod-deltas.feather")

scaled.columns <- names(delta.clean)[2:12]
delta.scaled <- delta.clean %>% mutate_at(scaled.columns, ~(scale(.) %>% as.vector))
delta.scaled$Losses <- NULL
row.names(delta.scaled) <- delta.scaled$Date
delta.scaled$Date <- NULL
write.csv(delta.scaled, "resources/ukr-mod-deltas-scaled.csv")
