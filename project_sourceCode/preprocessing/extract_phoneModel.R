library(stringi)
library(stringr)
library(dplyr)

## step 0. 데이터 전처리 및 컬럼 생성 ##
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

tong_origin = read.csv("newdata6.csv", header = T, encoding="utf-8")# 중고나라 데이터 가져오기
phone_price = read.csv("lower_phonePrice.csv", header = T, encoding="utf-8") # 모델 출고가 데이터 가져오기
tong = tong_origin
tong$contents <- str_to_lower(tong$contents)
tong$제목 <- str_to_lower(tong$제목)
tong$상세설명 <- str_to_lower(tong$상세설명)
new_columns <- c("제품명", "용량", "출고가", "제조사")
tong[,new_columns] <- NA


## step 1. 저장 용량 사전 작업 ##
# 16GB
GB_name1 = "16gb"
GB1 = c("16gb", "16g", "16 gb", "16 g", "16기가", "16 기가")

# 32GB
GB_name2 = "32gb"
GB2 = c("32gb", "32g", "32 gb", "32 g", "32기가", "32 기가")

# 64GB
GB_name3 = "64gb"
GB3 = c("64gb", "64g", "64 gb", "64 g", "64기가", "64 기가")

# 128GB
GB_name4 = "128gb"
GB4 = c("128gb", "128g", "128 gb", "128 g", "128기가", "128 기가")

# 256GB
GB_name5 = "256gb"
GB5 = c("256gb", "256g", "256 gb", "256 g", "256기가", "256 기가")


## step 2. 제품명 사전 작업 ##
# 2.LG AKA
product_name2 = "aka"
maker_name2 = "lg"
dic2 = c("aka 폰", "aka폰", "aka", "아카폰", "아카 폰", "lg 아카 폰",
        "lg 아카폰", "lg아카폰", "lg aka 폰", "lg aka폰", "lgaka폰", "aka phone", "aka lg Phone", "lg-f520k")

# 3. LG Band play
product_name3 = "band play"
maker_name3 = "lg"
dic3 = c("band play", "bandplay", "밴드 플레이 폰", "밴드플레이 폰", "밴드플레이폰", "벤드 플레이 폰",
             "벤드플레이 폰", "벤드플레이폰", "band play phone", "bandplay phone", "band play 폰", "bandplay 폰",
             "lg 벤드 플레이 폰", "lg 벤드플레이 폰", "lg 밴드 플레이 폰", "lg 밴드 플레이", "lg band play", "lg bandplay",
             "lg 벤드 플레이", "lg 밴드 플레이", "lg-f570s"
)

# 4. Be Y Phone
product_name4 = "be y phone"
maker_name4 = "huawei"
dic4 = c("be y Phone", "bey phone", "비와이 폰", "비 와이 폰", "비와이폰", "비 와이폰", "bey폰",
             "bey 폰", "be y폰", "be y 폰", "be y phone", "bey phone", "be yphone", "beyphone",
             "비와이", "비 와이", "be y", "hw-vns-l62", "hw-vns-l62b", "화웨이 비와이 폰", "화웨이 비 와이 폰", "화웨이 비 와이")

# 5. BlackBerry Priv
product_name5 = "blackberry priv"
maker_name5 = "blackberry"
dic5 = c("blackberry priv", "블랙베리 프리브", "블랙베리프리브", "블랙배리 프리브", "블랙배리프리브", "블랙베리 프리브",
                   "STV100-3_OMD")

# 6. F70
product_name6 = "f70"
maker_name6 = "lg"
dic6 = c("lg-f370k", "lg-f370s", "lg-f370l", "lg-f70", "lg f70 phone", "lg f70 폰", "lg f70폰", "f70폰", "f70 폰", "f70 phone",
        "엘쥐f70폰", "엘지 f70 폰", "엘지 f70폰", "엘지f70폰"
)

# 7.G Flex
product_name7 = "g flex"
maker_name7 = "lg"
dic7 = c("g flex", "g-flex", "지 플렉스", "지-플렉스", "엘지지플렉스", "지플렉스", "지플렉스폰", "g-flex폰", "LG-F340K", "lg-f340s")


# 8. G Flex 2
product_name8 = "g flex2"
maker_name8 = "lg"
dic8 = c("g-flex2", "g-flex 2", "g flex 2", "g flex2", "지플렉스 2", "지 플렉스 2", "지플렉스2", "지 플렉스2",
           "쥐플렉스2", "쥐-플렉스2", "쥐 플렉스2","쥐 플렉스 2", "g-flex2폰", "g flex2폰"
)

# 9. G Stylo
product_name9 = "g stylo"
maker_name9 = "lg"
dic9 = c("g stylo", "gstylo", "지스타일로", "지 스타일로", "g stylo폰", "gstylo폰", "지스타일로폰", "지 스타일로폰", "lg지스타일로"
           ,"lg지스타일로폰","lg-f560k","lg지 스타일로폰")

# 10. G3
product_name10 = "g3"
maker_name10 = "lg"
dic10 = c("g3", "g쓰리", "지3", "지쓰리", "lgg3", "lg지쓰리", "지 쓰리", "lg지 쓰리", "g3폰", "g쓰리폰", "지쓰리폰", "lgg3폰",
       "lg지쓰리폰", "지 쓰리폰", "lg지 쓰리폰", "lg-f400S", "LG-F400S")

# 11. G3 Beat
product_name11 = "g3 beat"
maker_name11 = "lg"
dic11 = c("g3 beat", "g3beat", "g3-beat", "g쓰리beat", "지쓰리비트", "g쓰리비트", "g3비트", "지3beat", "지3비트", "lgg3beat",
           "lgg3 beat", "lgg3-beat", "lgg쓰리beat", "lg지쓰리비트", "lgg쓰리비트", "lgg3비트", "lg지3beat", "lg지3비트", "g3 beat폰",
           "g3beat폰", "g3-beat폰", "g쓰리beat폰", "지쓰리비트폰", "g쓰리비트폰", "g3비트폰", "지3beat폰", "지3비트폰", "lgg3beat폰",
           "lg3 beat폰", "lgg3-beat폰", "lgg쓰리beat폰", "lg지쓰리비트폰", "lgg쓰리비트폰", "lgg3비트폰", "lg지3beat폰", "lg지3비트폰",
           "lg-f470k", "lg-f470s"
)

# 12. G3 Cat.6
product_name12 = "g3 cat.6"
maker_name12 = "lg"
dic12 = c("g3cat6","g3 cat6", "g3 cat 6", "지3cat6", "g쓰리cat6", "g쓰리 cat6", "g쓰리 cat 6", "g3캣6", "g 3캣6", "g3 캣6", "g3캣 6", "g3cat식스", "g 3cat식스",
           "g3 cat식스", "g3cat 식스", "g3cat 식스", "지쓰리cat6", "지 쓰리cat6", "지쓰리 cat6", "지쓰리cat 6", "지3캣6", "지 3캣6", "지3 캣6", "지3캣 6",
           "지3cat6", "지 3cat6", "지3 cat6", "지3cat 6", "lgg3cat6", "lgg3 cat6", "lgg3cat 6", "엘지g3cat6", "엘지g3 cat6", "엘지g3cat 6",
           "g3cat6폰","g3 cat6폰", "g3 cat 6폰", "지3cat6폰", "g쓰리cat6폰", "g쓰리 cat6폰", "g쓰리 cat 6폰", "g3캣6폰", "g 3캣6폰", "g3 캣6폰", "g3캣 6폰", "g3cat식스폰", "g 3cat식스",
           "g3 cat식스폰", "g3cat 식스폰", "g3cat 식스폰", "지쓰리cat6폰", "지 쓰리cat6폰", "지쓰리 cat6폰", "지쓰리cat 6폰", "지3캣6폰", "지 3캣6폰", "지3 캣6폰", "지3캣 6폰",
           "지3cat6폰", "지 3cat6폰", "지3 cat6폰", "지3cat 6폰", "lgg3cat6폰", "lgg3 cat6폰", "lgg3cat 6폰", "엘지g3cat6폰", "엘지g3 cat6폰", "엘지g3cat 6폰",
           "lg-f460k"
)

# 13. G3A
product_name13 = "g3a"
maker_name13 = "lg"
dic13 = c("g3a", "g3 a", "g 3a", "지3a", "지 3a", "지3 a", "g쓰리a", "g 쓰리a", "g쓰리 a", "g3에이", "g 3에이", "g3 에이",
        "지쓰리a", "지 쓰리a", "지쓰리 a", "지쓰리에이", "지 쓰리에이", "지쓰리 에이", "lgg3a", "lgg3 a", "lgg 3a", "lg지3a", "lg지 3a", "lg지3 a", "lgg쓰리a", "lgg 쓰리a", "lgg쓰리 a", "lgg3에이", "lgg 3에이", "lgg3 에이",
        "lg지쓰리a", "lg지 쓰리a", "lg지쓰리 a", "lg지쓰리에이", "lg지 쓰리에이", "lg지쓰리 에이","g3a폰", "g3 a폰", "g 3a폰", "지3a폰", "지 3a폰", "지3 a폰", "g쓰리a폰", "g 쓰리a폰", "g쓰리 a폰", "g3에이폰", "g 3에이폰", "g3 에이폰",
        "지쓰리a폰", "지 쓰리a폰", "지쓰리 a폰", "지쓰리에이폰", "지 쓰리에이폰", "지쓰리 에이폰", "lgg3a폰", "lgg3 a폰", "lgg 3a폰", "lg지3a폰", "lg지 3a폰", "lg지3 a폰", "lgg쓰리a폰", "lgg 쓰리a폰", "lgg쓰리 a폰", "lgg3에이폰", "lgg 3에이폰", "lgg3 에이폰",
        "lg지쓰리a폰", "lg지 쓰리a폰", "lg지쓰리 a폰", "lg지쓰리에이폰", "lg지 쓰리에이폰", "lg지쓰리 에이폰", "lg-f410s"
)
# 14. G4 -> 통신사 별로 가격 다름
product_name14 = "g4"
maker_name14 = "lg"
dic14 = c("g4", "지4", "지포","g 4", "지 4", "지 포", "g포", "g 포", "lgg4", "lg지4", "lg지포","lgg 4", "lg지 4", "lg지 포", "lgg포", "lgg 포",
       "g4폰", "지4폰", "지포폰","g 4폰", "지 4폰", "지 포폰", "g포폰", "g 포폰", "lgg4폰", "lg지4폰", "lg지포폰","lgg 4폰", "lg지 4폰", "lg지 포폰", "lgg포폰", "lgg 포폰",
       "lg-f500k", "lg-f500kc", "lg-f500s", "lg-f500l"
)
# 15. Galaxy A3 2016
product_name15 = "galaxy a3 2016"
maker_name15 = "samsung"
dic15 = c("a3 2016", "a3(2016)", "a3 (2016)", "2016 a3", "2016년 a3", "a3 2016년")

# 16. 갤럭시 j3 (2016)
product_name16 = "galaxy j3 2016"
maker_name16 = "samsung"
dic16 = c("j3 2016", "j3(2016)", "j3 (2016)", "2016 j3", "2016년 j3", "j3 2016년")

# 17. 갤럭시 j5 (2017)
product_name17 = "galaxy j5 2017"
maker_name17 = "samsung"
dic17 = c("j5 2017", "j5(2017)", "j5 (2017)", "2017 j5", "2017년 j5", "j5 2017년")

# 18. 갤럭시 j7 (2017)
product_name18 = "galaxy j7 2017"
maker_name18 = "samsung"
dic18 = c("j7 2017", "j7(2017)", "j7 (2017)", "2017 j7", "2017년 j7", "j7 2017년")

# 19. 노트FE
product_name19 = "galaxy a3 2016"
maker_name19 = "samsung"
dic19 = c("노트fe", "노트 fe", "note fe", "notefe", "놋fe", "놋 fe", "갤놋fe", "겔놋fe",
          "sm-n935s", "sm n935s", "smn935s")

# 20 갤럭시 on7 (2016)
product_name20 = "galaxy on7 2016"
maker_name20 = "samsung"
dic20 = c("on7 2016", "on7(2016)", "on7 (2016)", "2016 on7", "2016년 on7", "on7 2016년")

