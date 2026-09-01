library(tidyquant)
library(tidyverse)

# Create a tibble of monthly prices
prices_tbl <- tibble(
  date  = seq.Date(from = as.Date("2024-01-01"), by = "month", length.out = 12),
  price = c(102, 105, 108, 112, 115, 118, 120, 123, 119, 121, 125, 130)
)

prices_tbl

# remember log(a/b) = log(a) - log(b)
monthly_returns_log_diff = c(NA, diff(log(prices_tbl$price))) 
monthly_returns_log_diff

prices_tbl %>% 
  mutate(monthly_returns_log_diff)

# Calculate returns using tq_transmute
returns_tbl <- prices_tbl %>%
  tq_transmute(
    select     = price,
    mutate_fun = periodReturn,
    period     = "monthly",
    type       = "log"   # or "arithmetic"
  )

returns_tbl
