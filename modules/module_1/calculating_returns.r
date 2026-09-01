# install packages
install.packages(c("tidyquant", "tidyverse"))
library(tidyquant)
library(tidyverse)

# Pull in the price data
apple     <- tq_get("AAPL", from = "2000-01-01")
apple

# Plot the price data
ggplot(apple, aes(x = date, y = adjusted)) +
  geom_line() +
  labs(
    title = "Apple Adjusted Stock Price",
    x = "Date",
    y = "Adjusted Price (USD)"
  )

# Estimate returns
aapl_returns <- apple %>%
  tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "monthly",
    type = "log"  # Try changing from "log" to "arithmetic"
  )

aapl_returns

# Plot returns
ggplot(aapl_returns, aes(x = date, y = monthly.returns)) +
  geom_line() +
  labs(
    title = "Apple Monthly Returns",
    x = "Date",
    y = "Monthly Return"
  )