# 21 Galaxy S3
product_name21 = "galaxy s3"
maker_name21 = "samsung"
dic21 = c("gallaxy s3", "gallaxys3",  "gallaxy s 3", "겔럭시 s3", "겔럭시s3", "겔럭시 s3", "겔럭시 에스3", "겔럭시에스3", "겔럭시에스쓰리", "겔럭시 에스쓰리", "겔럭시 에스 쓰리",
          "삼성gallaxy s3", "삼성gallaxys3",  "삼성gallaxy s 3", "삼성겔럭시 s3", "삼성겔럭시s3", "삼성겔럭시 s3", "삼성겔럭시 에스3", "삼성겔럭시에스3", "삼성겔럭시에스쓰리", "삼성겔럭시 에스쓰리", "삼성겔럭시 에스 쓰리",
          "gallaxy s3폰", "gallaxys3폰",  "gallaxy s 3폰", "겔럭시 s3폰", "겔럭시s3폰", "겔럭시 s3폰", "겔럭시 에스3폰", "겔럭시에스3폰", "겔럭시에스쓰리폰", "겔럭시 에스쓰리폰", "겔럭시 에스 쓰리폰",
          "삼성gallaxy s3폰", "삼성gallaxys3폰",  "삼성gallaxy s 3폰", "삼성겔럭시 s3폰", "삼성겔럭시s3폰", "삼성겔럭시 s3폰", "삼성겔럭시 에스3폰", "삼성겔럭시에스3폰", "삼성겔럭시에스쓰리폰", "삼성겔럭시 에스쓰리폰", "삼성겔럭시 에스 쓰리폰",
          "shv-e210l16", "shw-m440s"
            )

# 22 Galaxy Tab A 10.1
product_name22 = "galaxy tab a 10.1"
maker_name22 = "samsung"
dic22 = c("galaxy tab a 10.1", "galaxytab a 10.1", "galaxytab a10.1", "galaxy tab a10.1",
          "겔럭시 tab a 10.1", "겔럭시tab a 10.1", "겔럭시tab a10.1", "겔럭시 tab a10.1",
          "galaxy 탭 a 10.1", "galaxy탭 a 10.1", "galaxy탭 a10.1", "galaxy 탭 a10.1",
          "겔럭시 탭 a 10.1", "겔럭시탭 a 10.1", "겔럭시탭 a10.1", "겔럭시 탭 a10.1",
          "삼성galaxy tab a 10.1", "삼성galaxytab a 10.1", "삼성galaxytab a10.1", "삼성galaxy tab a10.1",
          "삼성겔럭시 tab a 10.1", "삼성겔럭시tab a 10.1", "삼성겔럭시tab a10.1", "삼성겔럭시 tab a10.1",
          "삼성galaxy 탭 a 10.1", "삼성galaxy탭 a 10.1", "삼성galaxy탭 a10.1", "삼성galaxy 탭 a10.1",
          "삼성겔럭시 탭 a 10.1", "삼성겔럭시탭 a 10.1", "삼성겔럭시탭 a10.1", "삼성겔럭시 탭 a10.1",
          "galaxy tab a 10.1폰", "galaxytab a 10.1폰", "galaxytab a10.1폰", "galaxy tab a10.1폰",
          "겔럭시 tab a 10.1폰", "겔럭시tab a 10.1폰", "겔럭시tab a10.1폰", "겔럭시 tab a10.1폰",
          "galaxy 탭 a 10.1폰", "galaxy탭 a 10.1폰", "galaxy탭 a10.1폰", "galaxy 탭 a10.1폰",
          "겔럭시 탭 a 10.1폰", "겔럭시탭 a 10.1폰", "겔럭시탭 a10.1폰", "겔럭시 탭 a10.1폰",
          "삼성galaxy tab a 10.1폰", "삼성galaxytab a 10.1폰", "삼성galaxytab a10.1폰", "삼성galaxy tab a10.1폰",
          "삼성겔럭시 tab a 10.1폰", "삼성겔럭시tab a 10.1폰", "삼성겔럭시tab a10.1폰", "삼성겔럭시 tab a10.1폰",
          "삼성galaxy 탭 a 10.1폰", "삼성galaxy탭 a 10.1폰", "삼성galaxy탭 a10.1폰", "삼성galaxy 탭 a10.1폰",
          "삼성겔럭시 탭 a 10.1폰", "삼성겔럭시탭 a 10.1폰", "삼성겔럭시탭 a10.1폰", "삼성겔럭시 탭 a10.1폰"
          )

# 23 Galaxy Tab S3 LTE
product_name23 = "galaxy tab s3 lte"
maker_name23 = "samsung"
dic23 = c("galaxy tab s3 lte", "galaxytab s3 lte", "galaxy tab s3lte", "galaxytab s3lte",
          "겔럭시 tab s3 lte", "겔럭시tab s3 lte", "겔럭시 tab s3lte", "겔럭시tab s3lte",
          "갤럭시 tab s3 lte", "갤럭시tab s3 lte", "갤럭시 tab s3lte", "갤럭시tab s3lte",
          "galaxy 탭 s3 lte", "galaxy탭s3 lte", "galaxy 탭 s3lte", "galaxy탭 s3lte",
          "겔럭시 탭 s3 lte", "겔럭시탭 s3 lte", "겔럭시 탭 s3lte", "겔럭시탭 s3lte",
          "갤럭시 탭 s3 lte", "갤럭시탭 s3 lte", "갤럭시 탭 s3lte", "갤럭시탭 s3lte",
          "삼성galaxy tab s3 lte", "삼성galaxytab s3 lte", "삼성galaxy tab s3lte", "삼성galaxytab s3lte",
          "삼성겔럭시 tab s3 lte", "삼성겔럭시tab s3 lte", "삼성겔럭시 tab s3lte", "삼성겔럭시tab s3lte",
          "삼성갤럭시 tab s3 lte", "삼성갤럭시tab s3 lte", "삼성갤럭시 tab s3lte", "삼성갤럭시tab s3lte",
          "삼성galaxy 탭 s3 lte", "삼성galaxy탭s3 lte", "삼성galaxy 탭 s3lte", "삼성galaxy탭 s3lte",
          "삼성겔럭시 탭 s3 lte", "삼성겔럭시탭 s3 lte", "삼성겔럭시 탭 s3lte", "삼성겔럭시탭 s3lte",
          "삼성갤럭시 탭 s3 lte", "삼성갤럭시탭 s3 lte", "삼성갤럭시 탭 s3lte", "삼성갤럭시탭 s3lte",
          "galaxy tab s3 lte폰", "galaxytab s3 lte폰", "galaxy tab s3lte폰", "galaxytab s3lte폰",
          "겔럭시 tab s3 lte폰", "겔럭시tab s3 lte폰", "겔럭시 tab s3lte폰", "겔럭시tab s3lte폰",
          "갤럭시 tab s3 lte폰", "갤럭시tab s3 lte폰", "갤럭시 tab s3lte폰", "갤럭시tab s3lte폰",
          "galaxy 탭 s3 lte폰", "galaxy탭s3 lte폰", "galaxy 탭 s3lte폰", "galaxy탭 s3lte폰",
          "겔럭시 탭 s3 lte폰", "겔럭시탭 s3 lte폰", "겔럭시 탭 s3lte폰", "겔럭시탭 s3lte폰",
          "갤럭시 탭 s3 lte폰", "갤럭시탭 s3 lte폰", "갤럭시 탭 s3lte폰", "갤럭시탭 s3lte폰",
          "삼성galaxy tab s3 lte폰", "삼성galaxytab s3 lte폰", "삼성galaxy tab s3lte폰", "삼성galaxytab s3lte폰",
          "삼성겔럭시 tab s3 lte", "삼성겔럭시tab s3 lte", "삼성겔럭시 tab s3lte폰", "삼성겔럭시tab s3lte폰",
          "삼성갤럭시 tab s3 lte폰", "삼성갤럭시tab s3 lte폰", "삼성갤럭시 tab s3lte", "삼성갤럭시tab s3lte",
          "삼성galaxy 탭 s3 lte폰", "삼성galaxy탭s3 lte폰", "삼성galaxy 탭 s3lte폰", "삼성galaxy탭 s3lte폰",
          "삼성겔럭시 탭 s3 lte폰", "삼성겔럭시탭 s3 lte폰", "삼성겔럭시 탭 s3lte폰", "삼성겔럭시탭 s3lte폰",
          "삼성갤럭시 탭 s3 lte폰", "삼성갤럭시탭 s3 lte폰", "삼성갤럭시 탭 s3lte폰", "삼성갤럭시탭 s3lte폰",
          "sm-t825n0"
          )


# 24. G PRO2
product_name24 = "g pro2"
maker_name24 = "lg"
dic24 = c("gpro2", "gpro2폰", "g pro2", "g pro 2", "지프로2", "지프로2폰", "지 프로2", "지 프로2폰", "g 프로2", "g 프로 2", "쥐프로2",
          "쥐프로2폰", "g프로2폰", "g 프로2폰", "lg-f350s"
)

# 25 IM-100
product_name25 = "im-100"
maker_name25 = "sky"
dic25 = c("im-100", "아임백", "im100", "im 100", "아임 백",
          "스카이im-100", "스카이아임백", "스카이im100", "스카이im 100", "스카이아임 백",
          "im-100폰", "아임백폰", "im100폰", "im 100폰", "아임 백폰",
          "스카이im-100폰", "스카이아임백폰", "스카이im100폰", "스카이im 100폰", "스카이아임 백폰"

)

# 26 iPhone 5
product_name26 = "iphone 5"
maker_name26 = "apple"
dic26 = c("iphone 5", "iphone5", "i phone5", "i phone 5", "아이phone 5", "아이phone5", "아이 phone5", "아이 phone 5",
          "i폰 5", "i폰5", "i 폰5", "i 폰 5", "아이폰 5", "아이폰5", "아이 폰5", "아이 폰 5",
          "애플iphone 5", "애플iphone5", "애플i phone5", "애플i phone 5", "애플아이phone 5", "애플아이phone5", "애플아이 phone5", "애플아이 phone 5",
          "애플i폰 5", "애플i폰5", "애플i 폰5", "애플i 폰 5", "애플아이폰 5", "애플아이폰5", "애플아이 폰5", "애플아이 폰 5"
)

# 27. iPhone 5s
product_name27 = "iphone 5s"
maker_name27 = "apple"
dic27 = c("iphone 5s", "iphone5s", "i phone5s", "i phone 5s", "아이phone 5s", "아이phone5s", "아이 phone5s", "아이 phone 5s",
          "i폰 5s", "i폰5s", "i 폰5s", "i 폰 5s", "아이폰 5s", "아이폰5s", "아이 폰5s", "아이 폰 5s",
          "애플iphone 5s", "애플iphone5s", "애플i phone5s", "애플i phone 5s", "애플아이phone 5s", "애플아이phone5s", "애플아이 phone5s", "애플아이 phone 5s",
          "애플i폰 5s", "애플i폰5s", "애플i 폰5s", "애플i 폰 5s", "애플아이폰 5s", "애플아이폰5s", "애플아이 폰5s", "애플아이 폰 5s", "아이폰s5", "아이폰 s5"
)

# 28. 아이폰6s
product_name28 = "iphone 6s"
maker_name28 = "apple"
dic28 = c("iphone 6s", "iphone6s", "i phone6s", "i phone 6s", "아이phone 6s", "아이phone6s", "아이 phone6s", "아이 phone 6s",
          "i폰 6s", "i폰6s", "i 폰6s", "i 폰 6s", "아이폰 6s", "아이폰6s", "아이 폰6s", "아이 폰 6s",
          "애플iphone 6s", "애플iphone6s", "애플i phone6s", "애플i phone 6s", "애플아이phone 6s", "애플아이phone6s", "애플아이 phone6s", "애플아이 phone 6s",
          "애플i폰 6s", "애플i폰6s", "애플i 폰6s", "애플i 폰 6s", "애플아이폰 6s", "애플아이폰6s", "애플아이 폰6s", "애플아이 폰 6s", "아이폰s6", "아이폰 s6", "아이폰s 6"
)


# 29. iPhone 6 Plus
product_name29 = "iphone 6 plus"
maker_name29 = "apple"
dic29 = c( "아이폰 6\\+", "iphone6\\+", "iphone 6\\+", "i폰6\\+", "아이phone6\\+", "아이phone 6\\+",
            "아이폰식스\\+", "아이폰 식스\\+", "아이폰 식스 플러스", "아이폰6 플러스", "아이폰6플러스", "iphone6 플러스",
            "iphone 6 플러스", "iphone6플러스", "iphone 6플러스", "6 플러스", "6플러스", "식스 플러스", "식스플러스",
            "6 plus", "6plus", "iphone6plus", "식스 plus", "식스plus", "아이폰6\\+플러스", "아이폰6\\+")

