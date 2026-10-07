# =============================================================================
# BUS 713 Financial Analytics - Assessment 2
# Predictive Modelling and Portfolio Evaluation

# Question 1: NVIDIA (NVDA) and Intel (INTC) against the Nasdaq Composite
#             beta, CAPM, Security Market Line, correlation, price forecast
# Question 2: NPV and IRR of a five-year project, Monte Carlo simulation

# Data: monthly prices from Yahoo Finance, October 2021 - September 2026
#       (60 months, the standard window for estimating beta)

# Structure
#   1. Data: monthly prices and the risk-free rate
#   2. Beta: CAPM regression
#   3. CAPM expected return and the Security Market Line
#   4. How reliable are these results?
#   5. Correlation and diversification
#   6. Six-month price forecast for Intel
#   7. Project base case: NPV and IRR
#   8. Project uncertainty: Monte Carlo simulation
# =============================================================================

# install.packages(c("tidyquant", "tidyverse", "forecast", "FinCal"))

library(tidyquant)   # tq_get() for prices and the 10-year Treasury yield
library(tidyverse)   # data handling and ggplot2
library(forecast)    # ets(), tslm(), forecast(), accuracy()
library(FinCal)      # npv() and irr()

dir.create("output", showWarnings = FALSE) 


# =============================================================================
# QUESTION 1
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Data: monthly prices and the risk-free rate
# -----------------------------------------------------------------------------

# ^TNX is the 10-year US Treasury yield in percent. Downloading it from Yahoo
# keeps all data in one source.
daily <- tq_get(c("NVDA", "INTC", "^IXIC", "^TNX"),
                from = "2021-09-01", to = "2026-09-30")

# Keep the last observation of each month. September 2021 is only needed as
# the starting price for the first monthly return.
monthly <- daily %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(symbol, month) %>%
  summarise(adjusted = last(adjusted), close = last(close), .groups = "drop")

# One row per month, one column per asset.
# "adjusted" includes dividends and splits, so returns are what investors earned.
capm_data <- monthly %>%
  select(symbol, month, adjusted) %>%
  pivot_wider(names_from = symbol, values_from = adjusted) %>%
  rename(nvda = NVDA, intc = INTC, nasdaq = `^IXIC`, tbill_10 = `^TNX`) %>%
  arrange(month) %>%
  mutate(
    rf            = (tbill_10 / 100) / 12,     # annual % yield -> monthly decimal
    nvda_ret      = nvda   / lag(nvda)   - 1,  # monthly returns
    intc_ret      = intc   / lag(intc)   - 1,
    nasdaq_ret    = nasdaq / lag(nasdaq) - 1,
    nvda_excess   = nvda_ret   - rf,           # excess returns over the risk-free rate
    intc_excess   = intc_ret   - rf,
    nasdaq_excess = nasdaq_ret - rf
  ) %>%
  drop_na()

stopifnot(nrow(capm_data) == 60)
nrow(capm_data)   # 60 monthly observations


# -----------------------------------------------------------------------------
# 2. Beta: CAPM regression
# -----------------------------------------------------------------------------

# Stock excess return regressed on market excess return:
#   slope     = beta, the stock's sensitivity to the market (systematic risk)
#   intercept = alpha, the return the CAPM does not explain
#   R-squared = share of the stock's movements explained by the market
nvda_model <- lm(nvda_excess ~ nasdaq_excess, data = capm_data)
intc_model <- lm(intc_excess ~ nasdaq_excess, data = capm_data)

summary(nvda_model)
summary(intc_model)

# Beta, alpha and R-squared as numbers, taken directly from the fitted models
capm_stats <- tibble(
  stock = factor(c("NVIDIA", "Intel"), levels = c("NVIDIA", "Intel")),
  model = list(nvda_model, intc_model)
) %>%
  mutate(
    alpha = map_dbl(model, ~ coef(.x)[["(Intercept)"]]),
    beta  = map_dbl(model, ~ coef(.x)[["nasdaq_excess"]]),
    r2    = map_dbl(model, ~ summary(.x)$r.squared),
    label = sprintf("Beta = %.2f\nAlpha = %.2f%% / month\nR-squared = %.2f",
                    beta, alpha * 100, r2)
  )

