library(readxl)
library(tidyverse)

# import the data
data <- read_xlsx("C:/Users/pvatsa/OneDrive - University of the Sunshine Coast/2025/BUS713 - Financial Analytics/capm_data.xlsx")
data

# set up the data
capm_data <- data %>%
  arrange(date) %>%
  mutate(
    # Convert annual % yield → monthly decimal
    rf = (tbill_10 / 100) / 12,
    # Monthly returns
    aapl_ret  = aapl  / lag(aapl)  - 1,
    sp500_ret = sp500 / lag(sp500) - 1,
    # Excess returns
    aapl_excess  = aapl_ret  - rf,
    sp500_excess = sp500_ret - rf
  )

# estimate the model
model <- lm(aapl_excess ~ sp500_excess, data = capm_data)
summary(model)