# 30. iPhone 7
product_name30 = "iphone 7"
maker_name30 = "apple"
dic30 = c("아이폰7", "아이폰 7", "iphone7", "iphone 7", "i폰7", "i 폰7", "i 폰 7", "아이phone7", "아이phone 7",
          "i phone 7", "아이폰세븐", "아이폰 세븐")

# 31. iphone 7 plus
product_name31 = "iphone 7 plus"
maker_name31 = "apple"
dic31 = c("아이폰7\\+", "아이폰 7\\+", "iphone7\\+", "iphone 7\\+", "i폰7\\+", "i 폰7\\+", "i 폰 7\\+", "아이phone7\\+", "아이phone 7\\+",
          "i phone 7\\+", "아이폰세븐\\+", "아이폰 세븐\\+", "아이폰 세븐 플러스", "아이폰7 플러스", "아이폰7플러스", "iphone7 플러스",
          "iphone 7 플러스", "iphone7플러스", "iphone 7플러스", "7 플러스", "7플러스", "세븐 플러스", "세븐플러스",
          "7 plus", "7plus", "iphone7plus", "세븐 plus", "세븐plus")

# 32. iphone SE
product_name32 = "iphone se"
maker_name32 = "apple"
dic32 = c("아이폰se", "아이폰 se", "iphone se", "i phone se", "AIPSE-16SG", "AIPSE-16RG"
         ,"AIPSE-16SV", "AIPSE-16GD", "AIPSE-64GD", "AIPSE-64SV"
         ,"AIPSE-64RG", "AIPSE-64SG")

# 33. 헬로키티폰
product_name33 = "헬로키티폰"
maker_name33 = "ola"
dic33 = c("카뮤즈-헬로키티폰", "헬로키티폰", "키티폰", "카뮤즈 헬로키티폰", "헬로 키티 폰"
         , "카뮤즈 키티폰", "KM-K01S")

# 34. LG CLASS
product_name34 = "lg class"
maker_name34 = "lg"
dic34 = c("lg-class", "lg-class", "lg class", "lg 클래스", "lg-클래스", "엘지-클래스폰"
         , "엘지 클래스폰", "엘지 클래스", "엘지 클레스", "앨지 클래스", "앨지 클레스"
         , "엘지 클레스폰", "앨지 클래스폰", "앨지 클레스폰", "LG-F620K", "LG-F620S", "LG-F620L")

# 35. LG G2
product_name35 = "lg g2"
maker_name35 = "lg"
dic35 = c("lg g2", "lg-g2", "엘지 g2", "앨지 g2", "g2폰", "lg g2폰", "지투"
         ,"엘지-g2", "앨지-g2", "LG-F320L")

# 36. LG G3 스크린
product_name36 = "lg g3 screen"
maker_name36 = "lg"
dic36 = c("g3-스크린", "g3 스크린", "스크린폰", "g3스크린", "LG-F490L")

# 37. G5
product_name37 = "lg g5"
maker_name37 = "lg"
dic37 = c("g5", "g 5", "지5", "지 5", "g파이브", "g 파이브", "지파이브", "지 파이브", "lgg5", "lgg 5", "lg지5", "lg지 5", "lgg파이브", "lgg 파이브", "lg지파이브", "lg지 파이브",
       "g5폰", "g 5폰", "지5폰", "지 5폰", "g파이브폰", "g 파이브폰", "지파이브폰", "지 파이브폰", "lgg5폰", "lgg 5폰", "lg지5폰", "lg지 5폰", "lgg파이브폰", "lgg 파이브폰", "lg지파이브폰", "lg지 파이브폰",
       "lg-f700s"
)

# 38. LG G6
product_name38 = "lg g6"
maker_name38 = "lg"
dic38 = c("lg-g6", "g6폰", "lg g6", "엘지 g6", "앨지 g6", "앨지-g6", "엘지-g6"
          , "엘쥐-g6", "앨쥐 g6", "엘쥐-g6", "LGM-G600S", "LGM-G600L"
          , "LGM-G600LR", "LGM-G600SR_32GG", "LGM-G600KR", "LGM-G600K")

# 39. LG G6 블랙에디션
product_name39 = "lg g6 블랙에디션"
maker_name39 = "lg"
dic39 = c("g6 블랙에디션", "g6 블랙애디션", "g6 블렉에디션", "g6 블렉애디션"
          , "g6 black edition", "g6-블랙에디션", "g6 블랙 에디션", "LGM-G600KFB")

# 40. LG G6+
product_name40 = "lg g6 plus"
maker_name40 = "lg"
dic40 = c("lg g6\\+", "lg-g6\\+", "g6\\+", "엘지 g6\\+", "앨지 g6\\+", "LGM-G600SP_128G", "LGM-G600KP")

# 41. LG GX
product_name41 = "lg gx"
maker_name41 = "lg"
dic41 = c("lg gx", "lg-gx", "gx", "엘지 gx", "앨지 gx", "LG-F310LR", "LG-F310L")

# 42. LG K10
product_name42 = "lg k10"
maker_name42 = "lg"
dic42 = c("lg k10", "k10", "k 10", "k-10", "lg k-10", "LG-F670S", "LG-F670L", "LG-F670K")

# 43. LG Stylus2
product_name43 = "lg stylus2"
maker_name43 = "lg"
dic43 = c("lg stylus2",  "stylus2", "스타일러스", "스타일 러스", "stylus 2", "stylus-2", "LG-F720K")

# 44. LG V10
product_name44 = "lg v10"
maker_name44 = "lg"
dic44 = c("lg v10", "엘지 v10", "앨지 v10", "앨지-v10", "엘지-v10", "LG-F600L", "LG-F600K")

# 45. LG V20
product_name45 = "lg v20"
maker_name45 = "lg"
dic45 = c("lg v20", "엘지 v20", "앨지 v20", "앨지-v20", "엘지-v20", "LG-F800L", "LG-F800K")

# 46. LG X screen
product_name46 = "lg x screen"
maker_name46 = "lg"
dic46 = c("lg x-screen", "x-screen", "x screen", "엑스 스크린", "LG-F650K", "LG-F650L")

# 47. LG X skin
product_name47 = "lg x skin"
maker_name47 = "lg"
dic47 = c("lg x-skin", "x-skin", "x skin", "x-스킨", "x스킨", "LG-F740L")

# 48. LG X300
product_name48 = "lg x300"
maker_name48 = "lg"
dic48 = c("lg x300", "lg-x300", "앨지 x300", "앨지-x300", "엘지-x300", "엘지 x300"
          , "LGM-K120L", "LGM-K120K", "LGM-K120S")

# 49. LG X400
product_name49 = "lg x400"
maker_name49 = "lg"
dic49 = c("lg x400", "lg-x400", "앨지 x400", "앨지-x400", "엘지-x400", "엘지 x400"
          , "LGM-K121K", "LGM-K121S", "LGM-K121L")

# 50. LG X5
product_name50 = "lg x5"
maker_name50 = "lg"
dic50 = c("lg x5", "lg-x5", "앨지 x5", "앨지-x5", "엘지-x5", "LG-F770S")

# 51. LG X500
product_name51 = "lg x500"
maker_name51 = "lg"
dic51 = c("lg x500", "lg-x500", "앨지 x500", "앨지-x500", "엘지-x500", "엘지 x500"
          , "LGM-X320K", "LGM-X320S")

# 52. LG 아이스크림스마트
product_name52 = "lg iscream smart"
maker_name52 = "lg"
dic52 = c("아이스크림스마트", "아이스크림 스마트", "ice cream smart", "아이스 크림 스마트"
          ,"아이스크림 smart", "LG-F440L")

# 53. LG 젠틀
product_name53 = "lg 젠틀"
maker_name53 = "lg"
dic53 = c("lg 젠틀", "lg-gentle", "lg gentle", "lg-젠틀", "앨지-젠틀", "엘지-젠틀"
          , "앨지 잰틀", "엘지 잰틀", "엘지 젠틀", "lg-f580l")


# 54. LG-X-CAM
product_name54 = "lg x-cam"
maker_name54 = "lg"
dic54 = c("lgx-cam", "lg-x-cam", "엘지x-cam", "엘지-x-cam",
          "lg엑스-cam", "lg-엑스-cam", "엘지엑스-cam", "엘지-엑스-cam",
          "lgx-캠", "lg-x-캠", "엘지x-캠", "엘지-x-캠",
          "lg엑스-캠", "lg-엑스-캠", "엘지엑스-캠", "엘지-엑스-캠",
          "x-cam", "엑스-cam", "x-캠", "엑스-캠",
          "lgx-cam폰", "lg-x-cam폰", "엘지x-cam폰", "엘지-x-cam폰",
          "lg엑스-cam폰", "lg-엑스-cam폰", "엘지엑스-cam폰", "엘지-엑스-cam폰",
          "lgx-캠폰", "lg-x-캠폰", "엘지x-캠폰", "엘지-x-캠폰",
          "lg엑스-캠폰", "lg-엑스-캠폰", "엘지엑스-캠폰", "엘지-엑스-캠폰",
          "x-cam폰", "엑스-cam폰", "x-캠폰", "엑스-캠폰",
          "lg-f690l"
          )

# 55. LG-U
product_name55 = "lg u"
maker_name55 = "lg"
dic55 = c("lg-u", "lg u", "엘지 U", "엘지 유",
          "lg-u폰", "lg u폰", "엘지 U폰", "엘지 유폰",
          "lg-f820l"
          )

# 56. LUNA
product_name56 = "luna"
maker_name56 = "tg"
dic56 = c("luna", "루나", "tg루나", "tg 루나",
          "luna폰", "루나폰", "tg루나폰", "tg 루나폰",
          "tg-l800s"
          )


# 57. NEXUS 5X
product_name57 = "nexus 5x"
maker_name57 = "lg"
dic57 = c("nexus 5x", "nexus5x", "넥서스 5x", "nexus 5엑스", "넥서스 5엑스",
          "lgnexus 5x", "lgnexus5x", "lg넥서스 5x", "lgnexus 5엑스", "lg넥서스 5엑스",
          "nexus 5x폰", "nexus5x폰", "넥서스 5x폰", "nexus 5엑스폰", "넥서스 5엑스폰",
          "lgnexus 5x폰", "lgnexus5x폰", "lg넥서스 5x폰", "lgnexus 5엑스폰", "lg넥서스 5엑스폰",
          "lg-h791_32g", "LG-H791_32G", "lg-h791_16g", "lg-h791", "넥서스5x"
)


# 58. Nexus6p
product_name58 = "nexus 6p"
maker_name58 = "google"
dic58 = c("넥서스6p", "넥서스 6p", "nexus6p", "nexus 6p", "넥 6p", "넥6p", "h1512", "h-1512", "h 1512")

# 59. OMD SONY XZ
product_name59 = "omd sony xz"
maker_name59 = "sony"
dic59 = c("sony xz", "sonyxz", "sonyxperiaxz", "xz", "엑스지", "엑스페리아 엑스지", "엑스페리아xz",
          "xperia xz", "sony xperia xz", "소니xz", "소니 xz","소니엑스지",
          "xz 소니", "xz소니", "소니엑스지", "소니 엑스페리아 엑스지", "엑스페리아 xz")

# 60. OMD SONY XZP(OMD SONY XZP)
product_name60 = "xperia xz"
maker_name60 = "sony"
dic60 = c("sony xzp", "sonyxzp", "sony xperia xzp", "sony xz premium", "sony xperia premium",
          "소니 xzp", "소니xzp", "소니 premium xz", "sony xzp", "xperia xzp",
          "소니 프리미엄 xz", "엑스페리아 XZ 프리미엄", "xperia xz premium",
          "xzp", "엑스지피", "엑스지 프리미엄", "xz 프리미엄", "xz프리미엄", "xz premium")

# 61. q6
product_name61 = "q6"
maker_name61 = "lg"
dic61 = c("q6", "큐6", "q식스", "qsix", "q six", "q 6", "큐식스", "큐 식스",
          "lgm-x600k", "lg x600k", "lg-x600k", "lgm x600k")

# 62. 키즈폰 준3 어벤져스 스페셜 에디션 - 추가 사전 필요
product_name62 = "joon"
maker_name62 = "infomark"
dic62 = c("sd-w530s", "sdw530s", "sd w530s", "키즈폰 준3 어벤져스 스페셜 에디션", "sd-w530s")


