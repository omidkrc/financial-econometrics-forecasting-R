packages <- c(
  "Quandl", "urca", "tidyverse", "pdR", "ggplot2", "forecast", "tseries",
  "rio", "readxl", "zoo", "lmtest", "arfima", "qqplotr", "devtools",
  "fracdiff", "MASS", "xts", "PerformanceAnalytics", "tidyr", "rugarch",
  "moments", "dplyr", "nortest", "fBasics", "TTR", "quantmod",
  "stargazer", "ggthemes", "gridExtra", "rmarkdown", "knitr"
)

missing <- packages[!packages %in% rownames(installed.packages())]
if (length(missing) > 0) install.packages(missing)
