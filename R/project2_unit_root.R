# project2
# omid karami

library(Quandl)
library(urca)

Quandl.api_key(Sys.getenv("QUANDL_API_KEY"))
brazil_c = Quandl("BCB/226", collapse = "annual")
plot (brazil_c[,1],ts(brazil_c[,2]),col="blue",lwd=2,xlab="date",ylab="value")

x=ts(brazil_c[,2])
lm(x[2:33]~x[1:32])

# step 1
unitroot_A <- ur.df(x,type=c("trend"),selectlags=c("AIC"))
summary(unitroot_A)
plot(unitroot_A)
unitroot_A@teststat

# step 5
unitroot_A<-ur.df(x,type=c("drift"),selectlags=c("AIC"))
summary(unitroot_A)
plot(unitroot_A)
unitroot_A@teststat

# step 8
unitroot_A<-ur.df(x,type=c("none"),selectlags=c("AIC"))
summary(unitroot_A)
plot(unitroot_A)
unitroot_A@teststat


# First Difference

dx<-diff(x)
plot(dx)

# step 1
unitroot_A<-ur.df(dx,type=c("trend"),selectlags=c("AIC"))
summary(unitroot_A)
plot(unitroot_A)
unitroot_A@teststat
