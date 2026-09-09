library(tidyquant)
library(tidyverse)

apple     <- tq_get("AAPL", from = "2000-01-01") # obtain the data on AAPL
apple

# calculate returns
aapl_returns <- apple %>%
  tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "monthly",
    type = "log"
  )

aapl_returns

# calculate mean and standard deviation
aapl_summary <- aapl_returns %>%
  summarise(
    mean_return = mean(monthly.returns),
    volatility  = sd(monthly.returns)
  )

aapl_summary

# now repeat for Miscrosoft
microsoft <- tq_get("MSFT", from = "2000-01-01") # obtain the data on MSFT
microsoft

msft_returns <- microsoft %>%
  tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "monthly",
    type = "log"
  )

msft_returns

msft_summary <- msft_returns %>%
  summarise(
    mean_return = mean(monthly.returns),
    volatility  = sd(monthly.returns)
  )

msft_summary

# combine the information for comparison
comparison <- data.frame(
  asset = c("Apple (AAPL)", "Microsoft (MSFT)"),
  mean_return = c(
    mean(aapl_returns$monthly.returns),
    mean(msft_returns$monthly.returns)
    ),
  volatility = c(
    sd(aapl_returns$monthly.returns),
    sd(msft_returns$monthly.returns)
    )
  )

comparison
