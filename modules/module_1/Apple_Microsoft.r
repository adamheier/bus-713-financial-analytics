library(tidyquant)
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


