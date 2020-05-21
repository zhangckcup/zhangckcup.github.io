# 导入数据
library(readr)
x <- read_csv("code/zhangckcup.github.io/docs/final/code/rInput1.csv")
#x <- read_csv("code/zhangckcup.github.io/docs/final/code/rInput2.csv")
datax <- cbind(x$GDP,x$人均可支配收入,x$人均消费支出,x$建筑业总产值,x$房屋竣工面积,x$住宅销售面积,x$人口密度,x$常住人口,x$外来人口,x$房屋面积占比,x$全社会固定资产投资,x$入境旅游人数,x$社会消费品零售总额)
datay <- cbind(x$安居客房租数据)
corx <- cor(datax)

# 主成分分析
## 生成碎石图
library(psych)
fa.parallel(corx, n.obs=16)

## 回归系数
datax_pca <- princomp(datax, cor = corx)
summary(datax_pca, loadings = corx)

## 相关系数
datax_ppa <- principal(corx, nfactors = 2, rotate = 'none')
summary(datax_ppa)
datax_ppa

# 线性回归
library(car)
datax2 = cbind(x$人均可支配收入,x$外来人口)

## 构建模型
fit <- lm(datay ~ datax2[,1]+datax2[,2])
summary(fit)
par(mfrow=c(2,2))
plot(fit)
par(mfrow=c(1,1))
qqPlot(fit,labels=row.names(states),id.method="identify",simulate=TRUE,main="Q-Q Plot")

## 学生残差图
residplot <- function(fit,nbreaks=10){  
  z<-rstudent(fit)
  hist(z,breaks=nbreaks,freq=FALSE,xlab="Studnetized Residual",main="Distribution of Errors")  
  rug(jitter(z),col="brown")  
  curve(dnorm(x,mean=mean(z),sd=sd(z)),add=TRUE,col="blue",lwd=2)  
  lines(density(z)$x,density(z)$y,col="red",lwd=2,lty=2)  
  legend("topright",legend=c("Normal Curve","Kernel Density Curve"),lty=1:2,col=c("blue","red"),cex=0.7)
}  
residplot(fit)
## 误差独立性
durbinWatsonTest(fit)
## 线性
par(mfrow=c(2,2))
crPlots(fit)
## 同方差性
ncvTest(fit)
spreadLevelPlot(fit)

## 线性模型假设的综合验证
#install.packages("gvlma")
library(gvlma)
gvmodel<-gvlma(fit)
summary(gvmodel)

## 多重共线性
sqrt(vif(fit))>2

# 异常观测值
## 离群点
outlierTest(fit)
## 高杠杆值点
#hat.plot<-function(fit){
#  p<-length(coefficients(fit))
#  n<-length(fitted(fit))
#  plot(hatvalues(fit),main="Index Plot of Hat Values")  
#  abline(h=c(2,3)*p/n,col="red",lty=2)
#  identify(1:n,hatvalues(fit),names(hatvalues(fit)))
#}
#hat.plot(fit)
## 强影响点
influencePlot(fit,main="Influence Plot",sub="Circle size if proportional to Cook's distance")  

# 变量选择
dataLm <- data.frame(
  x1 = x$GDP,
  x2 = x$人均可支配收入,
  x3 = x$人均消费支出,
  x4 = x$建筑业总产值,
  x5 = x$房屋竣工面积,
  x6 = x$住宅销售面积,
  x7 = x$人口密度,
  x8 = x$常住人口,
  x9 = x$外来人口,
  x10 = x$房屋面积占比,
  x11 = x$全社会固定资产投资,
  x12 = x$入境旅游人数,
  x13 = x$社会消费品零售总额,
  Y = x$安居客房租数据
)
## 向后回归
library(MASS)
tlm <- lm(Y~x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13, data = dataLm)
summary(tlm)
par(mfrow=c(2,2))
plot(tlm)
tstep <- step(tlm)
drop(tstep)