# 63. 갤럭시S8
product_name63 = "galaxy s8"
maker_name63 = "samsung"
dic63 = c("sm-g950nbk", "sm-g950ngr", "sm-g950nbe", "sm-g950nsr",
          "갤럭시 8", "갤8", "갤럭시8", "갤 8", "갤s8", "갤럭시s8", "겔럭시8",
          "겔럭시 s8", "겔8", "겔s8", "겔 s8", "갤 s8", "삼성 s8",
          "삼성 겔8", "삼성갤8", "삼성 갤8", "삼성갤 8", "삼성겔8", "삼성겔 8")


# 64. 갤럭시 wide2
product_name64 = "galaxy wide2"
maker_name64 = "samsung"
dic64 = c("갤와이드2", "겔와이드2", "wide2", "wide 2", "와이드2", "와이드 2",
          "sm-j727s", "sm j727s", "smj727s")

# 65. Sol Prime
product_name65 = "sol prime"
maker_name65 = "alcatel-lucent"
dic65 = c("sol prime", "solprime", "솔프라임", "솔 프라임", "쏠프라임", "쏠 프라임")

# 66. VU3
product_name66 = "vu3"
maker_name66 = "lg"
dic66 = c("뷰3", "뷰 3", "vu3", "vu 3", "lg-f300s", "lg f300s", "lgf300s")

# 67. x power
product_name67 = "x power"
maker_name67 = "lg"
dic67 = c("엑스파워", "엑스 파워", "x-power", "x power", "xpower", "lg-f750k", "lg f750k", "lgf750k")

# 68.  Xperia X Performance
product_name68 = "xperia x performance"
maker_name68 = "sony"
dic68 = c("xperia x performance", "엑스페리아 x performance", "xperia 엑스 performance", "xperia x 퍼포먼스",
          "엑스페리아 엑스 performance", "엑스페리아 x 퍼포먼스", "xperia 엑스 퍼포먼스", "엑스페리아 엑스 퍼포먼스",
          "xperia x performance폰", "엑스페리아 x performance폰", "xperia 엑스 performance폰", "xperia x 퍼포먼스폰",
          "엑스페리아 엑스 performance폰", "엑스페리아 x 퍼포먼스폰", "xperia 엑스 퍼포먼스폰", "엑스페리아 엑스 퍼포먼스폰",
          "Xperia XP",  "엑스페리아 XP", "Xperia 엑스피", "Xperia XP",  "Xperia XP폰",  "엑스페리아 XP폰", "Xperia 엑스피폰", "Xperia XP폰"
          )

# 69. Xperia XZ
product_name69 = "xperia xz"
maker_name69 = "sony"
dic69 = c("xperia xz", "엑스페리아 xz", "xperia 엑스제트", "xperia x제트", "엑스페리아 엑스제트",
          "xperia xz폰", "엑스페리아 xz폰", "xperia 엑스제트폰", "xperia x제트폰", "엑스페리아 엑스제트폰"
          )

# 70. Xperia Z2
product_name70 = "xperia z2"
maker_name70 = "sony"
dic70 = c("엑스페리아z2", "xperia z2", "소니 엑스페리아 z2", "엑스페리아 z2", "소니 z2", "소니z2")

# 71. Xperia Z3
product_name71 = "xperia z3"
maker_name71 = "sony"
dic71 = c("엑스페리아z3", "xperia z3", "소니 엑스페리아 z3", "엑스페리아 z3", "소니 z3", "소니z3")

# 72. XPR-C3
product_name72 = "xpr-c3"
maker_name72 = "sony"
dic72 = c("xpr-c3", "엑스피알-c3", "xpr-씨3", "소니-c3", "소니 c3", "엑스페리아-c3", "엑스페리아 c3", "xpr-c3폰", "엑스페리아 c3폰",
          "엑스페리아c3"
          )

# 73. Y6
product_name73 = "y6"
maker_name73 = "huawei"
dic73 = c("y6", "y 6", "hw-scl-l32", "hw scl l32", "화웨이y6", "화웨이y6폰")

# 74. galaxy A5 2015
product_name74 = "galaxy a5 2015"
maker_name74 = "samsung"
dic74 = c("galaxya5 2015", "galaxya5 (2015)", "겔럭시 a5 2015", "갤럭시 a5 2015", "galaxy 에이5 2015", "겔럭시 에이5 2015",
          "galaxya5 2015폰", "galaxy a5 (2015)폰", "겔럭시a5 2015폰", "갤럭시a5 2015폰", "galaxy에이5 2015폰", "겔럭시에이5 2015폰",
          "a5 2015", "a5 (2015)", "(2015) a5", "a5 2015폰", "a5 (2015)폰", "(2015) a5폰"
          )

# 75. galaxy a5 2017
product_name75 = "galaxy a5 2017"
maker_name75 = "samsung"
dic75 = c("a5 2017", "a5(2017)", "a5 (2017)", "2017 a5", "2017년 a5", "a5 2017년")

# 76. 갤럭시 A7 2015
product_name76 = "galaxy a7 2015"
maker_name76 = "samsung"
dic76 = c("galaxya7 2015", "galaxya7 (2015)", "겔럭시 a7 2015", "갤럭시 a7 2015", "galaxy 에이7 2015", "겔럭시 에이7 2015",
          "galaxya7 2015폰", "galaxy a7 (2015)폰", "겔럭시a7 2015폰", "갤럭시a7 2015폰", "galaxy에이7 2015폰", "겔럭시에이7 2015폰",
          "a7 2015", "a7 (2015)", "(2015) a7", "a7 2015폰", "a7 (2015)폰", "(2015) a7폰"
)


# 77. 갤럭시 알파
product_name77 = "galaxy alpha"
maker_name77 = "samsung"
dic77 = c("갤럭시 알파", "겔럭시 알파", "갤럭시알파", "galaxy alpha", "갤럭시 alpha", "갤럭시alpha",
          "갤럭시 알파폰", "겔럭시 알파폰", "갤럭시알파폰", "galaxy alpha폰", "갤럭시 alpha폰", "갤럭시alpha폰",
          "삼성갤럭시 알파", "삼성겔럭시 알파", "삼성갤럭시알파", "삼성galaxy alpha", "삼성갤럭시 alpha", "삼성갤럭시alpha",
          "삼성갤럭시 알파폰", "삼성겔럭시 알파폰", "삼성갤럭시알파폰", "삼성galaxy alpha폰", "삼성갤럭시 alpha폰", "삼성갤럭시alpha폰"
          )

# 78. galaxy J5 sence
product_name78 = "galaxy j5 sence"
maker_name78 = "samsung"
dic78 = c("sm-j500n00", "갤럭시센스", "갤럭시센스", "겔럭시센스", "겔럭시 센스", "갤럭시센스j5", "갤럭시센스 j5", "겔럭시센스j5", "겔럭시센스j5")

# 79. 갤럭시 j5 (2016)
product_name79 = "galaxy j5 2016"
maker_name79 = "samsung"
dic79 = c("j5 2016", "j5(2016)", "j5 (2016)", "2016 j5", "2016년 j5", "j5 2016년")

# 80. 갤럭시 j7 (2016)
product_name80 = "galaxy j7 2016"
maker_name80 = "samsung"
dic80 = c("j7 2016", "j7(2016)", "j7 (2016)", "2016 j7", "2016년 j7", "j7 2016년")


# 81. 갤럭시 그랜드맥스 & 맥스
product_name81 = "galaxy grand max"
maker_name81 = "samsung"
dic81 = c("sm-g720n0", "갤그맥", "갤grandmax", "겔grandmax", "갤 grandmax", "겔 grandmax",
                    "갤럭시그랜드맥스", "갤럭시 그랜드 맥스", "갤럭시 그랜드맥스",
                    "겔그맥", "겔그맥", "겔럭시그랜드맥스", "겔럭시 그랜드 맥스", "겔럭시 그랜드맥스",
                    "갤럭시grandmax", "갤럭시 grandmax", "galaxygrandmax","galaxy grandmax", "galaxy grand max",
                    "갤럭시 맥스", "겔럭시 맥스", "갤럭시맥스", "galaxy max", "갤럭시 max", "갤럭시max"
)

# 82. 갤럭시 라운드
product_name82 = "galaxy round"
maker_name82 = "samsung"
dic82 = c("갤럭시 라운드", "겔럭시 라운드", "갤럭시라운드", "galaxy round", "갤럭시 round", "갤럭시round")

# 83. 갤럭시s4
product_name83 = "galaxy s4"
maker_name83 = "samsung"
dic83 = c("갤럭시 4", "갤4", "갤럭시4", "갤 4", "갤s4", "갤럭시s4", "겔럭시4", "겔럭시 4", "겔4", "겔s4", "겔 s4", "갤 s4",
          "삼성 s4", "삼성 겔4", "삼성갤4", "삼성 갤4", "삼성갤 4", "삼성겔4", "삼성겔 4", "갤럭시 s4", "겔럭시 s4",
          "galaxy4", "galaxy 4", "겔럭시s4", "s4", "s4폰")

# 84. 갤럭시 S4 LTE-A
product_name84 = "galaxy s4 lte-a"
maker_name84 = "samsung"
dic84 = c("galaxy s4 lte-a", "galaxys4 lte-a", "galaxy s4lte-a", "galaxys4lte-a",
          "갤럭시 s4 lte-a", "갤럭시s4 lte-a", "갤럭시 s4lte-a", "갤럭시s4lte-a",
          "겔럭시 s4 lte-a", "겔럭시s4 lte-a", "겔럭시 s4lte-a", "겔럭시s4lte-a",
          "겔럭시 에스4 lte-a", "겔럭시에스4 lte-a", "겔럭시 에스4lte-a", "겔럭시에스4lte-a",
          "galaxy s4 lte-a폰", "galaxys4 lte-a폰", "galaxy s4lte-a폰", "galaxys4lte-a폰",
          "갤럭시 s4 lte-a폰", "갤럭시s4 lte-a폰", "갤럭시 s4lte-a폰", "갤럭시s4lte-a폰",
          "겔럭시 s4 lte-a폰", "겔럭시s4 lte-a폰", "겔럭시 s4lte-a폰", "겔럭시s4lte-a폰",
          "겔럭시 에스4 lte-a폰", "겔럭시에스4 lte-a폰", "겔럭시 에스4lte-a폰", "겔럭시에스4lte-a폰"
          )

# 85. 갤럭시 S5 광대역 LTE-A
product_name85 = "galaxy s5 광대역 lte-a"
maker_name85 = "samsung"
dic85 = c("galaxy s5 광대역 lte-a", "galaxys5 광대역 lte-a", "galaxy s5광대역 lte-a", "galaxy s5 광대역lte-a",
          "galaxys5광대역 lte-a", "galaxys5 광대역lte-a", "galaxy s5광대역lte-a", "galaxys5광대역lte-a",
          "갤럭시 s5 광대역 lte-a", "갤럭시s5 광대역 lte-a", "갤럭시 s5광대역 lte-a", "갤럭시 s5 광대역lte-a",
          "갤럭시s5광대역 lte-a", "갤럭시s5 광대역lte-a", "갤럭시 s5광대역lte-a", "갤럭시s5광대역lte-a",
          "galaxy s5 광대역 lte-a폰", "galaxys5 광대역 lte-a폰", "galaxy s5광대역 lte-a폰", "galaxy s5 광대역lte-a폰",
          "galaxys5광대역 lte-a폰", "galaxys5 광대역lte-a폰", "galaxy s5광대역lte-a폰", "galaxys5광대역lte-a폰",
          "갤럭시 s5 광대역 lte-a폰", "갤럭시s5 광대역 lte-a폰", "갤럭시 s5광대역 lte-a폰", "갤럭시 s5 광대역lte-a폰",
          "갤럭시s5광대역 lte-a폰", "갤럭시s5 광대역lte-a폰", "갤럭시 s5광대역lte-a폰", "갤럭시s5광대역lte-a폰"

)

# 86. 갤럭시 s6
product_name86 = "galaxy s6"
maker_name86 = "samsung"
dic86 = c("g920kw_64g", "sm-g920k", "sm-G920kw", "sm-g920l", "sm-g920l64",
          "갤럭시 6", "갤6", "갤럭시6", "갤 6", "갤s6", "갤럭시s6", "겔럭시6",
          "겔럭시 s6", "겔6", "겔s6", "겔 s6", "갤 s6", "삼성 s6",
          "삼성 겔6", "삼성갤6", "삼성 갤6", "삼성갤 6", "삼성겔6", "삼성겔 6",
          "갤럭시 s6", "s6", "s 6"
          )

