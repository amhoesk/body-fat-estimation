# loading libraries
library("stringr")
library("tidyr")
library("dplyr")
library("haven")
library("leaps")
library("xlsx")
library("MASS") # for stepwise regression
library("glmnet") # for lasso regression
library("ggplot2")
library("GGally")
# How to use leaps and MASS packages:
# http://www.sthda.com/english/articles/37-model-selection-essentials-in-r/154-stepwise-regression-essentials-in-r/     # nolint

# How to use olsrr package:
# https://www.youtube.com/watch?v=vFH--Xdt3Pk&ab_channel=Stats4Everyone

## loading data
# https://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/DEMO_D.htm
df_demograph  <- data.frame(read_xpt("./inp/DEMO_D, 2005-2006.XPT"))

# https://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/BMX_D.htm
df_body_measur <- data.frame(read_xpt("./inp/BMX_D, 2005-2006.XPT"))

# https://wwwn.cdc.gov/nchs/data/nhanes/dxa/dxx_d.htm
df_dxa <- data.frame(read_xpt("./inp/dxx_d, 2005-2006.XPT"))