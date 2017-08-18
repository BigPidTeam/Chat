## 기가 달아주는 작업
setwd("C:/r_exam")
tong_origin = read.csv("finaldata3.csv", header = T, encoding="utf-8")# 중고나라 data
onename_phone = read.csv("onename_phone.csv", header = T, encoding="utf-8") # 단종에 대한 모델명, 기가 정보 data

onename_phone <- onename_phone[,-3]
onename_phone$모델명 <- as.character(onename_phone$모델명)
onename_phone$용량 <- as.character(onename_phone$용량)
tong_origin$용량 <- as.character(tong_origin$용량)



for(check in 1:nrow(onename_phone)){
  if((table(tong_origin$제품명==onename_phone$모델명[check])["FALSE"]) != 5521){
    tong_origin[tong_origin$제품명==onename_phone$모델명[check],]$용량 <- onename_phone$용량[check]
  }
}