# 87 갤럭시 s6 엣지
product_name87 = "galaxy s6 edge"
maker_name87 = "samsung"
dic87 = c("sm-g925l", "sm-g925k", "sm-g925kw", "sm-g925l128", "sm-g925l64",
          "갤럭시 6 엣지", "갤럭시 6엣지", "갤럭시6 엣지", "갤럭시6엣지",
          "갤럭시6edge", "갤럭시 6edge", "갤럭시6 edge", "갤럭시 6 edge",
          "갤6엣지", "갤 6엣지", "갤6 엣지", "갤 6 엣지",
          "갤6edge", "갤 6edge", "갤6 edge", "갤 6 edge",
          "갤s6엣지","갤 s6엣지", "갤 s6 엣지", "갤 s 6 엣지",
          "갤s6edge","갤 s6edge", "갤 s6 edge", "갤 s 6 edge",
          "겔럭시6엣지", "겔럭시6 엣지", "겔럭시 6엣지", "겔럭시 6 엣지",
          "겔럭시6edge", "겔럭시6 edge", "겔럭시 6edge", "겔럭시 6 edge",
          "겔6엣지", "겔 6엣지", "겔6 엣지", "겔 6 엣지",
          "겔6edge", "겔 6edge", "겔6 edge", "겔 6 edge",
          "겔s6엣지", "겔 s6엣지", "겔s6 엣지", "겔 s6 엣지", "겔 s 6 엣지",
          "겔s6edge", "겔 s6edge", "겔s6 edge", "겔 s6 edge", "겔 s 6 edge",
          "갤s6엣지", "갤 s6엣지", "갤s6 엣지", "갤 s6 엣지", "갤 s 6 엣지",
          "갤s6edge", "갤 s6edge", "갤s6 edge", "갤 s6 edge", "갤 s 6 edge",
          "삼성갤럭시 6 엣지", "삼성갤럭시 6엣지", "삼성갤럭시6 엣지", "삼성갤럭시6엣지",
          "삼성 갤럭시 6 엣지", "삼성 갤럭시 6엣지", "삼성 갤럭시6 엣지", "삼성 갤럭시6엣지",
          "삼성갤럭시6edge", "삼성갤럭시 6edge", "삼성갤럭시6 edge", "삼성갤럭시 6 edge",
          "삼성 갤럭시6edge", "삼성 갤럭시 6edge", "삼성 갤럭시6 edge", "삼성 갤럭시 6 edge",
          "삼성갤6엣지", "삼성갤 6엣지", "삼성갤6 엣지", "삼성갤 6 엣지",
          "삼성 갤6엣지", "삼성 갤 6엣지", "삼성 갤6 엣지", "삼성 갤 6 엣지",
          "갤럭시 6 앳지", "갤럭시 6앳지", "갤럭시6 앳지", "갤럭시6앳지",
          "갤6앳지", "갤 6앳지", "갤6 앳지", "갤 6 앳지",
          "갤s6앳지","갤 s6앳지", "갤 s6 앳지", "갤 s 6 앳지",
          "겔럭시6앳지", "겔럭시6 앳지", "겔럭시 6앳지", "겔럭시 6 앳지",
          "겔6앳지", "겔 6앳지", "겔6 앳지", "겔 6 앳지",
          "겔s6앳지", "겔 s6앳지", "겔s6 앳지", "겔 s6 앳지", "겔 s 6 앳지",
          "갤s6앳지", "갤 s6앳지", "갤s6 앳지", "갤 s6 앳지", "갤 s 6 앳지",
          "갤럭시s6 엣지", "갤럭시 s6엣지", "갤럭시s6엣지", "갤럭시 s6 엣지",
          "겔럭시s6 엣지", "겔럭시 s6엣지", "겔럭시s6엣지", "겔럭시 s6 엣지",
          "갤럭시s6 앳지", "갤럭시 s6앳지", "갤럭시s6앳지", "갤럭시 s6 앳지",
          "겔럭시s6 앳지", "겔럭시 s6앳지", "겔럭시s6앳지", "겔럭시 s6 앳지",
          "갤럭시 엣지s6", "갤럭시 엣지 s6", "갤럭시엣지s6", "갤럭시엣지 s6",
          "s6 엣지", "s6 앳지", "s6엣지", "s6앳지"
          )

# 88. 갤럭시s7
# 갤럭시s7 (5정도 부터는 엣지/노트/+ 버전이 추가됨.. 1차 필터링 후 엣지/노트/+ 라는 단어 들어가면 제거해야 할듯.)
product_name88 = "galaxy s7"
maker_name88 = "samsung"
dic88 = c("갤럭시 7", "갤7", "갤럭시7", "갤 7", "갤s7", "갤럭시s7", "겔럭시7", "겔럭시 7", "겔7", "겔s7", "겔 s7", "갤 s7",
           "삼성 s7", "삼성 겔7", "삼성갤7", "삼성 갤7", "삼성갤 7", "삼성겔7", "삼성겔 7", "갤럭시 s7", "겔럭시 s7",
           "galaxys7", "galaxy s7")

# 89. 갤럭시 S7 Edge
product_name89 = "galaxy s7 edge"
maker_name89 = "samsung"
dic89 = c("sm-g935kpb_128g", "sm-g935kpk", "sm-g935ksr", "sm-g935kw", "g935kbe_64g", "g935kgd_64g",
           "갤럭시 7 엣지", "갤럭시 7엣지", "갤럭시7 엣지", "갤럭시7엣지",
           "갤럭시7edge", "갤럭시 7edge", "갤럭시7 edge", "갤럭시 7 edge",
           "갤7엣지", "갤 7엣지", "갤7 엣지", "갤 7 엣지",
           "갤7edge", "갤 7edge", "갤7 edge", "갤 7 edge",
           "갤s7엣지","갤 s7엣지", "갤 s7 엣지", "갤 s 7 엣지",
           "갤s7edge","갤 s7edge", "갤 s7 edge", "갤 s 7 edge",
           "겔럭시7엣지", "겔럭시7 엣지", "겔럭시 7엣지", "겔럭시 7 엣지",
           "겔럭시7edge", "겔럭시7 edge", "겔럭시 7edge", "겔럭시 7 edge",
           "겔7엣지", "겔 7엣지", "겔7 엣지", "겔 7 엣지",
           "겔7edge", "겔 7edge", "겔7 edge", "겔 7 edge",
           "겔s7엣지", "겔 s7엣지", "겔s7 엣지", "겔 s7 엣지", "겔 s 7 엣지",
           "겔s7edge", "겔 s7edge", "겔s7 edge", "겔 s7 edge", "겔 s 7 edge",
           "갤s7엣지", "갤 s7엣지", "갤s7 엣지", "갤 s7 엣지", "갤 s 7 엣지",
           "갤s7edge", "갤 s7edge", "갤s7 edge", "갤 s7 edge", "갤 s 7 edge",
           "삼성갤럭시 7 엣지", "삼성갤럭시 7엣지", "삼성갤럭시7 엣지", "삼성갤럭시7엣지",
           "삼성 갤럭시 7 엣지", "삼성 갤럭시 7엣지", "삼성 갤럭시7 엣지", "삼성 갤럭시7엣지",
           "삼성갤럭시7edge", "삼성갤럭시 7edge", "삼성갤럭시7 edge", "삼성갤럭시 7 edge",
           "삼성 갤럭시7edge", "삼성 갤럭시 7edge", "삼성 갤럭시7 edge", "삼성 갤럭시 7 edge",
           "삼성갤7엣지", "삼성갤 7엣지", "삼성갤7 엣지", "삼성갤 7 엣지",
           "삼성 갤7엣지", "삼성 갤 7엣지", "삼성 갤7 엣지", "삼성 갤 7 엣지",
           "갤럭시 7 앳지", "갤럭시 7앳지", "갤럭시7 앳지", "갤럭시7앳지",
           "갤7앳지", "갤 7앳지", "갤7 앳지", "갤 7 앳지",
           "갤s7앳지","갤 s7앳지", "갤 s7 앳지", "갤 s 7 앳지",
           "겔럭시7앳지", "겔럭시7 앳지", "겔럭시 7앳지", "겔럭시 7 앳지",
           "겔7앳지", "겔 7앳지", "겔 7앳지", "겔 7 앳지",
           "겔s7앳지", "겔 s7앳지", "겔s7 앳지", "겔 s7 앳지", "겔 s 7 앳지",
           "갤s7앳지", "갤 s7앳지", "갤s7 앳지", "갤 s7 앳지", "갤 s 7 앳지",
           "갤럭시 엣지s7", "갤럭시 엣지 s7", "갤럭시엣지s7", "갤럭시 엣지 s7", "겔럭시s7 엣지", "겔럭시 s7 엣지", "겔럭시s7엣지",
           "s7 엣지", "s7 앳지", "s7엣지", "s7앳지"
          )

# 90 갤럭시 WIN
product_name90 = "galaxy win"
maker_name90 = "samsung"
dic90 = c("shv-e500s", "shv-e500l", "갤윈", "갤win", "겔win","갤럭시윈", "갤럭시 윈", "겔윈", "겔럭시윈", "겔럭시 윈",
           "galaxywin", "galaxy win", "갤럭시win", "갤럭시 win")

# 91. 갤럭시 그랜드2
product_name91 = "galaxy grand2"
maker_name91 = "samsung"
dic91 = c("sm-g710l", "갤그2", "갤그 2", "갤럭시그랜드2", "갤럭시 그랜드2", "갤럭시 그랜드 2",
           "겔그2", "겔그 2", "겔럭시그랜드2", "겔럭시 그랜드2", "겔럭시 그랜드 2",
           "galaxygrand2","galaxy grand2", "galaxy grand 2")

# 92. 갤럭시 노트3
product_name92 = "galaxy note3"
maker_name92 = "samsung"
dic92 = c("sm-n900l", "갤놋3", "겔놋3", "갤 놋3", "겔 놋3", "갤 노트3", "겔 노트3", "갤놋삼", "겔놋삼",
           "갤럭시노트3", "갤럭시 노트3", "갤럭시 노트 3", "갤럭시놋3", "갤럭시 놋3",
           "겔럭시노트3", "겔럭시 노트3", "겔럭시 노트 3", "겔럭시놋3", "겔럭시 놋3",
           "갤럭시note3", "갤럭시 note3", "갤럭시 note 3",
           "겔럭시note3", "겔럭시 note3", "겔럭시 note 3",
           "galaxynote3","galaxy note3","galaxy note 3", "노트3", "노트 3")

# 93. 갤럭시 노트 3 네오
product_name93 = "galaxy note3 neo"
maker_name93 = "samsung"
dic93 = c("갤럭시노트3 네오", "갤럭시노트3네오", "갤럭시 노트3네오", "갤럭시 노트3네오", "노트3 네오", "노트3네오", "노트 3 네오",
          "노트3 neo", "노트 3neo", "노트3neo", "노트 3 neo"
          )

# 94. 갤럭시 노트4 S-LTE
product_name94 = "galaxy note4 s-lte"
maker_name94 = "samsung"
dic94 = c("galaxy note4 s-lte", "galaxynote4 s-lte", "galaxy note4s-lte", "galaxynote4s-lte",
           "갤럭시 note4 s-lte", "갤럭시note4 s-lte", "갤럭시 note4s-lte", "갤럭시note4s-lte",
           "겔럭시 note4 s-lte", "겔럭시note4 s-lte", "겔럭시 note4s-lte", "겔럭시note4s-lte",
           "겔럭시 노트4 s-lte", "겔럭시노트4 s-lte", "겔럭시 노트4s-lte", "겔럭시노트4s-lte",
           "겔럭시 노트4 에스-lte", "겔럭시노트4 에스-lte", "겔럭시 노트4에스-lte", "겔럭시노트4에스-lte",
           "galaxy note4 s-lte폰", "galaxynote4 s-lte폰", "galaxy note4s-lte폰", "galaxynote4s-lte폰",
           "갤럭시 note4 s-lte폰", "갤럭시note4 s-lte폰", "갤럭시 note4s-lte폰", "갤럭시note4s-lte폰",
           "겔럭시 note4 s-lte폰", "겔럭시note4 s-lte폰", "겔럭시 note4s-lte폰", "겔럭시note4s-lte폰",
           "겔럭시 노트4 s-lte폰", "겔럭시노트4 s-lte폰", "겔럭시 노트4s-lte폰", "겔럭시노트4s-lte폰",
           "겔럭시 노트4 에스-lte폰", "겔럭시노트4 에스-lte폰", "겔럭시 노트4에스-lte폰", "겔럭시노트4에스-lte폰",
           "노트4 s-lte", "노트4s-lte", "노트 4 에스-lte", "노트 4에스-lte",
          "노트4 s-lte폰", "노트4s-lte폰", "노트 4 에스-lte폰", "노트 4에스-lte폰"
          )

