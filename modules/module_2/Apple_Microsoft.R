library(tidyquant)
library(tidyverse)
library(ggplot2)

microsoft <- tq_get("MSFT", from = "2000-01-01")
apple     <- tq_get("AAPL", from = "2000-01-01")


ggplot(microsoft, aes(x = date, y = adjusted)) +
  geom_line() +
  labs(
    title = "Microsoft Adjusted Price (MSFT)",
    x = "Date",
    y = "Adjusted Price (USD)"
  ) +
  theme_bw()


ggplot(apple, aes(x = date, y = adjusted)) +
  geom_line() +
  labs(
    title = "Apple Adjusted Price (AAPL)",
    x = "Date",
    y = "Adjusted Price (USD)"
  ) +
  theme_bw()

library(dplyr)

microsoft_labeled <- microsoft %>%
  mutate(asset = "Microsoft (MSFT)")

apple_labeled <- apple %>%
  mutate(asset = "Apple (AAPL)")

stocks <- rbind(microsoft_labeled, apple_labeled)

ggplot(stocks, aes(x = date, y = adjusted, colour = asset)) +
  
  geom_line() +
  labs(
    title = "Adjusted Prices: Microsoft vs Apple",
    x = "Date",
    y = "Adjusted Price (USD)",
    colour = "Asset"
  ) +
  theme_bw()

# Microsoft monthly returns

msft_monthly_returns <- microsoft %>%
  
  tq_transmute(
    
    select = adjusted,
    
    mutate_fun = periodReturn,
    
    period = "monthly",
    
    type = "log" # change this to "arithmetic" if you want arithmetic returns (for analysis, log returns are preferrable)
    
  )

# Microsoft annual returns

msft_annual_returns <- microsoft %>%
  
  tq_transmute(
    
    select = adjusted,
    
    mutate_fun = periodReturn,
    
    period = "annual",
    
    type = "log"
    
  )


# Apple monthly returns

aapl_monthly_returns <- apple %>%
  
  tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "monthly",
    type = "log" # change to "arithmetic" as needed
  )

# Apple annual returns

aapl_annual_returns <- apple %>%
  
  tq_transmute(
    select = adjusted,
    mutate_fun = periodReturn,
    period = "annual",
    type = "log"
  )


library(tidyquant)
library(dplyr)
library(ggplot2)

aapl_monthly_returns <- apple %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "monthly", type = "log")

msft_annual_returns <- microsoft %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "yearly", type = "log")

aapl_annual_returns <- apple %>%
  tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "yearly", type = "log")

monthly_returns <- bind_rows(
  msft_monthly_returns %>% mutate(asset = "Microsoft (MSFT)"),
  aapl_monthly_returns %>% mutate(asset = "Apple (AAPL)")
)

ggplot(monthly_returns, aes(x = date, y = monthly.returns, fill = asset)) +
  geom_col(position = "dodge") +
  labs(
    title = "Monthly Log Returns: Microsoft vs. Apple",
    x = "Date",
    y = "Log Return",
    fill = "Asset"
  ) +
  theme_bw()