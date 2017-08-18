library(doBy)
library(tidyr)
library(dplyr)
setwd("/Users/yoon/Downloads") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8")

data1 = read.csv("trimed_junggo_data.csv", header = T, encoding="utf-8")
data1$contents <- NULL

iphone <- subset(data1, data1$제품명=="iphone 6 64gb")
hist(iphone$판매금액_z)
shapiro.test(iphone$판매금액_z)
hist(log(iphone$판매금액, base=10))
shapiro.test(log(iphone$판매금액, base=10))

library(outliers)
outlierTest(iphone$판매금액)
v = which(iphone$판매금액_z < 3.5)
iphone = iphone[v,]

library(MASS)
model1 = aov(판매금액_z ~ 제품명, data=data1)
summary(model1)
t1 = TukeyHSD(model1, "제품명")
t1

library(MASS)
data("survey")
model1 = aov(Pulse ~ Exer, data=survey)
summary(model1)
t1 = TukeyHSD(model1, "Exer")
t1 # some-freq 의 경우 집단간의 심박수 차이가 있는 것.


test <- rnorm(100,50,2)
hist(test)
shapiro.test(test)