# 95 갤럭시 노트 5
product_name95 = "galaxy note5"
maker_name95 = "samsung"
dic95 = c("갤럭시노트5", "갤럭시 노트5","갤럭시노트 5", "갤럭시 노트 5", "겔럭시 노트5", "겔럭시 노트 5",
           "겔럭시노트5", "겔럭시 노트5","겔럭시노트 5", "겔럭시 노트 5", "겔럭시 노트5", "겔럭시 노트 5",
           "galaxy note5", "galaxynote5","galaxynote 5", "galaxy note5", "galaxy 노트5", "galaxy 노트5폰",
           "갤럭시노트5폰", "갤럭시 노트5폰","갤럭시노트 5폰", "갤럭시 노트 5폰", "겔럭시 노트5폰", "겔럭시 노트 5폰",
           "겔럭시노트5폰", "겔럭시 노트5폰","겔럭시노트 5폰", "겔럭시 노트 5폰", "겔럭시 노트5폰", "겔럭시 노트 5폰",
           "galaxy note5폰", "galaxynote5폰","galaxynote 5폰", "galaxy note5폰", "galaxy 노트5폰", "galaxy 노트5폰",
           "노트 5", "노트5", "노트 5폰", "노트5폰"
          )

# 96. 갤럭시 노트7
product_name96 = "galaxy note7"
maker_name96 = "samsung"
dic96 = c("갤럭시노트7", "갤럭시 노트7","갤럭시노트 7", "갤럭시 노트 7", "겔럭시 노트7", "겔럭시 노트 7",
           "겔럭시노트7", "겔럭시 노트7","겔럭시노트 7", "겔럭시 노트 7", "겔럭시 노트7", "겔럭시 노트 7",
           "galaxy note7", "galaxynote7","galaxynote 7", "galaxy note7", "galaxy 노트7", "galaxy 노트7폰",
           "갤럭시노트7폰", "갤럭시 노트7폰","갤럭시노트 7폰", "갤럭시 노트 7폰", "겔럭시 노트7폰", "겔럭시 노트 7폰",
           "겔럭시노트7폰", "겔럭시 노트7폰","겔럭시노트 7폰", "겔럭시 노트 7폰", "겔럭시 노트7폰", "겔럭시 노트 7폰",
           "galaxy note7폰", "galaxynote7폰","galaxynote 7폰", "galaxy note7폰", "galaxy 노트7폰", "galaxy 노트7폰",
           "갤 노트7", "노트7", "갤노트7", "노트 7", "노트7", "노트 7폰", "노트 7"
)

# 97. 갤럭시 메가
product_name97 = "galaxy mega"
maker_name97 = "samsung"
dic97 = c("shv-e310l", "갤메가", "갤mega", "겔 mega", "겔메가", "갤매가", "겔매가", "갤럭시메가", "갤럭시 메가", "겔럭시메가", "겔럭시 메가",
           "갤럭시mega", "갤럭시 mega", "겔럭시mega", "겔럭시 mega", "galaxymega", "galaxy mega")

# 98 갤럭시 wide
product_name98 = "galaxy wide"
maker_name98 = "samsung"
dic98 = c("갤wide", "겔 wide", "갤와이드", "겔와이드", "갤럭시와이드", "갤럭시 와이드", "겔럭시와이드", "겔럭시 와이드",
           "갤럭시wide", "갤럭시 wide", "겔럭시wide", "겔럭시 wide", "galaxywide", "galaxy wide")

# 99. 갤럭시 줌2
product_name99 = "galaxy joom2"
maker_name99 = "samsung"
dic99 = c("sm-c115l", "갤줌2", "갤 줌2", "겔줌2", "겔 줌2", "갤럭시 줌2", "겔럭시 줌2", "갤럭시줌2", "겔럭시줌2",
           "갤줌투", "갤럭시줌투", "갤럭시 줌투", "겔럭시줌투", "겔럭시 줌투",
           "갤럭시joom2", "갤럭시 joom2", "겔럭시joom2", "겔럭시 joom2")

# 100. 갤럭시 코어 어드밴스
product_name100 = "galaxy core advance"
maker_name100 = "samsung"
dic100 = c("shw-m570s", "갤럭시코어어드밴스", "갤럭시 코어어드밴스", "갤럭시 코어 어드밴스",
           "갤럭시코어어드벤스", "갤럭시 코어어드벤스", "갤럭시 코어 어드벤스",
           "galaxy core advance", "galaxy coreadvance", "galaxycoreadvance")

# 101. 갤럭시 폴더
product_name101 = "galaxy folder"
maker_name101 = "samsung"
dic101 = c("sm-g150nk", "sm-g150ns", "갤럭시폴더", "갤럭시 폴더", "갤폴더", "겔럭시폴더", "겔럭시 폴더", "겔폴더",
           "galaxyfolder", "galaxy folder")

# 102. 갤럭시 폴더2 (LTE)
product_name102 = "galaxy folder2"
maker_name102 = "samsung"
dic102 = c("sm-g160n", "갤럭시폴더2", "갤럭시 폴더2", "갤폴더2", "겔럭시폴더2", "겔럭시 폴더2", "겔폴더2",
           "galaxyfolder2", "galaxy folder2")

# 103. 갤럭시 a5 (2016)
product_name103 = "galaxy a5 2016"
maker_name103 = "samsung"
dic103 =  c("a5 2016", "a5(2016)", "a5 (2016)", "2016 a5", "2016년 a5", "a5 2016년")

# 104. 갤럭시 a7 (2016)
product_name104 = "galaxy a7 2016"
maker_name104 = "samsung"
dic104 = c("a7 2016", "a7(2016)", "a7 (2016)", "2016 a7", "2016년 a7", "a7 2016년")

# 105. 갤럭시 a7 (2017)
product_name105 = "galaxy a7 2017"
maker_name105 = "samsung"
dic105 = c("a7 2017", "a7(2017)", "a7 (2017)", "2017 a7", "2017년 a7", "a7 2017년")

# 106. 갤럭시A8 2015
product_name106 = "galaxy a8 2015"
maker_name106 = "samsung"
dic106 = c("sm-a800s", "갤a8", "갤 a8", "겔a8", "겔 a8", "갤a82015", "갤a8 2015", "갤 a8 2015", "겔a82015", "겔a8 2015",
           "a8 2015", "a8(2015)", "2015 a8", "갤럭시a8", "갤럭시 a8", "겔럭시a8", "겔럭시 a8",
           "갤럭시a82015", "갤럭시 a8 2015", "겔럭시a82015", "겔럭시 a8 2015",
           "galaxy a8", "galaxy a8 2015", "galaxya82015")

# 107.갤럭시A8 2016
product_name107 = "galaxy a8 2016"
maker_name107 = "samsung"
dic107 = c("sm-a810ss", "갤a8", "갤 a8", "겔a8", "겔 a8", "갤a82016", "갤a8 2016", "갤 a8 2016", "겔a82016", "겔a8 2016",
           "a8 2016", "a8(2016)", "2016 a8", "갤럭시a8", "갤럭시 a8", "겔럭시a8", "겔럭시 a8",
           "갤럭시a82016", "갤럭시 a8 2016", "겔럭시a82016", "겔럭시 a8 2016",
           "galaxy a8", "galaxy a8 2016", "galaxya82016")

# 108. 갤럭시J7(센스 플러스)
product_name108 = "galaxy j7 sense plus"
maker_name108 = "samsung"
dic108 = c("galaxy j7 sense plus", "galaxyj7 sense plus", "galaxy j7sense plus", "galaxy j7 senseplus",
           "galaxyj7 senseplus", "galaxyj7sense plus", "galaxy j7senseplus", "galaxyj7senseplus",
           "갤럭시 j7 sense plus", "갤럭시j7 sense plus", "갤럭시 j7sense plus", "갤럭시 j7 senseplus",
           "갤럭시j7 senseplus", "갤럭시j7sense plus", "갤럭시 j7senseplus", "갤럭시j7senseplus",
           "겔럭시 j7 sense plus", "겔럭시j7 sense plus", "겔럭시 j7sense plus", "겔럭시 j7 senseplus",
           "겔럭시j7 senseplus", "겔럭시j7sense plus", "겔럭시 j7senseplus", "겔럭시j7senseplus",
           "galaxy j7 sense plus폰", "galaxyj7 sense plus폰", "galaxy j7sense plus폰", "galaxy j7 senseplus폰",
           "galaxyj7 senseplus폰", "galaxyj7sense plus폰", "galaxy j7senseplus폰", "galaxyj7senseplus",
           "갤럭시 j7 sense plus폰", "갤럭시j7 sense plus폰", "갤럭시 j7sense plus폰", "갤럭시 j7 senseplus폰",
           "갤럭시j7 senseplus폰", "갤럭시j7sense plus폰", "갤럭시 j7senseplus폰", "갤럭시j7senseplus",
           "겔럭시 j7 sense plus폰", "겔럭시j7 sense plus폰", "겔럭시 j7sense plus폰", "겔럭시 j7 senseplus폰",
           "겔럭시j7 senseplus폰", "겔럭시j7sense plus폰", "겔럭시 j7senseplus폰", "겔럭시j7senseplus폰",
           "sm-j700k"
           )

# 109. 갤럭시S3
product_name109 = "galaxy s3 3g"
maker_name109 = "samsung"
dic109 = c("galaxy s3", "galaxys3", "갤럭시 s3", "겔럭시 s3", "갤럭시s3", "겔럭시s3",
           "galaxy s3폰", "galaxys3폰", "갤럭시 s3폰", "겔럭시 s3폰", "갤럭시s3폰", "겔럭시s3폰"
           )


# 110. 갤럭시S4 액티브
product_name110 = "galaxy s4 active"
maker_name110 = "samsung"
dic110 = c("galaxy s4 active", "galaxys4 active", "galaxy s4active", "galaxys4active",
           "갤럭시 s4 active", "갤럭시s4 active", "갤럭시 s4active", "갤럭시s4active",
           "겔럭시 s4 active", "겔럭시s4 active", "겔럭시 s4active", "겔럭시s4active",
           "galaxy s4 엑티브", "galaxys4 엑티브", "galaxy s4엑티브", "galaxys4엑티브",
           "갤럭시 s4 엑티브", "갤럭시s4 엑티브", "갤럭시 s4엑티브", "갤럭시s4엑티브",
           "겔럭시 s4 엑티브", "겔럭시s4 엑티브", "겔럭시 s4엑티브", "겔럭시s4엑티브",
           "galaxy s4 active폰", "galaxys4 active폰", "galaxy s4active폰", "galaxys4active폰",
           "갤럭시 s4 active폰", "갤럭시s4 active폰", "갤럭시 s4active폰", "갤럭시s4active폰",
           "겔럭시 s4 active폰", "겔럭시s4 active폰", "겔럭시 s4active폰", "겔럭시s4active폰",
           "galaxy s4 엑티브폰", "galaxys4 엑티브폰", "galaxy s4엑티브폰", "galaxys4엑티브폰",
           "갤럭시 s4 엑티브폰", "갤럭시s4 엑티브폰", "갤럭시 s4엑티브폰", "갤럭시s4엑티브폰",
           "겔럭시 s4 엑티브폰", "겔럭시s4 엑티브폰", "겔럭시 s4엑티브폰", "겔럭시s4엑티브폰"

)

# 111. 갤럭시S5
product_name111 = "galaxy s5"
maker_name111 = "samsung"
dic111 = c("sm-g900s", "sm-g900kw", "sm-g900k",
           "갤럭시 5", "갤5", "갤럭시5", "갤 5", "갤s5", "갤럭시s5", "겔럭시5",
           "겔럭시 s5", "겔5", "겔s5", "겔 s5", "갤 s5", "삼성 s5", "갤럭시 s5",
           "삼성 겔5", "삼성갤5", "삼성 갤5", "삼성갤 5", "삼성겔5", "삼성겔 5", "s5", "s5폰")


