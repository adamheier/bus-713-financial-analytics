library(tidyverse)
library(tidyquant)

# get AAPL data
aapl_daily <- tq_get("AAPL", from = "2000-01-01")

# compute daily log returns
aapl_daily_ret <- aapl_daily %>%
    tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "daily",
    type = "log" 
    )

aapl_daily_ret

# compute VaR (the key function is quantile())
aapl_var_95 <- quantile(aapl_daily_ret$daily.returns, 0.05)
aapl_var_95

# plot the data to visualize the distribution and the VaR
ggplot(aapl_daily_ret, aes(x = daily.returns)) +
  geom_histogram(bins = 100) +
  geom_vline(xintercept = aapl_var_95, colour = "red") +
  labs(
    title = "Apple Daily Returns with 95% VaR",
    x = "Daily Return",
    y = "Frequency"
    ) +
  theme_bw()

# compute expected shortfall
aapl_es_95 <- aapl_daily_ret %>%
  filter(daily.returns <= aapl_var_95) %>%
  summarise(es = mean(daily.returns)) 

aapl_es_95
