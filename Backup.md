
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