# 112. 갤럭시S6 엣지플러스
product_name112 = "galaxy s6 edge plus"
maker_name112 = "samsung"
dic112 = c("sm-g928l", "sm-g928k", "sm-g928s_32g", "갤럭시 S6 엣지 플러스",
           "갤럭시 s6 엣지 \\+", "갤럭시s6엣지\\+", "갤럭시 s6 엣지\\+", "갤럭시 s6 edge\\+", "갤럭시 s6edge\\+", "갤럭시s6edge\\+",
           "갤럭시 6 엣지 플러스", "갤럭시 6엣지플러스", "갤럭시6 엣지플러스", "갤럭시6엣지플러스",
           "갤럭시6edgeplus", "갤럭시 6edge plus", "갤럭시6 edgeplus", "갤럭시 6 edge plus",
           "갤6엣지플러스", "갤 6엣지플러스", "갤6 엣지플러스", "갤6 엣지 플러스", "갤 6 엣지 플러스",
           "갤6edgeplus", "갤 6edgeplus", "갤6 edgeplus", "갤 6 edge plus",
           "갤s6엣지플러스","갤 s6엣지플러스", "갤 s6 엣지플러스", "갤 s6 엣지 플러스", "갤 s 6 엣지 플러스",
           "갤s6edgeplus","갤 s6edgeplus", "갤 s6 edgeplus", "갤 s6 edge plus", "갤 s 6 edge plus",
           "겔럭시6엣지플러스", "겔럭시6 엣지플러스", "겔럭시 6엣지플러스", "겔럭시 6 엣지 플러스",
           "겔럭시6edgeplus", "겔럭시6 edgeplus", "겔럭시 6edgeplus", "겔럭시 6 edgeplus", "겔럭시 6edge plus", "겔럭시 6 edge plus",
           "겔6엣지플러스", "겔 6엣지플러스", "겔6 엣지 플러스", "겔 6 엣지 플러스",
           "겔6edgeplus", "겔 6edgeplus", "겔6 edgeplus", "겔 6 edgeplus", "겔 6 edge plus", "겔6 edge plus",
           "겔s6엣지플러스", "겔 s6엣지플러스", "겔s6 엣지플러스", "겔 s6 엣지 플러스", "겔 s 6 엣지 플러스",
           "겔s6edgeplus", "겔 s6edgeplus", "겔s6 edge plus", "겔 s6 edgeplus", "겔 s 6 edgeplus",
           "갤s6엣지플러스", "갤 s6엣지플러스", "갤s6 엣지플러스", "갤 s6 엣지 플러스", "갤 s 6 엣지 플러스",
           "갤s6edgeplus", "갤 s6edgeplus", "갤s6 edgeplus", "갤 s6 edge plus", "갤 s 6 edge plus",
           "삼성갤럭시s6edge\\+","삼성 갤럭시s6edge\\+", "삼성 갤럭시 s6edge\\+", "삼성 갤럭시 s6 edge\\+", "삼성 갤럭시s6 edge\\+",
           "삼성갤s6edge\\+","삼성 갤s6edge\\+", "삼성 갤s6 edge\\+", "삼성 갤s6 edge \\+",
           "삼성갤럭시s6엣지\\+","삼성 갤럭시s6엣지\\+", "삼성 갤럭시 s6엣지\\+", "삼성 갤럭시s6 엣지\\+", "삼성s6엣지\\+", "삼성 s6엣지\\+",
           "s6 엣지\\+", "s6엣지\\+", "s6 엣지플러스", "s6 엣지 플러스", "s6엣지 플러스", "s6엣지플러스" 
           )


# 113. 갤럭시S8+
product_name113 = "galaxy s8 plus"
maker_name113 = "samsung"
dic113 = c("sm-g955nbl", "sm-g955npk", "sm-g955ngr", "sm-g955n128", "갤럭시 S8 플러스",
           "갤럭시 s8 \\+", "갤럭시s8\\+", "갤럭시 s8 \\+", "갤럭시 s8 \\+", "갤럭시 s8\\+", "갤럭시s8\\+",
           "갤럭시 8 플러스", "갤럭시 8플러스", "갤럭시8 플러스", "갤럭시8플러스",
           "갤럭시8plus", "갤럭시 8 plus", "갤럭시8 plus", "갤럭시 8 plus",
           "갤8플러스", "갤 8플러스", "갤8 플러스", "갤8 플러스", "갤 8 플러스",
           "갤8plus", "갤 8plus", "갤8 plus", "갤 8 plus",
           "갤s8플러스","갤 s8플러스", "갤 s8 플러스", "갤 s8플러스", "갤 s 8 플러스",
           "갤s8plus","갤 s8plus", "갤 s8 plus", "갤 s8 plus", "갤 s 8 plus",
           "겔럭시8플러스", "겔럭시8 플러스", "겔럭시 8플러스", "겔럭시 8 플러스",
           "겔럭시8plus", "겔럭시8 plus", "겔럭시 8plus", "겔럭시 8 plus", "겔럭시 8 plus", "겔럭시 8 plus",
           "겔8플러스", "겔 8플러스", "겔8 플러스", "겔 8 플러스",
           "겔8plus", "겔 8plus", "겔8 plus", "겔 8 plus", "겔 8 plus", "겔8 plus",
           "겔8플러스", "겔 s8플러스", "겔s8 플러스", "겔 s8 플러스", "겔 s 8 플러스",
           "겔s8plus", "겔 s8plus", "겔s8 plus", "겔 s8 plus", "겔 s 8 plus",
           "갤s8플러스", "갤 s8플러스", "갤s8 플러스", "갤 s8 플러스", "갤 s 8 플러스",
           "갤s8plus", "갤 s8plus", "갤s8 plus", "갤 s8 plus", "갤 s 8 plus",
           "삼성갤럭시s8\\+","삼성 갤럭시s8\\+", "삼성 갤럭시 s8\\+", "삼성 갤럭시 s8 \\+",
           "삼성갤s8\\+","삼성 갤8\\+", "삼성 갤s8\\+", "삼성 갤 s8 \\+",
           "삼성갤럭시s8\\+","삼성 갤럭시s8\\+", "삼성 갤럭시 s8\\+", "삼성 갤럭시8 \\+", "삼성s8\\+", "삼성 8\\+")

# 114. 갤럭시 노트 엣지
product_name114 = "galaxy note edge"
maker_name114 = "samsung"
dic114 = c("갤럭시 노트 엣지", "갤럭시노트 엣지",  "갤럭시 노트엣지", "갤럭시노트엣지",
           "galaxy 노트 엣지", "galaxy노트 엣지",  "galaxy 노트엣지", "galaxy노트엣지",
           "galaxy note 엣지", "galaxynote 엣지",  "galaxy note엣지", "galaxynote엣지",
           "galaxy note edge", "galaxynote edge", "galaxy noteedge", "galaxynoteedge",
           "galaxy 노트 edge", "galaxy노트 edge",  "galaxy 노트edge", "galaxy노트edge",
           "갤럭시 노트 엣지폰", "갤럭시노트 엣지폰",  "갤럭시 노트엣지폰", "갤럭시노트엣지폰",
           "galaxy 노트 엣지폰", "galaxy노트 엣지폰",  "galaxy 노트엣지폰", "galaxy노트엣지폰",
           "galaxy note 엣지폰", "galaxynote 엣지폰",  "galaxy note엣지폰", "galaxynote엣지폰",
           "galaxy note edge폰", "galaxynote edge폰", "galaxy noteedge폰", "galaxynoteedge폰",
           "galaxy 노트 edge폰", "galaxy노트 edge폰",  "galaxy 노트edge폰", "galaxy노트edge폰",
           "노트 엣지", "노트엣지", "노트 edge", "노트edge", "note edge"
           )


# 115. 갤럭시 노트 4
product_name115 = "galaxy note4"
maker_name115 = "samsung"
dic115 = c("sm-n900l", "갤놋4", "겔놋4", "갤 놋4", "겔 놋4", "갤 노트4", "겔 노트4", "갤놋사", "겔놋사",
           "갤럭시노트4", "갤럭시 노트4", "갤럭시 노트 4", "갤럭시놋4", "갤럭시 놋4",
           "겔럭시노트4", "겔럭시 노트4", "겔럭시 노트 4", "겔럭시놋4", "겔럭시 놋4",
           "갤럭시note4", "갤럭시 note4", "갤럭시 note 4",
           "겔럭시note4", "겔럭시 note4", "겔럭시 note 4",
           "galaxynote4","galaxy note4","galaxy note 4", "노트4", "노트 4", "노트4폰", "노트 4폰")

# 116. 라인프렌즈 스마트폰
product_name116 = "linefriends smartphone"
maker_name116 = " zte"
dic116 = c("linefriends smartphone", "라인프렌즈 smartphone", "linefriends 스마트폰", "라인프렌즈 스마트폰",
           "zte-k813"
           )

# 117. 루나s
product_name117 = "luna s"
maker_name117 = "tg&co"
dic117 = c("루나s", "lunas", "luna s", "루나 s",
           "루나s폰", "lunas폰", "luna s폰", "루나 s폰"
           )

# 118. 베가 LTE-A
product_name118 = "vega lte-a"
maker_name118 = "pantech"
dic118 = c("vega lte-a", "vega lte a", "vega lte", "vegalte-a",
           "베가 lte-a", "베가 lte a", "베가 lte", "베가lte-a",
           "배가 lte-a", "배가 lte a", "배가 lte", "배가lte-a",
           "vega lte-a폰", "vega lte a폰", "vega lte폰", "vegalte-a폰",
           "베가 lte-a폰", "베가 lte a폰", "베가 lte폰", "베가lte-a폰",
           "배가 lte-a폰", "배가 lte a폰", "배가 lte폰", "배가lte-a폰"
           )

# 119. 베가 넘버 6
product_name119 = "vega number6"
maker_name119 = "pantech"
dic119 = c("vega number6", "veganumber6", "vega number 6", "veganumber 6",
           "베가 number6", "베가number6", "베가 number 6", "베가number 6",
           "배가 number6", "배가number6", "배가 number 6", "배가number 6",
           "vega number6폰", "veganumber6폰", "vega number 6폰", "veganumber 6폰",
           "베가 number6폰", "베가number6폰", "베가 number 6폰", "베가number 6폰",
           "배가 number6폰", "배가number6폰", "배가 number 6폰", "배가number 6폰",
           "배가 넘버6", "배가넘버6", "배가 넘버 6", "배가넘버 6",
           "베가 넘버6", "베가넘버6", "베가 넘버 6", "베가넘버 6",
           "베가 no6", "vega no6", "vega no 6"
           )

# 120. 베가 시크릿 업
product_name120 = "vega secret up"
maker_name120 = "pantech"
dic120 = c("vega secretup", "vegasecretup", "vega secret up", "vegasecret up",
           "베가 secretup", "베가secretup", "베가 secret up", "베가secret up",
           "배가 secretup", "배가secretup", "배가 secret up", "배가secret up",
           "베가 시크릿업", "베가 시크릿 업", "베가시크릿업", "베가시크릿업",
           "배가 시크릿업", "배가 시크릿 업", "배가시크릿업", "배가시크릿업",
           "vega secretup폰", "vegasecretup폰", "vega secret up폰", "vegasecret up폰",
           "베가 secretup폰", "베가secretup폰", "베가 secret up폰", "베가secret up폰",
           "배가 secretup폰", "배가secretup폰", "배가 secret up폰", "배가secret up폰",
           "시크릿업", "시크릿 업"
           )

# 121. 베가 시크릿 노트
product_name121 = "vega secret note"
maker_name121 = "pantech"
dic121 = c("vega secret note", "vegasecret note", "vega secretnote", "vegasecretnote",
           "베가 secret note", "베가secret note", "베가 secretnote", "베가secretnote",
           "배가 secret note", "배가secret note", "배가 secretnote", "배가secretnote",
           "vega secret note폰", "vegasecret note폰", "vega secretnote폰", "vegasecretnote폰",
           "베가 secret note폰", "베가secret note폰", "베가 secretnote폰", "베가secretnote폰",
           "배가 secret note폰", "배가secret note폰", "배가 secretnote폰", "배가secretnote폰",
           "배가 시크릿 note", "배가시크릿 note", "배가 시크릿note", "배가시크릿note",
           "배가 시크릿 노트", "배가시크릿 노트", "배가 시크릿노트", "배가시크릿노트"
            )

# 122. 베가 아이언 2
product_name122 = "vega iron2"
maker_name122 = "pantech"
dic122 = c("vega iron2", "vegairon2", "vega iron 2", "vegairon 2",
           "베가 iron2", "베가iron2", "베가 iron 2", "베가iron 2",
           "배가 iron2", "배가iron2", "배가 iron 2", "배가iron 2",
           "베가 아이언2", "베가아이언2", "베가 아이언 2", "베가아이언 2",
           "배가 아이언2", "배가아이언2", "배가 아이언 2", "배가아이언 2",
           "vega iron2폰", "vegairon2폰", "vega iron 2폰", "vegairon 2폰",
           "베가 iron2폰", "베가iron2폰", "베가 iron 2폰", "베가iron 2폰",
           "배가 iron2폰", "배가iron2폰", "배가 iron 2폰", "배가iron 2폰",
           "베가 아이언2폰", "베가아이언2폰", "베가 아이언 2폰", "베가아이언 2폰",
           "배가 아이언2폰", "배가아이언2폰", "배가 아이언 2폰", "배가아이언 2폰"
           )

