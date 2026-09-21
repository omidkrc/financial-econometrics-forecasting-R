#project 4
#libraries

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
library(qqplotr)
library(devtools)
library(fracdiff)
library(MASS) 
library(zoo)
library(xts)
library(PerformanceAnalytics)
library(tidyr)
library(rugarch)
library(moments)
library(dplyr)
library(nortest)
library(fBasics)
library(TTR)
library(quantmod)
library(stargazer)
library(ggthemes)
library(tseries)
library(gridExtra)
#reading the data of investment institutions


sarmaye <- read_excel("data/sarmaye.xlsx")
ind <- read_excel("data/index.xlsx")

#Data cleaning has been done in excel

#The uploaded data has two sets of columns,date and price

#creating the time series of price & plotting its graph
x=ts(sarmaye$price, start = c(2008 ,12,06), frequency = 235)
ts.plot(x,main = "daily price of investment index",ylab = "price")

#creating the time series of return & plotting its graph
returns=diff(log(x), lag=1)
returns2 = ts(returns ,start = c(2008 ,12,06), frequency = 235)
ts.plot(returns2, main = "daily return of investment index", ylab = "return", ylim=c(-0.1,0.1))

#finding the fractional d, checking the length of memory
fdGPH(returns, bandw.exp=0.5)

#finding p & q of the ARMA model in mean equation
aic_grid = matrix(NA_real_, nrow=6, ncol=6)

for (i in 1:6)
{
  for (j in 1:6)
  {
    candidate_model = arima(
      returns,
      c(i-1,0,j-1),
      method = "CSS-ML",
      optim.control = list(maxit=5000),
      kappa=1e4
    )
    aic_grid[i,j] = AIC(candidate_model)
  }
}

best_aic = which(aic_grid == min(aic_grid, na.rm = TRUE), arr.ind = TRUE)[1, ]
p = best_aic[1] - 1
q = best_aic[2] - 1
arma_sarmaye=arima(returns,c(p,0,q),method = c ("CSS-ML"), optim.control = list(maxit=5000), kappa=1e4)
arma_sarmaye

# p=5,q=5


bic_grid = matrix(NA_real_, nrow=6, ncol=6)

for (i in 1:6)
{
  for (j in 1:6)
  {
    candidate_model = arima(
      returns,
      c(i-1,0,j-1),
      method = "CSS-ML",
      optim.control = list(maxit=5000),
      kappa=1e4
    )
    bic_grid[i,j] = BIC(candidate_model)
  }
}

best_bic = which(bic_grid == min(bic_grid, na.rm = TRUE), arr.ind = TRUE)[1, ]
p = best_bic[1] - 1
q = best_bic[2] - 1

arma_sarmaye2=arima(returns,c(p,0,q),method = c ("CSS-ML"), optim.control = list(maxit=5000), kappa=1e4)
arma_sarmaye2

# p=1,q=2

auto.arima(returns)

# p=2,q=4

#mean-equation model; using the results of AIC
mean.equ=arma_sarmaye
summary(mean.equ)

#checking the fitness of model
mean.residuals=mean.equ$residuals

acf(mean.residuals, lag.max=8)
pacf(mean.residuals, lag.max=8)

Box.test(mean.residuals, lag=log(3393), c("Box-Pierce"))
Box.test(mean.residuals, lag=log(3393), c("Ljung-Box"))

#analyzing the distribution of time series, checking the normality
skewness(returns)

kurtosis(returns)

hist(returns)

ad.test(returns)

plot(density(returns))

chart.QQPlot(returns , distribution = "norm")

#checking the arch effect
acf(mean.residuals^2, lag.max=30)
pacf(mean.residuals^2, lag.max=30)

Box.test(mean.residuals^2, lag=log(3393), c("Box-Pierce"))
Box.test(mean.residuals^2, lag=log(3393), c("Ljung-Box"))

#garch modeling
garch=ugarchspec(variance.model=list(model="fiGARCH", garchOrder=c(1,1)), 
                 mean.model=list(armaOrder=c(5,5), include.mean=FALSE, archm=FALSE, archpow=1, 
                                 arfima=TRUE, archex=FALSE), distribution.model="sstd")

fit=ugarchfit(garch, data=(returns))
fit
plot(fit, which = "all")

#garch modeling containing total index as external regressor
z1=ts(ind$index)
z2=diff(log(z1), lag=1)

garch2=ugarchspec(variance.model=list(model="fiGARCH", garchOrder=c(1,1)), 
                 mean.model=list(armaOrder=c(5,5), include.mean=FALSE, archm=FALSE, archpow=1, 
                                 arfima=TRUE, archex=TRUE, external.regressors =matrix(z2)), distribution.model="sstd")

fit2=ugarchfit(garch2, data=(returns))
fit2
plot(fit2, which = "all")

#forecasting the return of stock using the fitted garch model
forecast_sarmaye=ugarchforecast(fit,n.ahead=5)
forecast_sarmaye
plot(forecast_sarmaye)

#plotting value at risk
n <- length(returns)

model.fit = ugarchfit(spec = garch , data = returns , solver = "solnp")
model.fit

qplot(y = returns , x =  1:n , geom = "point") +  geom_point( size = 0.1)+
  geom_line(aes(y = model.fit@fit$sigma*qdist(distribution = "sstd", 
                                              shape = 3.4125 , p = 0.05) , x = 1:n) , colour = "red" , size = 1.0) +
  geom_line(aes(y = model.fit@fit$sigma*qdist(distribution = "sstd", 
                                              shape = 3.4125 , p = 0.95) , x = 1:n) , colour = 'red' , size = 1.0) +
  labs(x = " " , y = "Daily Return" , title = "Value at Risk Comparison")

y1 = model.fit@fit$sigma*qdist(distribution = "sstd", shape = 3.41 , p = 0.05)
y11=ts(y1,start = c(2008), frequency=235)
plot(y11,col="red", xlab="Time")

#restructuring data for computing value at risk
sarmaye <- data.frame(cbind(year=substr(sarmaye[,1],1,4),
                               month=substr(sarmaye[,1],5,6), 
                               day=substr(sarmaye[,1],7,8), sarmaye))

sarmaye$date = as.Date(sarmaye$date)

is.timeBased(sarmaye$date)

price_xts =  xts(sarmaye$price,order.by = sarmaye$date )
return_xts = diff(log(price_xts) , lag = 1)

#computing value at risk with 3 different methods
mean(returns)
sd(returns)
skewness(returns)
kurtosis(returns)

VaR(R = return_xts, p = 0.95, method = c( "modified"),
    clean = c("none", "boudt", "geltner", "locScaleRob"),
    portfolio_method = c("single", "component", "marginal"),
    weights = NULL, mu = 0.001377912, sigma = 0.01093079,
    m3 = 0.7302357, m4 = 3.893968, invert = TRUE)

VaR(R = return_xts, p = 0.95, method = c( "gaussian"),
    clean = c("none", "boudt", "geltner", "locScaleRob"),
    portfolio_method = c("single", "component", "marginal"),
    weights = NULL, mu = 0.001377912, sigma = 0.01093079,
    m3 = 0.7302357, m4 = 3.893968, invert = TRUE)

VaR(R = return_xts, p = 0.95, method = c( "historical"),
    clean = c("none", "boudt", "geltner", "locScaleRob"),
    portfolio_method = c("single", "component", "marginal"),
    weights = NULL, mu = 0.001377912, sigma = 0.01093079,
    m3 = 0.7302357, m4 = 3.893968, invert = TRUE)