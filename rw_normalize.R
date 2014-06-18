# Script to normalie RW data per year. 
# In this particular version 2014 has the same values as 2013.

rwNormalize <- function(df = rw) { 
    years <- unique(rw$period)
    for (i in 1:length(years)) {
        rw_sub <- rw[rw$period == years[i], ]
        for (j in 1:nrow(rw_sub)) {
            if (j == 1) rw_sub$normalized <- rw_sub$value[j] / sum(rw_sub$value)
            else rw_sub$normalized[j] <- rw_sub$value[j] / sum(rw_sub$value)
        }
        if (years[i] == 2014) { 
            rw_sub <- rw[rw$period == 2013, ]
            rw_sub$normalized[j] <- rw_sub$value[j] / sum(rw_sub$value)
            rw_sub$period <- 2014
        }
        if (i == 1) z <- rw_sub
        else z <- rbind(rw_sub, z)
    }
    z
}