# 123. 볼트
product_name123 = "volt"
maker_name123 = "lg"
dic123 = c("volt", "lg볼트", "볼트폰", "volt폰")
           

# 124. 뷰3
product_name124 = "view3"
maker_name124 = "lg"
dic124 = c("뷰3", "뷰 3","view 3", "view3", 
           "뷰3폰", "뷰 3폰","view 3폰", "view3폰" 
           )

# 125. 아이폰4
product_name125 = "iphone 4"
maker_name125 = "apple"
dic125 = c("iphone 4", "iphone4", "i phone4", "i phone 4", "아이phone 4", "아이phone4", "아이 phone4", "아이 phone 4",
          "i폰 4", "i폰4", "i 폰4", "i 폰 4", "아이폰 4", "아이폰4", "아이 폰4", "아이 폰 4",
          "애플iphone 4", "애플iphone4", "애플i phone4", "애플i phone 4", "애플아이phone 4", "애플아이phone4", "애플아이 phone4", "애플아이 phone 4",
          "애플i폰 4", "애플i폰4", "애플i 폰4", "애플i 폰 4", "애플아이폰 4", "애플아이폰4", "애플아이 폰4", "애플아이 폰 4"
)


# 126. 아이폰4S
product_name126 = "iphone 4s"
maker_name126 = "apple"
dic126 = c("iphone 4s", "iphone4s", "i phone4s", "i phone 4s", "아이phone 4s", "아이phone4s", "아이 phone4s", "아이 phone 4s",
          "i폰 4s", "i폰4s", "i 폰4s", "i 폰 4s", "아이폰 4s", "아이폰4s", "아이 폰4s", "아이 폰 4s",
          "애플iphone 4s", "애플iphone4s", "애플i phone4s", "애플i phone 4s", "애플아이phone 4s", "애플아이phone4s", "애플아이 phone4s", "애플아이 phone 4s",
          "애플i폰 4s", "애플i폰4s", "애플i 폰4s", "애플i 폰 4s", "애플아이폰 4s", "애플아이폰4s", "애플아이 폰4s", "애플아이 폰 4s"
)

# 127. 아이폰6
product_name127 = "iphone 6"
maker_name127 = "apple"
dic127 = c("아이폰6", "아이폰 6", "iphone6", "i phone 6", "iphone 6",
          "i폰6", "i 폰6", "i 폰 6", "아이phone6", "아이phone 6", "아이폰식스", "아이폰 식스")

# 128. 아이폰6s 플러스
product_name128 = "iphone 6s Plus"
maker_name128   = "apple"
dic128 = c("iphone 6s\\+", "iphone6s\\+", "i phone6s\\+", "i phone 6s\\+", "아이phone 6s\\+", "아이phone6s\\+", "아이 phone6s\\+", "아이 phone 6s\\+",
          "i폰 6s\\+", "i폰6s\\+", "i 폰6s\\+", "i 폰 6s\\+", "아이폰 6s\\+", "아이폰6s\\+", "아이 폰6s\\+", "아이 폰 6s\\+",
          "애플iphone 6s\\+", "애플iphone6s\\+", "애플i phone6s\\+", "애플i phone 6s\\+", "애플아이phone 6s\\+", "애플아이phone6s\\+", "애플아이 phone6s\\+", "애플아이 phone 6s\\+",
          "애플i폰 6s\\+", "애플i폰6s\\+", "애플i 폰6s\\+", "애플i 폰 6s\\+", "애플아이폰 6s\\+", "애플아이폰6s\\+", "애플아이 폰6s\\+", "애플아이 폰 6s\\+",
          "iphone 6s플러스", "iphone6s플러스", "i phone6s플러스", "i phone 6s플러스", "아이phone 6s플러스", "아이phone6s플러스", "아이 phone6s플러스", "아이 phone 6s플러스",
          "i폰 6s\\+", "i폰6s\\+", "i 폰6s\\+", "i 폰 6s\\+", "아이폰 6s\\+", "아이폰6s\\+", "아이 폰6s\\+", "아이 폰 6s\\+",
          "애플iphone 6s플러스", "애플iphone6s플러스", "애플i phone6s플러스", "애플i phone 6s플러스", "애플아이phone 6s플러스", "애플아이phone6s플러스", "애플아이 phone6s플러스", "애플아이 phone 6s플러스",
          "애플i폰 6s플러스", "애플i폰6s플러스", "애플i 폰6s플러스", "애플i 폰 6s플러스", "애플아이폰 6s플러스", "애플아이폰6s플러스", "애플아이 폰6s플러스", "애플아이 폰 6s플러스"
)


# 129. 알카텔 아이돌 착
product_name129 = "alcatel idol chac"
maker_name129 = "alcatel-lucent"
dic129 = c("알카텔 아이돌 착", "alcatel idol chac", "아카텔폰",
           "알카텔 아이돌 착폰", "alcatel idol chac폰"
)

# 130. 옵티머스 G
product_name130 = "optimus g"
maker_name130 = "lg"
dic130 = c("옵티머스 지", "옵티머스 g", "옵티머스g", "optimus g",
           "lgoptimus")

# 131. 옵티머스 G 프로
product_name131 = "optimus gpro"
maker_name131 = "lg"
dic131 = c("옵티머스 지프로", "옵티머스 g프로", "옵티머스지프로", "optimus g pro",
           "optimusgpro","optimus_g_pro","옵티머스 지pro")

# 132. 옵티머스 뷰2
product_name132 = "optimus view2"
maker_name132 = "lg"
dic132 = c("옵티머스 뷰2", "optimus 뷰2", "optimus view2", "옵티머스뷰2", "옵티머스 view2", "옵티머스view2", "optimus뷰2",
           "옵티머스 뷰2폰", "optimus 뷰2폰", "optimus view2폰", "옵티머스뷰2폰", "옵티머스 view2폰", "옵티머스view2폰", "optimus뷰2폰"
)


# 133. 와이즈II 2G
product_name133 = "wise2 2g"
maker_name133 = "samsung"
dic133 = c("wise2 2g", "wise22g", "와이즈2 2g", "와이즈2 2지", "wise2 2지", "와이즈22g",
           "wise2 2g폰", "wise22g폰", "와이즈2 2g폰", "와이즈2 2지폰", "wise2 2지폰", "와이즈22g폰"
)

# 134. 와인 스마트
product_name134 = "wine smart"
maker_name134 = "lg"
dic134 = c("와인스마트", "와인 스마트", "와인 smart", "wine smart", "LG-F480L")

# 135. 와인스마트 Jazz
product_name135 = "wine smart jazz"
maker_name135 = "lg"
dic135 = c("와인 스마트 재즈", "wine smart jazz", "스마트 재즈폰", "와인 재즈폰", "스마트 와인 재즈", "재즈 스마트",
           "와인 재즈", "스마트 재즈 와인", "재즈", "재즈폰", "와인재즈", "와인스마트", "와인폰", "와인",
           "lg-f610s", "lg f610s", "lgf610s")

# 136. 화웨이 X3
product_name136 = "huawei x3"
maker_name136 = "화웨이"
dic136 = c("화웨이 x3", "화웨이 엑스쓰리")

# 137. galaxy note 2
product_name137 = "galaxy note 2"
maker_name137 = "samsung"
dic137 = c("galaxy note 2", "galaxynote 2", "galaxy note2", "galaxynote2",
           "갤럭시 note 2", "갤럭시note 2", "갤럭시 note2", "갤럭시note2",
           "갤럭시 노트 2", "갤럭시노트 2", "갤럭시 노트2", "갤럭시노트2",
           "노트 2", "노트2", "겔럭시 노트 2", "겔럭시 노트2", "겔럭시노트2", "겔럭시노트 2", "겔노트2", "겔노트 2",
           "겔럭시 note2", "겔럭시note 2", "겔놋2", "겟놋 2", "겔럭시 note 2", "galaxy note 2",
           "galaxy note2", "shv-e250s", "shv-e250k", "shv-e250l"
           )

## step 3. 제품명, 제조사, 저장용량, 출고가 붙이기 ##

# 핸드폰 사전 2부터 137까지의 for문
for(i in 2:137) {
  index_list = list()
  product_name_value <- get(paste('product_name', i, sep=''))
  maker_name_value  <- get(paste('maker_name', i, sep=''))
  
  for (search_p in get(paste('dic', i, sep=''))) { # dic에 있는 값들을 변수 search_p에 하나씩 대입하면서 데이터셋에서 특정 제품명의 index 추출
    index = grep(search_p, tong$contents)
    index_list = append(index_list, index)
  }
  index_list_unique = unique(index_list) # index가 unique한 것만 뽑아내기 (중복제거)
  
  # 데이터셋에서 사전에 있는 단어가 하나라도 있는 경우, if문 실행
  if(length(index_list_unique) != 0) {
    
    tong[unlist(index_list_unique), ]$제품명 <- product_name_value # 제품명 입력
    tong[unlist(index_list_unique), ]$제조사 <- maker_name_value # 제조사 입력
    
    # 용량 사전 1부터 5까지의 for문
    for(count in 1:5) {
      GB_index_list = list()
      GB_name_value <- get(paste('GB_name', count, sep=''))
      
      for (search_k in get(paste('GB', count, sep=''))) {
        GB_index = grep(search_k, tong[unlist(index_list_unique), ]$contents)
        GB_index_list = append(GB_index_list, GB_index) 
      }
      GB_index_list_unique = unique(GB_index_list) # index가 unique한 것만 뽑아내기 (중복제거)
      
      if(length(GB_index_list_unique) != 0) { 
        full_name <- paste(product_name_value,GB_name_value) # full_name 변수 선언 (full_name = 단말기명 + 용량)
        
        # 해당되는 inddex가 가리키는 값들이 다시 index_list_unique로 들어가기 때문에 unlist를 두번 실행
        tong[unlist(index_list_unique[unlist(GB_index_list_unique)]), ]$용량 <- GB_name_value 
        
        # 만약 phone_price의 모델명에 full_name이 있는 경우,
        if((table(phone_price$단말기명 == full_name)["FALSE"]) != 220){
          time_list = c()
          middle_data = data.frame()
          
          middle_data  <- phone_price[phone_price$단말기명 == full_name,  ] # 단말기명 있는 데이터셋에서 full_name 입력
          for(check in middle_data[ , 4]) {
            time_list = append(time_list, check)
          }
          # 같은 단말기명이 여러 개 있는 경우(출고가 인하 때문), '가장 오래된' 출고가를 사용
          tong[unlist(index_list_unique[unlist(GB_index_list_unique)]), ]$출고가 <- (middle_data[middle_data$출시일자 == sort(time_list)[1],]$출고가)
        }
        
        # phone_price에 full_name이 없는 경우, product_name 으로 검색
        else if((table(phone_price$단말기명 == product_name_value)["FALSE"]) != 220) {           
          time_list = c()
          middle_data = data.frame()
          
          middle_data  <- phone_price[phone_price$단말기명 == product_name_value, ]
          for(check in middle_data[ , 4]) {
            time_list = append(time_list, check)
          }
          tong[unlist(index_list_unique[unlist(GB_index_list_unique)]), ]$출고가 <- (middle_data[middle_data$출시일자 == sort(time_list)[1],]$출고가) 
        }
        
      }
      
      # 데이터셋에서 용량과 관련된 정보가 없는 경우, 단순 product_name으로 검색
      else if((table(phone_price$단말기명 == product_name_value)["FALSE"]) != 220) { 
        time_list = c()
        middle_data = data.frame()
        middle_data  <- phone_price[phone_price$단말기명 == product_name_value, ]
        for(check in middle_data[ , 4]) {
          time_list = append(time_list, check)
        }
        tong[unlist(index_list_unique), ]$출고가 <- (middle_data[middle_data$출시일자 == sort(time_list)[1],]$출고가)
      }
      
   
    } # 용량 사전 1부터 5까지의 for문 끝
  } # 데이터셋에서 사전에 있는 단어가 하나라도 있는 경우, if문 실행 끝
} # 핸드폰 사전 2부터 137까지의 for문 끝

## step 4. csv 파일로 출력 ##
write.csv(tong, "data1.csv", row.names=FALSE)
