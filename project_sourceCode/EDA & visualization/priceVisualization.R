

my = read.csv("trimed_junggo_data2.csv", header = T, encoding="utf-8")
Sys.setlocale("LC_ALL", "ko_KR.UTF-8")

data = read.csv("trimed_junggo_data2.csv", header = T, encoding="utf-8")
library(ggplot2)
data1 = data[data$판매금액_z_r1nk == 1, ]
data$판매금액 = scale(data$판매금액)
data1=as.data.frame(data1)
ggplot(data=data,aes(x=data$판매금액,y=data$판매금액))+geom_point(aes(colour=data$판매금액_z_r1nk))

p<-ggplot(data,aes(판매금액,colour=판매금액_z_rAnk,fill=판매금액_z_rAnk))
p<-p+geom_density(alpha=0.55)+scale_fill_discrete(name="흠결 등급",breaks=c("A","B","C"),labels=c("A등급","B등급","C등급"))+scale_colour_discrete(name="흠결 등급",breaks=c("A","B","C"),labels=c("A등급","B등급","C등급"))
p+labs(title = "판매금액의 확률밀도 분포표",y="밀도")

ttest<-t.test(data$판매금액,data$출고가)
plot(ttest$p.value)
ttest$statistic

data = read.csv("trimed_junggo_data3.csv", header = T, encoding="utf-8")
#각 그룹의 편차와 평균을 구함.
my_mean=aggregate(data$판매금액,by=list(data$made),mean);colnames(my_mean)=c("made","mean")
my_sd=aggregate(data$판매금액, by=list(data$made),sd);colnames(my_sd)=c("made","sd")
my_info=merge(my_mean,my_sd,by.x=1,by.y=1)
p<-ggplot(data)+geom_point(aes(x = made, y = 판매금액) , colour=rgb(0.8,0.7,0.1,0.4) , size=5) + 
  geom_point(data = my_info, aes(x = made, y = mean) , colour = rgb(0.6,0.5,0.4,0.7) , size = 8)
p+geom_errorbar(data = my_info, aes(x = made, y =sd, ymin = mean - sd, ymax = mean + sd), colour = rgb(0.4,0.8,0.2,0.4) , width = 0.7 , size=1.5)

my$판매금액 = scale(my$판매금액)
graph <- ggplot(my,aes(my$판매금액))+ labs(x='판매금액',y="밀도")+stat_function(fun=dnorm,colour="blue",args=list(mean=mean(my$판매금액)))

p<-ggplot(my,aes(판매금액,colour="pink",fill="pink"))+stat_function(fun=dnorm,colour="pink",geom="area",fill="pink",args=list(mean=mean(my$판매금액)))
p+geom_histogram(binwidth=0.01)


#########################################################################

data = read.csv("trimed_junggo_data4.csv", header = T, encoding="utf-8")
data1 = read.csv("my.csv", header = T, encoding="utf-8")
data$판매금액 = scale(data$판매금액)
data1$판매금액 = scale(data1$판매금액)
data2=rbind(data,data1)
p<-ggplot(data2,aes(판매금액,colour=제품명,fill=제품명))

p<-p+geom_density(alpha=0.55)

data = read.csv("visual.csv", header = T, encoding="utf-8")
library(ggplot2)
# Grouped
ggplot(data, aes(fill=가격구분, y=가격, x=월)) + 
  geom_bar(position="dodge", stat="identity")

# Stacked
ggplot(data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar( stat="identity")


# Stacked Percent
ggplot(data, aes(fill=condition, y=value, x=specie)) + 
  geom_bar( stat="identity", position="fill")










