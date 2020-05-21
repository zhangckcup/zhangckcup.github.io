# ��������
library(readr)
x <- read_csv("code/zhangckcup.github.io/docs/final/code/rInput1.csv")
#x <- read_csv("code/zhangckcup.github.io/docs/final/code/rInput2.csv")
datax <- cbind(x$GDP,x$�˾���֧������,x$�˾�����֧��,x$����ҵ�ܲ�ֵ,x$���ݿ������,x$סլ�������,x$�˿��ܶ�,x$��ס�˿�,x$�����˿�,x$�������ռ��,x$ȫ���̶��ʲ�Ͷ��,x$�뾳��������,x$�������Ʒ�����ܶ�)
datay <- cbind(x$���ӿͷ�������)
corx <- cor(datax)

# ���ɷַ���
## ������ʯͼ
library(psych)
fa.parallel(corx, n.obs=16)

## �ع�ϵ��
datax_pca <- princomp(datax, cor = corx)
summary(datax_pca, loadings = corx)

## ���ϵ��
datax_ppa <- principal(corx, nfactors = 2, rotate = 'none')
summary(datax_ppa)
datax_ppa

# ���Իع�
library(car)
datax2 = cbind(x$�˾���֧������,x$�����˿�)

## ����ģ��
fit <- lm(datay ~ datax2[,1]+datax2[,2])
summary(fit)
par(mfrow=c(2,2))
plot(fit)
par(mfrow=c(1,1))
qqPlot(fit,labels=row.names(states),id.method="identify",simulate=TRUE,main="Q-Q Plot")

## ѧ���в�ͼ
residplot <- function(fit,nbreaks=10){  
  z<-rstudent(fit)
  hist(z,breaks=nbreaks,freq=FALSE,xlab="Studnetized Residual",main="Distribution of Errors")  
  rug(jitter(z),col="brown")  
  curve(dnorm(x,mean=mean(z),sd=sd(z)),add=TRUE,col="blue",lwd=2)  
  lines(density(z)$x,density(z)$y,col="red",lwd=2,lty=2)  
  legend("topright",legend=c("Normal Curve","Kernel Density Curve"),lty=1:2,col=c("blue","red"),cex=0.7)
}  
residplot(fit)
## ��������
durbinWatsonTest(fit)
## ����
par(mfrow=c(2,2))
crPlots(fit)
## ͬ������
ncvTest(fit)
spreadLevelPlot(fit)

## ����ģ�ͼ�����ۺ���֤
#install.packages("gvlma")
library(gvlma)
gvmodel<-gvlma(fit)
summary(gvmodel)

## ���ع�����
sqrt(vif(fit))>2

# �쳣�۲�ֵ
## ��Ⱥ��
outlierTest(fit)
## �߸ܸ�ֵ��
#hat.plot<-function(fit){
#  p<-length(coefficients(fit))
#  n<-length(fitted(fit))
#  plot(hatvalues(fit),main="Index Plot of Hat Values")  
#  abline(h=c(2,3)*p/n,col="red",lty=2)
#  identify(1:n,hatvalues(fit),names(hatvalues(fit)))
#}
#hat.plot(fit)
## ǿӰ���
influencePlot(fit,main="Influence Plot",sub="Circle size if proportional to Cook's distance")  

# ����ѡ��
dataLm <- data.frame(
  x1 = x$GDP,
  x2 = x$�˾���֧������,
  x3 = x$�˾�����֧��,
  x4 = x$����ҵ�ܲ�ֵ,
  x5 = x$���ݿ������,
  x6 = x$סլ�������,
  x7 = x$�˿��ܶ�,
  x8 = x$��ס�˿�,
  x9 = x$�����˿�,
  x10 = x$�������ռ��,
  x11 = x$ȫ���̶��ʲ�Ͷ��,
  x12 = x$�뾳��������,
  x13 = x$�������Ʒ�����ܶ�,
  Y = x$���ӿͷ�������
)
## ���ع�
library(MASS)
tlm <- lm(Y~x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13, data = dataLm)
summary(tlm)
par(mfrow=c(2,2))
plot(tlm)
tstep <- step(tlm)
drop(tstep)
