library(tidyverse)
library(tidyquant)

# get the MSFT data
microsoft <- tq_get("MSFT", from = "2000-01-01")
microsoft
# pull the starting value
msft_start <- microsoft$adjusted[1]
msft_start

# pull the ending value
msft_end   <- microsoft$adjusted[nrow(microsoft)]
msft_end

# pull the start date
msft_start_date <- microsoft$date[1]
msft_start_date

# pull the end date
msft_end_date   <- microsoft$date[nrow(microsoft)]
msft_end_date

# convert to number of year
msft_years <- as.numeric(difftime(msft_end_date, msft_start_date, units = "days")) / 365.25
msft_years

# calculate CAGR
msft_cagr <- (msft_end / msft_start)^(1 / msft_years) - 1
msft_cagr
