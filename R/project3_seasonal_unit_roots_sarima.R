# project 3
# Omid Karami
# 400203402



# Data cleaning has been done in excel


#install packages

#install.packages("pdR")
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("forecast")
#install.packages("tseries")
#install.packages("rio")
#install.packages("tidyverse")
#install.packages("readxl")
#install.packages("zoo")
#install.packages("lmtest")
#install.packages("arfima")

library(pdR)
library(tidyverse)
library(ggplot2)
library(forecast)
library(tseries)
library(rio)
library(tidyverse)
library(readxl)
library(zoo)
library(lmtest)
library(arfima)

#install_formats("arrow")
#install_formats("feather")
#install_formats("fst")
#install_formats("hexView")
#install_formats("pzfx")
#install_formats("readODS")
#install_formats("rmatio")




charm <- read_excel("data/leather.xlsx")
naft <- read_excel("data/oil.xlsx")


# Question 3, merging data

total <- merge (charm, naft, by=c("date"))

# Question 4, converting data frequency from daily to monthly and seasonal
# Question 5, plotting graphs for different frequencies of data


df <- data.frame(cbind(year=substr(total[,1],1,4), 
                      month=substr(total[,1],5,6), 
                      day=substr(total[,1],7,8), total[, -1]))

df <- as.data.frame(lapply(df, as.numeric))

names(df)[4] <- "charm_price"
names(df)[5] <- "naft_price"


# daily plot for charm & naft

ts.plot(df$charm_price)

ts.plot(df$naft_price)

# monthly plot for charm 

Ch=aggregate(charm_price ~ year + month, data = df, mean)
charm_price_M <- Ch[order(Ch$year, Ch$month),]
ts.plot(charm_price_M$charm_price)

# edited monthly plot for charm

c1 = ts(charm_price_M$charm_price, start=c(2008, 12), frequency = 12)
ts.plot(c1)

# seasonal plot for charm

charm_price_M$Quarter <- c(".")

charm_price_M$Quarter[(charm_price_M$month<=3)]=1
charm_price_M$Quarter[(charm_price_M$month>3) & (charm_price_M$month<7)]=2
charm_price_M$Quarter[(charm_price_M$month>6) & (charm_price_M$month<10)]=3
charm_price_M$Quarter[(charm_price_M$month>9)]=4

Qcharm=data.frame(aggregate(charm_price ~ year + Quarter, data=charm_price_M, mean))
charm_price_Q <- Qcharm[order(Qcharm$year, Qcharm$Quarter), ]
ts.plot(charm_price_Q$charm_price)

# edited seasonal plot for charm

c2 = ts(charm_price_Q$charm_price, start=c(2008, 4), frequency = 4)
ts.plot(c2)

# monthly plot for naft

Nf=aggregate(naft_price ~ year + month, data = df, mean)
naft_price_M <- Nf[order(Nf$year, Nf$month),]
ts.plot(naft_price_M$naft_price)

# edited monthly plot for naft

n1 = ts(naft_price_M$naft_price, start=c(2008, 12), frequency = 12)
ts.plot(n1)

# seasonal plot for naft

naft_price_M$Quarter <- c(".")

naft_price_M$Quarter[(naft_price_M$month<=3)]=1
naft_price_M$Quarter[(naft_price_M$month>3) & (naft_price_M$month<7)]=2
naft_price_M$Quarter[(naft_price_M$month>6) & (naft_price_M$month<10)]=3
naft_price_M$Quarter[(naft_price_M$month>9)]=4

Qnaft=data.frame(aggregate(naft_price ~ year + Quarter, data=naft_price_M, mean))
naft_price_Q <- Qnaft[order(Qnaft$year, Qnaft$Quarter), ]
ts.plot(naft_price_Q$naft_price)

# edited seasonal plot for naft

n2 = ts(naft_price_Q$naft_price, start=c(2008, 4), frequency = 4)
ts.plot(n2)


# Question 6

# seasonal unit root test for charm

# with intercept, trend & seasonal dummies
hegy.out <- HEGY.test(wts = c2, itsd=c(1,1,c(1,2,3)), regvar= 0 , 
                      selectlags = list(mode="aic", pmax=20) )
hegy.out$stats 
##            Stat.    p-value
##tpi_1   3.5476968 0.10000000
##tpi_2   0.1466893 0.10000000
##Fpi_3:4 6.3989800 0.05691935
##Fpi_2:4 7.6342711         NA
##Fpi_1:4 6.4597808         NA

