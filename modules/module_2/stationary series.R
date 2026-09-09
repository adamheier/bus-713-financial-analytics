# Example: Simulated stationary series

stationary_series <- tibble(
  
  time = 1:200,
  
  value = rnorm(200, mean = 0, sd = 1)
  
)

# Plot the data 

ggplot(stationary_series, aes(x = time, y = value)) +
  
  geom_line() +
  
  labs(
    
    title = "Example of a Stationary Time Series",
    
    x = "Time",
    
    y = "Value"
    
  ) +
  
  theme_bw()


# Example: Simulated non-stationary trend

nonstationary_series <- tibble(
  
  time = 1:200,
  
  value = time * 0.05 + rnorm(200)
  
)

# Plot the data

ggplot(nonstationary_series, aes(x = time, y = value)) +
  
  geom_line() +
  
  labs(
    
    title = "Example of a Non-Stationary Time Series",
    
    x = "Time",
    
    y = "Value"
    
  ) +
  
  theme_bw()

# Example: Random walk (no drift)

rw <- tibble(
  
  time = 1:200,
  
  value = cumsum(rnorm(200))
  
)

# Plot the data

ggplot(rw, aes(x = time, y = value)) +
  
  geom_line() +
  
  labs(
    
    title = "Random Walk (No Drift)",
    
    x = "Time",
    
    y = "Value"
    
  ) +
  
  theme_bw()


# Example: Random walk with drift

rw_drift <- tibble(
  
  time = 1:200,
  
  value = cumsum(rnorm(200) + 0.09)
  
)

# Plot the data

ggplot(rw_drift, aes(x = time, y = value)) +
  
  geom_line() +
  
  labs(
    
    title = "Random Walk with Drift",
    
    x = "Time",
    
    y = "Value"
    
  ) +
  
  theme_bw()



# Apple prices vs returns
# First, load the libraries and download Apple price data.

library(tidyquant)

library(tidyverse)

aapl <- tq_get("AAPL", from = "2000-01-01")

# Plot the data
ggplot(aapl, aes(x = date, y = adjusted)) +
  
  geom_line() +
  
  labs(
    
    title = "Apple Adjusted Stock Price",
    
    x = "Date",
    
    y = "Adjusted Price (USD)"
    
  ) +
  
  theme_bw()

# Creating returns from prices
aapl_returns <- aapl %>%
  
  tq_transmute(
    
    select = adjusted,
    
    mutate_fun = periodReturn,
    
    period = "monthly",
    
    type = "log"
    
  )

# Plot the data
ggplot(aapl_returns, aes(x = date, y = monthly.returns)) +
  
  geom_line() +
  
  labs(
    
    title = "Apple Monthly Returns",
    
    x = "Date",
    
    y = "Monthly Return"
    
  ) +
  
  theme_bw()