capm_stats %>% select(stock, alpha, beta, r2)   # numbers in the console

# Each point is one month; the slope of the black line is beta
p_capm <- capm_data %>%
  select(month, nasdaq_excess, NVIDIA = nvda_excess, Intel = intc_excess) %>%
  pivot_longer(c(NVIDIA, Intel), names_to = "stock", values_to = "stock_excess") %>%
  mutate(stock = factor(stock, levels = c("NVIDIA", "Intel"))) %>%
  ggplot(aes(x = nasdaq_excess, y = stock_excess)) +
  geom_point(aes(colour = stock), alpha = 0.7) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, colour = "black") +
  geom_text(data = capm_stats,
            aes(x = min(capm_data$nasdaq_excess), y = Inf, label = label),
            hjust = 0, vjust = 1.3, size = 3.5, inherit.aes = FALSE) +
  facet_wrap(~ stock) +
  scale_x_continuous(labels = scales::percent) +
  scale_y_continuous(labels = scales::percent) +
  labs(title    = "CAPM regression: monthly excess returns, Oct 2021 - Sep 2026",
       subtitle = "The slope of the black line is beta",
       x = "Nasdaq excess return", y = "Stock excess return") +
  theme_bw() +
  theme(legend.position = "none")

p_capm
ggsave("output/01_capm_regression.png", plot = p_capm, width = 9, height = 4.5, dpi = 150)


# -----------------------------------------------------------------------------
# 3. CAPM expected return and the Security Market Line
# -----------------------------------------------------------------------------

# Inputs are annualised averages over the same 60 months:
#   risk-free rate      = average 10-year yield
#   market risk premium = average Nasdaq return minus the risk-free rate
# Using the regression window puts the Nasdaq exactly on the SML, so a stock's
# distance from the line equals its annualised alpha.
rf_annual  <- mean(capm_data$rf) * 12
mrp_annual <- mean(capm_data$nasdaq_ret) * 12 - rf_annual

rf_today <- last(capm_data$tbill_10) / 100   # 10-year yield at the end of Sep 2026

capm_table <- tibble(
  stock    = factor(c("NVIDIA", "Intel", "Nasdaq"), levels = c("NVIDIA", "Intel", "Nasdaq")),
  beta     = unname(c(coef(nvda_model)[2], coef(intc_model)[2], 1)),
  realised = c(mean(capm_data$nvda_ret), mean(capm_data$intc_ret),
               mean(capm_data$nasdaq_ret)) * 12
) %>%
  mutate(
    capm_expected = rf_annual + beta * mrp_annual,   # CAPM: rf + beta x MRP
    alpha         = realised - capm_expected,        # distance from the SML
    position      = case_when(stock == "Nasdaq" ~ "on the SML (market)",
                              alpha > 0 ~ "above SML: undervalued",
                              TRUE      ~ "below SML: overvalued"),
    # Sensitivity: the historical premium reflects an unusually strong five
    # years. With today's 10-year yield and a long-run premium of 5%:
    capm_forward  = rf_today + beta * 0.05
  )

rf_annual
mrp_annual
capm_table

# The SML with each asset's realised return; dashed lines show the alpha
p_sml <- ggplot(capm_table, aes(x = beta, y = realised)) +
  geom_abline(intercept = rf_annual, slope = mrp_annual, colour = "grey40") +
  geom_segment(aes(xend = beta, yend = capm_expected), linetype = "dashed") +
  geom_point(aes(colour = stock), size = 4) +
  geom_text(aes(label = stock), vjust = -1.2) +
  scale_y_continuous(labels = scales::percent) +
  expand_limits(x = c(0, 2.5), y = c(0, 0.7)) +
  labs(title    = "Security Market Line, Oct 2021 - Sep 2026",
       subtitle = "Above the line: more return than beta justifies (undervalued under the CAPM)",
       x = "Beta", y = "Average annual return") +
  theme_bw() +
  theme(legend.position = "none")

