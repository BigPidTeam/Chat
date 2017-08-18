library(doBy)
library(tidyr)
library(dplyr)
setwd("/Users/yoon/Downloads") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8")

data = read.csv("junggo_data.csv", header = T, encoding="utf-8")

# 칼럼 전처리
colnames(data)
data1 = data
data1$카테고리_ID <- NULL
data1$ID <- NULL
data1$카테고리명 <- NULL
data1$거래구분 <- NULL
data1$제품설명 <- NULL
data1$지불방법 <- NULL
data1$배송방법 <- NULL
data1$제목 <- NULL
data1$상세설명 <- NULL
data1$수집날짜 <- NULL
data1$contents <- NULL
data1$제조사 <- NULL

# month만 추출하기
data1$date <- as.character(data1$date)
for (i in 1:5521){
  data1[i, 6] = substring(data1[i, 6], 1, 3)
}
data1$출고가 <- as.character(data$출고가)

# 데이터 20개 미만 모델들은 제거
a = names(sort(table(data1$제품명)))[1:57]
list = c()
for (i in a){
  v = which(data1$제품명==i)
  list <- c(list, v)
}
data2 = data1[-list, ]


data2$판매금액 <- as.numeric(as.character(data2$판매금액))

# 제품명 + 용량 -> 제품명으로
delete_list <- which(data2$용량 == "")
data2 <- data2[-delete_list, ]
data2$용량 <- factor(data2$용량)
data2$용량 <- as.character(data2$용량)
data2$제품명 <- as.character(data2$제품명)

for (i in 1:5026){
  data2[i, 3] = paste(data2[i, 3], data2[i, 4], sep=" ")
}
data2$제품명 <- as.factor(data2$제품명)
data2[5521,]

# 용량 칼럼 제거
data2$용량 <- NULL

# 판매금액 표준화
data2 = data2 %>% drop_na(판매금액)
data2 <- data2 %>% group_by(제품명) %>% mutate(판매금액_z = scale(판매금액))
data2 <- data2 %>% group_by(제품명) %>% mutate(판매금액_mean = mean(판매금액))
data2 <- data2 %>% group_by(제품명) %>% mutate(판매금액_sd = sd(판매금액))

# 새 칼럼 생성
namevector <- c("판매금액_z_rank")
data2[,namevector] <- NA

# rank 달아주기
a_idx_list = which(data2$판매금액_z > 0.7)
b_idx_list = which((data2$판매금액_z < 0.7) & (data2$판매금액_z > -0.7))
c_idx_list = which(data2$판매금액_z < -0.7)
data2[a_idx_list, ]$판매금액_z_rank = "A"
data2[b_idx_list, ]$판매금액_z_rank = "B"
data2[c_idx_list, ]$판매금액_z_rank = "C"

sort(table(data2$제품명))
k=subset(data2, 제품명=="galaxy s7 edge 128gb")

# 데이터 10개 미만 최종 모델들은 제거
a = names(sort(table(data2$제품명)))[1:20]
list = c()
for (i in a){
  v = which(data2$제품명==i)
  list <- c(list, v)
}
data3 = data2[-list, ]
data3$제품명 = factor(data3$제품명)
str(data3)
data3$등록날짜 <- NULL
data3$판매금액_z <- NULL
data3$판매금액_mean <- NULL
data3$판매금액_sd <- NULL

data4 <- data3 %>% group_by(제품명, date) %>% mutate(판매금액_month_mean = mean(판매금액))
table(data4$제품명)

write.csv(data4, "trimed_junggo_data2.csv")
