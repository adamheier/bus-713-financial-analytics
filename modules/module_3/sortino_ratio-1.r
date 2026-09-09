# Sortino Ratio 

# Monthly returns
returns <- c(0.09, -0.03, 0.15, -0.01, 0.12, 0.04, 0.18, -0.06)
returns

# Minimum Acceptable Return
mar <- 0.05

# Downside deviation: Only returns below MAR contribute; anything above MAR is set to zero
downside_diff <- pmin(0, returns - mar)
downside_diff

downside_deviation <- sqrt(mean(downside_diff^2))
downside_deviation

# Average return and excess return
avg_return <- mean(returns)
excess_return <- avg_return - mar

# Sortino ratio
sortino_ratio <- excess_return / downside_deviation
sortino_ratio

