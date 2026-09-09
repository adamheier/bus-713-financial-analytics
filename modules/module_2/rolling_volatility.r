library(tidyquant)
library(tidyverse)

# Download daily price data for Pfizer since 2010
pfe <- tq_get("PFE", from = "2010-01-01")

# Calculate daily returns
pfe_daily_ret <- pfe %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn,
               period = "daily", type = "log")

# 30-day rolling volatility (rolling standard deviation of daily returns)
pfe_vol <- pfe_daily_ret %>%
  tq_mutate(
    select     = daily.returns,
    mutate_fun = rollapply,
    width      = 30,
    FUN        = sd,
    na.rm      = TRUE,
    col_rename = "roll_vol_30"
  )

# Plot it
ggplot(pfe_vol, aes(x = date, y = roll_vol_30)) +
  geom_line() +
  labs(title = "30-Day Rolling Volatility for PFE", x = "", y = "Rolling SD of Daily Returns") +
  theme_bw()
