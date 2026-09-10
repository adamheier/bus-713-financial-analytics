
# 5.2 30-day rolling volatility, annualised. Same idea, but as a continuously
# updated window instead of fixed calendar months.
rolling_vol <- daily_returns %>%
  group_by(asset) %>%
  tq_mutate(
    select     = daily.returns,
    mutate_fun = rollapply,
    width      = 30,
    FUN        = sd,
    na.rm      = TRUE,
    col_rename = "roll_vol_30"
  ) %>%
  ungroup() %>%
  mutate(roll_vol_30_ann = roll_vol_30 * sqrt(252))

# the first 29 days of each series have no 30-day window yet -> drop the NAs
p_rvol <- rolling_vol %>%
  drop_na(roll_vol_30_ann) %>%
  ggplot(aes(x = date, y = roll_vol_30_ann, colour = asset)) +
  geom_line(linewidth = 0.4) +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title    = "30-day rolling volatility (annualised)",
    subtitle = "Calm and turbulent regimes hit all three assets at the same time",
    x = "", y = "Annualised volatility", colour = ""
  ) +
  theme_bw() +
  theme(legend.position = "bottom")

p_rvol
ggsave(file.path(out_dir, "07_rolling_volatility_30d.png"), p_rvol, width = 10, height = 5, dpi = 150)



# 7.6 Price return versus total return for Intel.
# "adjusted" includes reinvested dividends. Comparing it with the unadjusted
# close shows how much of Intel's result came from the dividend rather than
# from the share price - and how the price alone compares with inflation.
intc <- prices %>% filter(asset == "Intel (INTC)")

intc_total_return_cagr <- calc_cagr(intc$adjusted, intc$date)  # incl. dividends
intc_price_only_cagr   <- calc_cagr(intc$close,    intc$date)  # price only
intc_price_only_real   <- (1 + intc_price_only_cagr) / (1 + cpi_cagr) - 1

tibble(
  measure = c("INTC total return CAGR (adjusted)",
              "INTC price-only CAGR (close)",
              "INTC price-only CAGR, real",
              "Inflation CAGR"),
  value   = c(intc_total_return_cagr, intc_price_only_cagr,
              intc_price_only_real, cpi_cagr)
)


### 8
# Correlation with the index and beta (sensitivity to market moves).
returns_wide <- monthly_returns %>%
  pivot_wider(names_from = asset, values_from = monthly.returns) %>%
  drop_na() %>%
  rename(nvda = `NVIDIA (NVDA)`, intc = `Intel (INTC)`, ndx = `Nasdaq Composite`)

cor(returns_wide %>% select(-date))

market_sensitivity <- tibble(
  asset = c("NVIDIA (NVDA)", "Intel (INTC)"),
  correlation_ndx = c(cor(returns_wide$nvda, returns_wide$ndx),
                      cor(returns_wide$intc, returns_wide$ndx)),
  beta_ndx = c(coef(lm(nvda ~ ndx, data = returns_wide))[2],
               coef(lm(intc ~ ndx, data = returns_wide))[2])
)

market_sensitivity
