setwd("/Users/yoon/Downloads") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

# 1881448 rows
# -> 6271 by 300 rows
# id = 379, 378
junggo_data = data.frame(matrix(ncol = 12, nrow = 0))
junggo_column <- c("ID", "카테고리_ID", 
                   "카테고리명", "제목", "등록날짜", 
                   "거래구분", "판매금액", "제품설명", 
                   "지불방법", "배송방법", "상세설명", "수집날짜")
colnames(junggo_data) <- junggo_column
con = file("data_1500627843972.csv", "r", encoding="utf-8")

preprocessing <- function(){
  temp = read.csv(con, nrows=300)
  subsets_379 = subset(temp, 카테고리_ID == 379)
  if(nrow(subsets_379) != 0){
    junggo_data = rbind(junggo_data, subsets_379)
  } 
  subsets_378 = subset(temp, 카테고리_ID == 378)
  if(nrow(subsets_378) != 0){
    junggo_data = rbind(junggo_data, subsets_378)
  } 
  for (i in 1:1822){
    temp = read.csv(con, nrows=300, header = F)
    colnames(temp) <- junggo_column
    subsets_379 = subset(temp, 카테고리_ID == 379)
    if(nrow(subsets_379) != 0){
      junggo_data = rbind(junggo_data, subsets_379)
    } 
    subsets_378 = subset(temp, 카테고리_ID == 378)
    if(nrow(subsets_378) != 0){
      junggo_data = rbind(junggo_data, subsets_378)
    } 
    print(paste("iter : ", i))
  }
}

preprocessing()

close(con)
write.csv(junggo_data, "junggo_data1.csv")

tong = read.csv("data_1500627843972.csv", header = T, encoding="utf-8")