hegy.out$hegycoefs
##      Estimate Std. Error    t value  Pr(>|t|)
##Ypi1  27.46181   7.740743  3.5476968 0.1000000
##Ypi2   2.02433  13.800119  0.1466893 0.1000000
##Ypi3 -31.00653  15.888699 -1.9514834 0.1000000
##Ypi4  25.74878  16.005305  1.6087654 0.9109646

hegy.out$regvarcoefs
##               Estimate Std. Error     t value   Pr(>|t|)
##Intercept   -53129.3505 23978.3075 -2.21572563 0.05393899
##Trend         -379.6524   686.7968 -0.55278705 0.59387095
##SeasDummy.1    160.5834  7375.4617  0.02177266 0.98310438
##SeasDummy.2  -5726.8917  8084.2649 -0.70839981 0.49663361
##SeasDummy.3   5366.1768  7741.4116  0.69317807 0.50569077

# without intercept, trend & seasonal dummies
hegy.out <- HEGY.test(wts = c2, itsd=c(0,0,0), regvar= 0 , 
                      selectlags = list(mode="aic", pmax=20) )
hegy.out$stats 
##             Stat.    p-value
##tpi_1    0.8202326 0.10000000
##tpi_2   -1.8860373 0.05831335
##Fpi_3:4  2.8138883 0.07637682
##Fpi_2:4  1.8925249         NA
##Fpi_1:4  1.4212896         NA

hegy.out$hegycoefs
##       Estimate Std. Error    t value   Pr(>|t|)
##Ypi1   0.881926   1.075215  0.8202326 0.10000000
##Ypi2 -22.950467  12.168618 -1.8860373 0.05831335
##Ypi3 -23.503173  13.290846 -1.7683729 0.06937048
##Ypi4  21.610851  10.741074  2.0119823 0.97284831

hegy.out$regvarcoefs
##NULL


# seasonal unit root test for naft

# with intercept, trend & seasonal dummies
hegy.out <- HEGY.test(wts = n2, itsd=c(1,1,c(1,2,3)), regvar= 0 , 
                      selectlags = list(mode="aic", pmax=20) )
hegy.out$stats 
##             Stat. p-value
##tpi_1   -1.0452427     0.1
##tpi_2    1.5646336     0.1
##Fpi_3:4  0.4134252     0.1
##Fpi_2:4  1.2286686      NA
##Fpi_1:4  1.4045662      NA

hegy.out$hegycoefs
##       Estimate Std. Error    t value  Pr(>|t|)
##Ypi1  -5.413409   5.179093 -1.0452427 0.1000000
##Ypi2  45.873727  29.319150  1.5646336 0.1000000
##Ypi3 -15.934584  19.757304 -0.8065161 0.1000000
##Ypi4  -7.622448  19.789747 -0.3851716 0.3939072

hegy.out$regvarcoefs
##              Estimate Std. Error    t value  Pr(>|t|)
##Intercept   -7815616.1  5988074.0 -1.3051970 0.2486584
##Trend         314641.2   253015.7  1.2435638 0.2687854
##SeasDummy.1   107906.2   715468.5  0.1508189 0.8860144
##SeasDummy.2  -233794.1   825322.3 -0.2832761 0.7883194
##SeasDummy.3   158099.0   735281.4  0.2150183 0.8382481

# without intercept, trend & seasonal dummies
hegy.out <- HEGY.test(wts = n2, itsd=c(0,0,0), regvar= 0 , 
                      selectlags = list(mode="aic", pmax=20) )
hegy.out$stats 
##           Stat. p-value
##tpi_1   1.952451     0.1
##tpi_2   2.511081     0.1
##Fpi_3:4 0.434590     0.1
##Fpi_2:4 2.594353      NA
##Fpi_1:4 3.275117      NA

hegy.out$hegycoefs
##       Estimate Std. Error    t value Pr(>|t|)
##Ypi1  0.8277437   0.423951  1.9524512 0.100000
##Ypi2 61.4589510  24.475102  2.5110805 0.100000
##Ypi3 -9.5962871  11.097087 -0.8647573 0.100000
##Ypi4 -3.3960059  12.223349 -0.2778294 0.419475

hegy.out$regvarcoefs
##NULL


# Question 7 

# finding filter for charm

# first step

#1-B^4

filter_ch = c2 - c2[5:62]

hegy <- HEGY.test(wts = filter_ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 20))

hegy$hegycoefs
hegy$stats
##            Stat. p-value
##tpi_1    4.879625    0.10
##tpi_2    4.811451    0.10
##Fpi_3:4 14.494800    0.01
##Fpi_2:4 43.004698      NA
##Fpi_1:4 40.579494      NA

