## plotting results
library(ggplot2)

# Afghanistan
base <- ggplot(pl_affected_share[pl_affected_share$region == 'AFG', ]) + theme_bw()
base + geom_line(aes(period, value, group = region), color = "#0988bb", size = 1.3)

# Haiti
base <- ggplot(pl_affected_share[pl_affected_share$region == 'HTI', ]) + theme_bw()
base + geom_line(aes(period, value, group = region), color = "#ce554d", size = 1.3)
