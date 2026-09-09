library(tidyverse)
library(tidyquant)

aapl_daily <- tq_get("AAPL", from = "2000-01-01")

aapl_daily_ret <- aapl_daily %>%
    tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "daily",
    type = "arithmetic"
    )

aapl_daily_ret

# Plot daily returns
ggplot(aapl_daily_ret, aes(x = date, y = daily.returns)) +
  geom_line() +
  labs(
    title = "Apple Daily Returns",
    x = "Date",
    y = "Daily Return"
    ) +
  theme_bw()

library(lubridate)

aapl_monthly_vol <- aapl_daily_ret %>%
  mutate(month = floor_date(date, unit = "month")) %>%
  group_by(month) %>%
  summarise(
    vol_month = sd(daily.returns)
    )

aapl_monthly_vol

#Plot monthly realised volatility
ggplot(aapl_monthly_vol, aes(x = month, y = vol_month)) +
  geom_line() +
  labs(
    title = "Apple Monthly Realised Volatility",
    x = "Month",
    y = "Monthly Volatility"
    ) +
  theme_bw()

# Create squared returns
aapl_daily_ret <- aapl_daily_ret %>%
  mutate(sq_return = daily.returns^2)

ggplot(aapl_daily_ret, aes(x = date, y = sq_return)) +
  geom_line() +
  labs(
    title = "Apple Squared Daily Returns",
    x = "Date",
    y = "Squared Return"
    ) +
    theme_bw()

# Plot the ACF
library(forecast)

Acf(aapl_daily_ret$sq_return, na.action = na.omit)