# Second Step

#1-B^2

filter_2ch = filter_ch - filter_ch[3:60]

hegy <- HEGY.test(wts = filter_2ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 20))


hegy$hegycoefs
hegy$stats
##           Stat. p-value
##tpi_1   1.8477267     0.1
##tpi_2   0.3592605     0.1
##Fpi_3:4 2.1339427     0.1
##Fpi_2:4 4.7821447      NA
##Fpi_1:4 7.6989800      NA

# third step

#1-B^4

filter_3ch = filter_2ch - filter_2ch[5:62]
hegy <- HEGY.test(wts = filter_3ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 19))


hegy$hegycoefs
hegy$stats
##            Stat. p-value
##tpi_1   -0.5378652    0.10
##tpi_2    2.6497908    0.10
##Fpi_3:4  4.9975928    0.01
##Fpi_2:4  4.0784179      NA
##Fpi_1:4  3.0590180      NA

# fourth step

#1-B^2

filter_4ch = filter_3ch - filter_3ch[3:60]
hegy <- HEGY.test(wts = filter_4ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 18))


hegy$hegycoefs
hegy$stats
##           Stat.    p-value
##tpi_1   -2.347010 0.02271818
##tpi_2    1.523161 0.10000000
##Fpi_3:4  2.547751 0.09312310
##Fpi_2:4  1.809867         NA
##Fpi_1:4  5.185276         NA

# fifth step

#1+B+B^2+B^3

filter_5ch = filter_4ch + filter_4ch[2:59] + filter_4ch[3:60] + filter_ch[4:61]
hegy <- HEGY.test(wts = filter_5ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 17))


hegy$hegycoefs
hegy$stats
##          Stat.    p-value
##tpi_1   -2.815780 0.01000000
##tpi_2    1.684239 0.10000000
##Fpi_3:4  4.494770 0.01762665
##Fpi_2:4  4.696643         NA
##Fpi_1:4 10.919441         NA

# sixth step

#1+B

filter_6ch = filter_5ch + filter_5ch[2:59]
hegy <- HEGY.test(wts = filter_6ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 17))


hegy$hegycoefs
hegy$stats
##            Stat. p-value
##tpi_1   -1.1051854     0.1
##tpi_2   -1.0848171     0.1
##Fpi_3:4  0.2576754     0.1
##Fpi_2:4  0.6369729      NA
##Fpi_1:4  3.1751822      NA

# seventh step

#1-B^4

filter_7ch = filter_6ch - filter_6ch[5:62]
hegy <- HEGY.test(wts = filter_7ch , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 15))


hegy$hegycoefs
hegy$stats
##          Stat.    p-value
##tpi_1   -4.199697 0.01000000
##tpi_2   -8.147576 0.01196661
##Fpi_3:4 26.786349 0.01000000
##Fpi_2:4 26.426440         NA
##Fpi_1:4 19.843823         NA

#Finally charm data becomes seasonally stationary after applying seven steps of filtering!!!


# finding filter for naft


# first step

#1-B^4

filter_na = n2 - n2[5:62]
hegy <- HEGY.test(wts = filter_na , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 20))

hegy$hegycoefs
hegy$stats
##          Stat.    p-value
##tpi_1   0.7406905 0.10000000
##tpi_2   0.6704317 0.10000000
##Fpi_3:4 2.4625685 0.09848311
##Fpi_2:4 2.7967667         NA
##Fpi_1:4 2.1207333         NA

# Second Step

#1-B^4

filter_2na = filter_na - filter_na[5:62]

hegy <- HEGY.test(wts = filter_2na , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 20))


hegy$hegycoefs
hegy$stats
##            Stat. p-value
##tpi_1   -0.2108569    0.10
##tpi_2    3.5379683    0.10
##Fpi_3:4 11.9366886    0.01
##Fpi_2:4  9.0720059      NA
##Fpi_1:4  6.9008513      NA

# third step

#1-B^2

filter_3na = filter_2na - filter_2na[3:60]
hegy <- HEGY.test(wts = filter_3na , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 19))


hegy$hegycoefs
hegy$stats
##           Stat. p-value
##tpi_1    -8.976854    0.01
##tpi_2     6.387249    0.10
##Fpi_3:4 130.681384    0.01
##Fpi_2:4  89.488097      NA
##Fpi_1:4  72.326196      NA

# fourth step

#1+B

filter_4na = filter_3na + filter_3na[2:59]
hegy <- HEGY.test(wts = filter_4na , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 19))


