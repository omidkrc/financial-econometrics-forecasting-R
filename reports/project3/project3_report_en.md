---
geometry: margin=1in
toc: true
numbersections: true
fontsize: 11pt
---

# Project 3 - Seasonal Unit Roots and SARIMA Modeling

**Course:** Financial Econometrics  
**Author:** Omid Karami Chamgordani - 400203402  
**Date:** 2023-01-16

## Objective

This project uses two Tehran Stock Exchange industry indices: the leather-products index and the petroleum-products index. The data were downloaded with the TSE client and cleaned in Excel. The report merges the two daily datasets, converts the frequency to monthly and quarterly observations, tests for seasonal unit roots using the HEGY procedure, applies seasonal filters, and estimates SARIMA models for forecasting.

## Data import and merge

The cleaned files are stored in the `data/` folder. The code reads the two Excel files and merges them by date.

```r
# Data cleaning has been done in Excel

library(pdR)
library(tidyverse)
library(ggplot2)
library(forecast)
library(tseries)
library(rio)
library(readxl)
library(zoo)
library(lmtest)
library(arfima)

charm <- read_excel("data/leather.xlsx")
naft  <- read_excel("data/oil.xlsx")

total <- merge(charm, naft, by=c("date"))
```


## Frequency conversion

The date variable is decomposed into year, month, and day. The daily observations are first plotted directly. Then monthly and quarterly versions are built by averaging observations within each calendar period.

```r
df <- data.frame(cbind(year=substr(total[,1],1,4),
                       month=substr(total[,1],5,6),
                       day=substr(total[,1],7,8), total[, -1]))

df <- as.data.frame(lapply(df, as.numeric))
names(df)[4] <- "charm_price"
names(df)[5] <- "naft_price"

# daily plots
ts.plot(df$charm_price)
ts.plot(df$naft_price)

# monthly leather index
Ch <- aggregate(charm_price ~ year + month, data=df, mean)
charm_price_M <- Ch[order(Ch$year, Ch$month),]
c1 <- ts(charm_price_M$charm_price, start=c(2008, 12), frequency=12)
ts.plot(c1)

# quarterly leather index
charm_price_M$Quarter <- c(".")
charm_price_M$Quarter[(charm_price_M$month<=3)] <- 1
charm_price_M$Quarter[(charm_price_M$month>3) & (charm_price_M$month<7)] <- 2
charm_price_M$Quarter[(charm_price_M$month>6) & (charm_price_M$month<10)] <- 3
charm_price_M$Quarter[(charm_price_M$month>9)] <- 4
Qcharm <- data.frame(aggregate(charm_price ~ year + Quarter,
                               data=charm_price_M, mean))
charm_price_Q <- Qcharm[order(Qcharm$year, Qcharm$Quarter),]
c2 <- ts(charm_price_Q$charm_price, start=c(2008, 4), frequency=4)
ts.plot(c2)

# monthly and quarterly petroleum index
Nf <- aggregate(naft_price ~ year + month, data=df, mean)
naft_price_M <- Nf[order(Nf$year, Nf$month),]
n1 <- ts(naft_price_M$naft_price, start=c(2008, 12), frequency=12)
ts.plot(n1)

naft_price_M$Quarter <- c(".")
naft_price_M$Quarter[(naft_price_M$month<=3)] <- 1
naft_price_M$Quarter[(naft_price_M$month>3) & (naft_price_M$month<7)] <- 2
naft_price_M$Quarter[(naft_price_M$month>6) & (naft_price_M$month<10)] <- 3
naft_price_M$Quarter[(naft_price_M$month>9)] <- 4
Qnaft <- data.frame(aggregate(naft_price ~ year + Quarter,
                              data=naft_price_M, mean))
naft_price_Q <- Qnaft[order(Qnaft$year, Qnaft$Quarter),]
n2 <- ts(naft_price_Q$naft_price, start=c(2008, 4), frequency=4)
ts.plot(n2)
```


## HEGY seasonal unit-root tests

For each quarterly series, the HEGY test is first estimated with an intercept, a deterministic trend, and seasonal dummies. Since these deterministic components are not statistically strong, the reduced specification without deterministic terms is also reported.

For the leather-products index, the reduced HEGY statistics are approximately `tpi_1 = 0.820`, `tpi_2 = -1.886`, and `Fpi_3:4 = 2.814`. At the 5 percent level, these statistics do not provide enough evidence to reject the seasonal unit-root nulls. The series therefore shows evidence of quarterly, semiannual, and annual seasonal unit-root behavior.

