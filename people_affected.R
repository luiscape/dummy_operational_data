## Script for creating false operational data. 

# This script uses the following variables to determine its formula: 
# World Bank's Income Level classifimessageion. 
# Number of Reports on ReliefWeb (normalized).
# Population of the country.


# Getting the population and income level from the World Bank.
library(WDI)  # using the WDI package.
population_total <- WDI(country = 'all', 'SP.POP.TOTL', extra = TRUE)
field_operations <- read.csv('source_data/ocha_field_operation_by_status.csv')

# Population variable
latest_year <- as.numeric(summary(population_total$year)[6])
population <- subset(population_total, (year == latest_year))

# Income level factor
income_level <- c('Not classified', 'Low income', 'Lower middle income', 
            'Upper middle income', 'High income: nonOECD', 'High income: OECD')
in_factor <- c(8, 8, 6, 4, 2, 0)
income_factor <- data.frame(income_level, in_factor)

# Operation factor
op_status <- c('Closing', 'Downsizing', 'Ongoing', 'Startup / Increasing')
op_factor <- c(1, 1.1, 1.2, 1.3)
operation_factor <- data.frame(op_status, op_factor)

# ReliefWeb factor.
rw <- read.csv('source_data/rw-value.csv')
rw <- rw[rw$indID == 'RW001', ]
source('rw_normalize.R')
rw <- rwNormalize()

rw_data <- data.frame(rw$region, rw$value, rw$period, rw$normalized)
names(rw_data) <- c('iso3', 'rw_value', 'rw_period', 'rw_normalized')


###########################
## Preparing the dataset ##
###########################

ope_list <- field_operations$ISO3

x <- population[which(population$iso3c %in% ope_list), ]
pop_data <- data.frame(x$iso3c, x$SP.POP.TOTL, x$income)
names(pop_data) <- c('iso3', 'population', 'income_level')

# Merging final equation data.
a <- merge(pop_data, income_factor, by = "income_level")
eq_data <- merge(rw_data, a, by = 'iso3')


## Equation ##
# Calculating the Number of People Affected
for (i in 1:nrow(eq_data)) {
    if (i == 1) { 
        aff <- round(eq_data$population[i]*(eq_data$in_factor[i]*eq_data$rw_normalized[i]))
        # if all the population has been affected.
        if (aff > eq_data$population[i]) { 
            eq_data$people_affected <- eq_data$population[i]
        }
        else eq_data$people_affected <- aff
    
    }
    else { 
        aff <- round(eq_data$population[i]*(eq_data$in_factor[i]*eq_data$rw_normalized[i]))
        if (aff > eq_data$population[i]) { 
            eq_data$people_affected[i] <- eq_data$population[i]
        }
        else eq_data$people_affected[i] <- aff
    }
}

# Calculating the share of people affected
for (i in 1:nrow(eq_data)) {
    if (i == 1) { 
        eq_data$pl_affected_share <- 
        round(eq_data$people_affected[i] / eq_data$population[i], 2)
    } 
    else { 
        eq_data$pl_affected_share[i] <- 
        round(eq_data$people_affected[i] / eq_data$population[i], 2)
    }
}


# Normalizing the data for the CHD format.
people_affected <- data.frame(eq_data$iso3, eq_data$people_affected, eq_data$rw_period)
pl_affected_share <- data.frame(eq_data$iso3, eq_data$pl_affected_share, eq_data$rw_period)
names(people_affected) <- c('region', 'value', 'period')
names(pl_affected_share) <- c('region', 'value', 'period')

source('people_in_need.R')
source('people_targeted.R')
source('people_reached.R')
source('number_of_idps.R')
source('people_in_camps.R')
source('refugees.R')
source('returnees.R')

# adding CHD codes
people_in_need$indID <- 'OH010'
people_targeted$indID <- 'OH020'
people_reached$indID <- 'OH030'
number_of_idps$indID <- 'OH040'
people_in_camps$indID <- 'OH050'
refugees$indID <- 'OH060'
returnees$indID <- 'OH070'
people_affected$indID <- 'OH080'
pl_affected_share$indID <- 'OH090'

# adding dsID
people_affected$dsID <- 'dummy_data'
pl_affected_share$dsID <- 'dummy_data'

# adding source
people_affected$source <- 'dummy_source'
pl_affected_share$source <- 'dummy_source'


people_affected <- is_number(people_affected)
pl_affected_share <- is_number(pl_affected_share)

# Creating the value table
value <- rbind(people_in_need, 
               people_targeted,
               people_reached,
               people_reached,
               number_of_idps,
               people_in_camps,
               refugees,
               returnees,
               people_affected, 
               pl_affected_share)

# adding validation
source('is_number.R')
value <- is_number(value)

message('Creating the dataset table')
dsID <- 'dummy_data'
last_updated <- as.Date(Sys.time())
last_scraped <- as.Date(Sys.time())
name <- 'Dummy Data'
dtset <- data.frame(dsID, last_updated, last_scraped, name)

message('Creating indimessageor table')
indID <- c('OH010', 'OH020', 'OH030', 'OH040', 'OH050', 'OH060', 'OH070', 'OH080', 'OH090')
name <- c(
    'Number of People in Need',  # ok
    'Number of People Targeted for Assistance',  # ok
    'Number of People Reached',  # ok
    'Number of IDPs',  # ok
    'Number of People in Camps',  # ok
    'Number of Refugees',  # ok
    'Number of Returnees',  #
    'Number of People Affected',  # ok
    'Share of People Affected to the Total Population')  # ok
units <- 'Count'  # Not sure what unit I should add here.
indic <- data.frame(indID, name, units)

# storing in csv
write.csv(indic, 'source_data/op-indicator.csv', row.names = F)
write.csv(dtset, 'source_data/op-dataset.csv', row.names = F)
write.csv(value, 'source_data/op-value.csv', row.names = F)