hegy$hegycoefs
hegy$stats
##           Stat. p-value
##tpi_1   -11.020985    0.01
##tpi_2     5.572744    0.10
##Fpi_3:4  45.053706    0.01
##Fpi_2:4  77.330651      NA
##Fpi_1:4  64.393321      NA

# fifth step

#1+B

filter_5na = filter_4na + filter_4na[2:59]
hegy <- HEGY.test(wts = filter_5na , itsd = c(0,0,0) ,
                  regvar = 0 , selectlags =list(mode = "aic" , pmax = 18))


hegy$hegycoefs
hegy$stats
##           Stat.    p-value
##tpi_1   -9.204992 0.01000000
##tpi_2   -4.352837 0.01060705
##Fpi_3:4 28.078359 0.01000000
##Fpi_2:4 22.995226         NA
##Fpi_1:4 28.881674         NA


# Finding d for charm & naft

# charm
ndiffs(filter_7ch, alpha = 0.05, test = c("adf"), max.d = 10)

# d = 0

# naft
ndiffs(filter_5na, alpha = 0.05, test = c("adf"), max.d = 10)
# d = 0


# Question 8

# SARIMA model for charm, finding p, q, P & Q

auto.arima(filter_7ch, max.p=5, max.q=5, max.P=3, max.Q=3, max.d=4, max.D=4, stepwise=FALSE, approximation=FALSE)
##Series: filter_7ch 
##ARIMA(3,0,0)(0,0,2)[4] with zero mean 

## Coefficients:
##         ar1      ar2     ar3     sma1    sma2
##       1.8403  -1.7414  0.6851  -1.6216  0.7287
## s.e.  0.1411   0.1737  0.1437   0.3886  0.3339

## sigma^2 = 1.296e+09:  log likelihood = -473.26
## AIC=958.52   AICc=961.14   BIC=968.5


# SARIMA model for naft, finding p, q, P & Q

auto.arima(filter_5na, max.p=5, max.q=5, max.P=3, max.Q=3, max.d=4, max.D=4, stepwise=FALSE, approximation=FALSE)
##Series: filter_5na 
##ARIMA(2,0,0)(0,0,2)[4] with non-zero mean 

## Coefficients:
##        ar1      ar2     sma1    sma2       mean
##       1.0303  -0.7146  -1.6473  0.6783  -76184.65
## s.e.  0.1033   0.0935   0.4064  0.3105   53190.39

## sigma^2 = 3.215e+12:  log likelihood = -735.93
## AIC=1483.86   AICc=1486.01   BIC=1494.83


library(forecast)
fit <- arima(c2, order = c(3,0,0), seasonal = list(order=c(0,3,2), period=4), method = "CSS")
plot(fit$residuals)

acf(fit$residuals, lag=15)

pacf(fit$residuals, lag=15)

forecast(fit, h=8)

##        Point Forecast      Lo 80    Hi 80     Lo 95     Hi 95
## 2023 Q2      27610.759   2006.445 53215.07 -11547.66  66769.18
## 2023 Q3      15283.547 -19004.242 49571.34 -37155.10  67722.20
## 2023 Q4      18264.324 -19144.980 55673.63 -38948.27  75476.92
## 2024 Q1      25534.308 -12289.090 63357.71 -32311.59  83380.20
## 2024 Q2      32494.006 -20542.263 85530.28 -48617.97 113605.98
## 2024 Q3       6087.423 -54945.628 67120.47 -87254.57  99429.42
## 2024 Q4      14382.406 -49383.687 78148.50 -83139.42 111904.23
## 2025 Q1      28433.641 -35597.961 92465.24 -69494.24 126361.53

plot(forecast(fit, h=8))


library(forecast)
fit <- arima(n2, order = c(2,0,0), seasonal = list(order=c(0,2,2), period=4), method = "CSS")
plot(fit$residuals)

acf(fit$residuals, lag=15)

pacf(fit$residuals, lag=15)

forecast(fit, h=8)

##         Point Forecast   Lo 80    Hi 80   Lo 95    Hi 95
## 2023 Q2        8094157 6902023  9286290 6270945  9917368
## 2023 Q3        9583330 7959150 11207509 7099361 12067298
## 2023 Q4        9447450 7455186 11439714 6400545 12494355
## 2024 Q1        9647125 7339189 11955061 6117442 13176808
## 2024 Q2       10572038 7842411 13301666 6397433 14746644
## 2024 Q3       12207669 9107626 15307711 7466562 16948775
## 2024 Q4       12074250 8622819 15525682 6795741 17352759
## 2025 Q1       12310778 8545626 16075930 6552475 18069081

plot(forecast(fit, h=8))
