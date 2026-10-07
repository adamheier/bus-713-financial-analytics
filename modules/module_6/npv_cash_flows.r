install.packages("FinCal")
library(FinCal)

cf <- c(-100000, 30000, 35000, 40000, 25000)
cf

r <- 0.10

# use the npv function to calculate the net present value
npv(r = r, cf = cf)

irr(cf)