p_sml
ggsave("output/02_security_market_line.png", plot = p_sml, width = 8, height = 5, dpi = 150)


# -----------------------------------------------------------------------------
# 4. How reliable are these results? 
# -----------------------------------------------------------------------------

# If the CAPM held exactly, every alpha would be zero. Two checks show how much
# confidence the betas and the SML positions deserve.

# 95% confidence intervals: how precisely is each beta estimated?
confint(nvda_model)
confint(intc_model)

# Which month is Intel's largest excess return?
outlier_month <- capm_data %>%
  slice_max(intc_excess, n = 1) %>%
  select(month, intc_ret, nasdaq_ret)
outlier_month

# Robustness: Intel's beta, alpha and R-squared without that single month
intc_model_wo <- lm(intc_excess ~ nasdaq_excess,
                    data = filter(capm_data, month != outlier_month$month))

tibble(
  model = c("with extreme month", "without extreme month"),
  beta  = c(coef(intc_model)[["nasdaq_excess"]], coef(intc_model_wo)[["nasdaq_excess"]]),
  alpha = c(coef(intc_model)[["(Intercept)"]],   coef(intc_model_wo)[["(Intercept)"]]),
  r2    = c(summary(intc_model)$r.squared,       summary(intc_model_wo)$r.squared)
)


# -----------------------------------------------------------------------------
# 5. Correlation and diversification
# -----------------------------------------------------------------------------

cor(capm_data$nvda_ret, capm_data$intc_ret)

# Does holding both reduce risk? A 50/50 portfolio against each stock alone.
# Volatility measures total risk; beta measures the part diversification cannot remove.
portfolio_ret <- 0.5 * capm_data$nvda_ret + 0.5 * capm_data$intc_ret

tibble(
  asset      = c("NVIDIA", "Intel", "50/50 portfolio", "Nasdaq"),
  volatility = c(sd(capm_data$nvda_ret), sd(capm_data$intc_ret),
                 sd(portfolio_ret), sd(capm_data$nasdaq_ret)) * sqrt(12),
  beta       = c(capm_table$beta[1], capm_table$beta[2],
                 mean(capm_table$beta[1:2]), 1)
)


# -----------------------------------------------------------------------------
# 6. Six-month price forecast for Intel
# -----------------------------------------------------------------------------

# Monthly closing price - the price the portfolio manager actually sees
intc_price <- monthly %>%
  filter(symbol == "INTC", month >= as.Date("2021-10-01")) %>%
  pull(close) %>%
  ts(start = c(2021, 10), frequency = 12)

# Step 1: test two methods on six months they have not seen (hold-out).
# Training: Oct 2021 - Mar 2026 (54 months). Test: Apr - Sep 2026 (6 months).
train <- window(intc_price, end = c(2026, 3))
test  <- window(intc_price, start = c(2026, 4))

# ETS on log prices (lambda = 0) versus a straight-line trend
ets_test   <- forecast(ets(train, lambda = 0), h = 6)
trend_test <- forecast(tslm(train ~ trend), h = 6)

# Real prices next to both forecasts for the six hidden months
holdout <- tibble(
  month  = seq(as.Date("2026-04-01"), by = "month", length.out = 6),
  actual = as.numeric(test),
  ets    = as.numeric(ets_test$mean),
  trend  = as.numeric(trend_test$mean)
)
round(holdout[, -1], 1) %>% bind_cols(month = holdout$month, .)