For the petroleum-products index, the reduced HEGY statistics are approximately `tpi_1 = 1.952`, `tpi_2 = 2.511`, and `Fpi_3:4 = 0.435`, again indicating that the seasonal unit-root nulls are not rejected in the unfiltered series.

```r
# HEGY test for leather index
hegy.out <- HEGY.test(wts=c2, itsd=c(1,1,c(1,2,3)), regvar=0,
                      selectlags=list(mode="aic", pmax=20))
hegy.out$stats
hegy.out$hegycoefs
hegy.out$regvarcoefs

hegy.out <- HEGY.test(wts=c2, itsd=c(0,0,0), regvar=0,
                      selectlags=list(mode="aic", pmax=20))
hegy.out$stats
hegy.out$hegycoefs
hegy.out$regvarcoefs

# HEGY test for petroleum index
hegy.out <- HEGY.test(wts=n2, itsd=c(1,1,c(1,2,3)), regvar=0,
                      selectlags=list(mode="aic", pmax=20))
hegy.out$stats
hegy.out$hegycoefs
hegy.out$regvarcoefs

hegy.out <- HEGY.test(wts=n2, itsd=c(0,0,0), regvar=0,
                      selectlags=list(mode="aic", pmax=20))
hegy.out$stats
hegy.out$hegycoefs
hegy.out$regvarcoefs
```


## Seasonal filters

Successive seasonal filters are applied until the HEGY statistics reject the relevant unit-root components. The leather index becomes seasonally stationary after seven filtering steps. The petroleum index becomes seasonally stationary after five filtering steps. The additional nonseasonal differencing order is `d = 0` for both filtered series.

```r
# leather filters
filter_ch  <- c2 - c2[5:62]                 # 1 - B^4
filter_2ch <- filter_ch - filter_ch[3:60]   # 1 - B^2
filter_3ch <- filter_2ch - filter_2ch[5:62] # 1 - B^4
filter_4ch <- filter_3ch - filter_3ch[3:60] # 1 - B^2
filter_5ch <- filter_4ch + filter_4ch[2:59] + filter_4ch[3:60] + filter_ch[4:61]
filter_6ch <- filter_5ch + filter_5ch[2:59]
filter_7ch <- filter_6ch - filter_6ch[5:62]

# petroleum filters
filter_na  <- n2 - n2[5:62]
filter_2na <- filter_na - filter_na[5:62]
filter_3na <- filter_2na - filter_2na[3:60]
filter_4na <- filter_3na + filter_3na[2:59]
filter_5na <- filter_4na + filter_4na[2:59]

ndiffs(filter_7ch, alpha=0.05, test=c("adf"), max.d=10)
ndiffs(filter_5na, alpha=0.05, test=c("adf"), max.d=10)
```


## SARIMA modeling and forecasting

Automatic SARIMA selection gives an ARIMA(3,0,0)(0,0,2)[4] model with zero mean for the filtered leather series, and an ARIMA(2,0,0)(0,0,2)[4] model with non-zero mean for the filtered petroleum series. Forecasts are then generated for eight quarters ahead.

```r
auto.arima(filter_7ch, max.p=5, max.q=5, max.P=3, max.Q=3,
           max.d=4, max.D=4, stepwise=FALSE, approximation=FALSE)

auto.arima(filter_5na, max.p=5, max.q=5, max.P=3, max.Q=3,
           max.d=4, max.D=4, stepwise=FALSE, approximation=FALSE)

# leather forecast
fit <- arima(c2, order=c(3,0,0), seasonal=list(order=c(0,3,2), period=4),
             method="CSS")
plot(fit$residuals)
acf(fit$residuals, lag=15)
pacf(fit$residuals, lag=15)
forecast(fit, h=8)
plot(forecast(fit, h=8))

# petroleum forecast
fit <- arima(n2, order=c(2,0,0), seasonal=list(order=c(0,2,2), period=4),
             method="CSS")
plot(fit$residuals)
acf(fit$residuals, lag=15)
pacf(fit$residuals, lag=15)
forecast(fit, h=8)
plot(forecast(fit, h=8))
```


## Conclusion

Both industry indices display strong seasonal non-stationarity before filtering. After applying the selected seasonal filters, no additional nonseasonal differencing is required. The final SARIMA specifications provide an interpretable framework for quarterly forecasting.
