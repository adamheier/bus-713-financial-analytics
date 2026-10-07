# Load the libraries
library(forecast)
library(ggplot2)

# Simple Moving Average Forecast
passengers <- ts(AirPassengers, start = c(1949, 1), frequency = 12)
passengers
# Always a good idea to first plot the data
autoplot(passengers) +
  labs(
    title = "Air Passengers",
    x = "Year",
    y = "Number of Passengers in Thousands"
  ) +
  theme_bw(base_size = 12) + 
  theme(
    plot.title = element_text(hjust = 0.5)
  ) 

# Fit a simple moving average with order 12
# order = 12 averages the last 12 months (one full year)
ma_model <- ma(passengers, order = 12)

# Forecast 12 months ahead
ma_forecast <- forecast(ma_model, h = 12)

# Plot the forecast
# autoplot() is a ggplot2-compatible plot for forecast objects
# It automatically adds confidence intervals
autoplot(ma_forecast) +
  labs(
    title    = "Simple Moving Average Forecast (order = 12)",
    x        = "Year",
    y        = "Passengers"
  ) +
  theme_minimal(base_size = 13)

# View the forecast values
print(ma_forecast)


# Exponential Smoothing Forecast using ets()
# Fit an exponential smoothing model
ets_model <- ets(passengers)

# See which model was selected and its parameters
summary(ets_model)

# Forecast 12 months ahead
ets_forecast <- forecast(ets_model, h = 12)

# Plot the forecast with confidence intervals
autoplot(ets_forecast) +
  labs(
    title    = "Exponential Smoothing Forecast (ETS)",
    x        = "Year",
    y        = "Passengers in Thousands"
  ) +
  theme_minimal(base_size = 13)

# Print the forecast values and confidence intervals
print(ets_forecast)


# Linear Regression Trend Forecast
# tslm() fits a linear regression model to a time series
regression_model <- tslm(passengers ~ trend)

# View the regression output
summary(regression_model)

# Forecast 12 months ahead
# h = 12 produces forecasts for the next 12 periods
regression_forecast <- forecast(regression_model, h = 12)

# Plot the forecast
autoplot(regression_forecast) +
  labs(
    title    = "Linear Regression Trend Forecast",
    subtitle = "Regression captures the linear trend",
    x        = "Year",
    y        = "Passengers"
  ) +
  theme_minimal(base_size = 13)

# Print the forecast
print(regression_forecast)

# Compare accuracy with the ETS model
accuracy(regression_forecast)



# Linear Regression Trend + Season Forecast
regression_model_season <- tslm(passengers ~ trend + season)

# View the regression output
summary(regression_model_season)

# Forecast 12 months ahead
# h = 12 produces forecasts for the next 12 periods
regression_forecast_season <- forecast(regression_model_season, h = 12)

# Plot the forecast
autoplot(regression_forecast_season) +
  labs(
    title    = "Linear Regression Trend and Seasonal Forecast",
    subtitle = "Regression captures the linear trend and monthly seasonal pattern",
    x        = "Year",
    y        = "Passengers"
  ) +
  theme_minimal(base_size = 13)

# Print the forecast
print(regression_forecast)

# Compare accuracy of the models
accuracy(regression_forecast)
accuracy(regression_forecast_season)
accuracy(ets_forecast)
