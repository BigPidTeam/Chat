library(stringi)
library(stringr)

# 데이터 전처리 및 컬럼 생성
setwd("/Users/yoon/Downloads") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌
tong_origin = read.csv("newdata3.csv", header = T, fileEncoding="utf-8")
tong = tong_origin
tong$contents <- str_to_lower(tong$contents)
tong$제목 <- str_to_lower(tong$제목)
tong$상세설명 <- str_to_lower(tong$상세설명)
new_columns <- c("제품명", "용량", "출고가", "제조사")
tong[,new_columns] <- NA


# 제목에서 폰명 검색, 제품명 달아주기
product_name = "galaxy6"
maker_name = "삼성전자"
galaxy6 = c("갤럭시 6", "갤6", "갤럭시6", "갤 6", "갤s6", "갤럭시s6", "겔럭시6",
            "겔럭시 6", "겔6", "겔s6", "겔 s6", "갤 s6", "삼성 s6",
            "삼성 겔6", "삼성갤6", "삼성 갤6", "삼성갤 6", "삼성겔6", "삼성겔 6")

index_list = list()
for (search_p in galaxy6){
  index = grep(search_p, tong$제목)
  index_list = append(index_list, index)
}
index_list_unique = unique(index_list)
tong[unlist(index_list_unique), ]$제품명 <- product_name
tong[unlist(index_list_unique), ]$제조사 <- maker_name


# 콘텐츠(제목+상세설명)에서 스펙(용량)검사 + 용량 달아주기 -> 예시 : 32기가 검색
GB_name = "32GB"
GB_32 = c("32gb", "32g", "32 gb", "32 g", "32기가", "32 기가", "32")

GB_index_list = list()
for (search_p in GB_32){
  GB_index = grep(search_p, tong$contents)
  GB_index_list = append(GB_index_list, GB_index)
}
GB_index_list_unique = unique(GB_index_list)
tong[unlist(GB_index_list_unique), ]$용량 <- GB_name


# 출고가 달아주기
tong[ which( tong$용량 == "32GB" & tong$제품명 == "galaxy6") , ]$출고가 = 350000