# Test-set error of each method: RMSE in USD, MAPE in percent (lower is better)
rbind(ETS   = accuracy(ets_test, test)["Test set", c("RMSE", "MAPE")],
      Trend = accuracy(trend_test, test)["Test set", c("RMSE", "MAPE")])

# Step 2: refit ETS on all 60 months and forecast six months ahead.
# lambda = 0 models log prices: price changes are proportional, and the
# forecast interval cannot fall below zero.
intc_ets      <- ets(intc_price, lambda = 0)
intc_forecast <- forecast(intc_ets, h = 6)

intc_ets$par["alpha"]   # smoothing parameter: close to 1 = random walk (last price)
intc_forecast

# For comparison: what a straight-line trend would predict
round(forecast(tslm(intc_price ~ trend), h = 6)$mean, 2)

p_forecast <- autoplot(intc_forecast) +
  labs(title    = "Intel: six-month forecast of the monthly closing price (ETS)",
       subtitle = "Forecast is flat; the 80% and 95% intervals show how uncertain it is",
       x = "", y = "Closing price (USD)") +
  theme_bw()

p_forecast
ggsave("output/03_intel_forecast.png", plot = p_forecast, width = 9, height = 5, dpi = 150)

# Hedging is discussed in the presentation.
# Its inputs come from above: Intel's R-squared (section 2), its volatility
# (section 5) and the forecast interval (section 6).


# =============================================================================
# QUESTION 2
# =============================================================================

# -----------------------------------------------------------------------------
# 7. Project base case: NPV and IRR
# -----------------------------------------------------------------------------

outlay  <- 500000
revenue <- 200000
cost    <- 100000
years   <- 5
r       <- 0.10   # assumption of the firms required return ("hurdle rate")

cf <- c(-outlay, rep(revenue - cost, years))
cf

npv(r = r, cf = cf)
irr(cf)

# The decision does not depend on the 10%: NPV is negative at any positive rate
sapply(c(0, 0.05, 0.08, 0.10, 0.12), function(rate) npv(r = rate, cf = cf))

# Break-even points at 10%: what would have to change for NPV = 0?
annuity_factor <- sum(1 / (1 + r)^(1:years))
outlay / annuity_factor + cost        # annual revenue needed, costs unchanged
(revenue - cost) * annuity_factor     # maximum outlay the cash flows can justify


# -----------------------------------------------------------------------------
# 8. Project uncertainty: Monte Carlo simulation
# -----------------------------------------------------------------------------

# Revenue and costs are drawn for every year from normal distributions.
# Revenue is more uncertain (sd 15%) than costs (sd 10%): demand and prices are
# set by the market, while most costs are under the firm's control.
set.seed(713)   # makes the simulation reproducible
n_sim <- 10000

sim_npv <- replicate(n_sim, {
  revenue_sim <- rnorm(years, mean = revenue, sd = 0.15 * revenue)
  cost_sim    <- rnorm(years, mean = cost,    sd = 0.10 * cost)
  npv(r = r, cf = c(-outlay, revenue_sim - cost_sim))
})

mean(sim_npv)
quantile(sim_npv, c(0.05, 0.95))
mean(sim_npv > 0)   # probability that the project creates value

p_npv <- ggplot(tibble(npv = sim_npv), aes(x = npv)) +
  geom_histogram(bins = 60, fill = "steelblue", colour = "white") +
  geom_vline(xintercept = 0, colour = "red", linewidth = 1) +
  geom_vline(xintercept = npv(r = r, cf = cf), linetype = "dashed") +
  scale_x_continuous(labels = scales::dollar) +
  labs(title    = "Project NPV across 10,000 simulated futures",
       subtitle = "Red line: NPV = 0. Dashed line: base case NPV",
       x = "Net present value at 10%", y = "Number of simulations") +
  theme_bw()

p_npv
ggsave("output/04_npv_simulation.png", plot = p_npv, width = 8, height = 5, dpi = 150)




