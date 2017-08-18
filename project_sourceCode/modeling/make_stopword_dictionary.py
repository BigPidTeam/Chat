# 사전 만드는 과정
# 전체 데이터중 일부를 샘플링한 뒤, 한국어 형태소 분석기로 단어의 원형들을 추출해냄
# 추출해내는 과정에서 '+', ','를 제외한 특수문자를 제거함
# 추출해낸 단어의 원형들 중에서 명사, 형용사, 동사

import pandas as pd
import numpy as np
import re

filename = "/Users/yoon/Downloads/newdata.csv"
newdata = pd.read_csv(filename, encoding = "utf-8")

import random
small_newdata = newdata.sample(frac=0.3) # 전체 데이터중 일부를 샘플링

from konlpy.tag import Twitter

text_data = small_newdata['contents'] # 텍스트 데이터만 가져옴
twitter = Twitter()

# 단어 원형 추출
sentences_tag=[]
for line in text_data:
    # '+', ',', 'space' 빼고 모든 특수문자 제거, 숫자 제거
    text = ''.join(c for c in line if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    sentences_tag.append(twitter.pos(text))

# 품사 리스트 추출
# pumsa_list = []
# for sentence in sentences_tag:
#    for tup in sentence:
#        pumsa_list.append(tup[1])
# pumsa_set = set(pumsa_list)
# print (pumsa_set)
    
noun_adj_list = [] # 명사, 형용사, 동사 추출
alpha_adj_list = []
suffix_adj_list = []
exclamation_adj_list = []
punctuation_adj_list = []
conjunction_adj_list = []
preEomi_adj_list = []
foreign_adj_list = []
koreranparticle_adj_list = []
eomi_adj_list = []
josa_adj_list = []
nounprefix_adj_list = []
determiner_adj_list = []
adverb_adj_list = []
verbprefix_adj_list = []
for sentence in sentences_tag:
    for word, tag in sentence:
        if tag in ['Noun', 'Adjective', 'Verb']:
            noun_adj_list.append(word)
        if tag in ['Alpha']:
            alpha_adj_list.append(word)
        if tag in ['Suffix']:
            suffix_adj_list.append(word)
        if tag in ['Exclamation']:
            exclamation_adj_list.append(word)
        if tag in ['Punctuation']:
            punctuation_adj_list.append(word)
        if tag in ['Conjunction']:
            conjunction_adj_list.append(word)
        if tag in ['PreEomi']:
            preEomi_adj_list.append(word)
        if tag in ['Foreign']:
            foreign_adj_list.append(word)
        if tag in ['KoreanParticle']:
            koreranparticle_adj_list.append(word)
        if tag in ['Eomi']:
            eomi_adj_list.append(word)
        if tag in ['Josa']:
            josa_adj_list.append(word)
        if tag in ['NounPrefix']:
            nounprefix_adj_list.append(word)
        if tag in ['Determiner']:
            determiner_adj_list.append(word)
        if tag in ['Adverb']:
            adverb_adj_list.append(word)
        if tag in ['VerbPrefix']:
            verbprefix_adj_list.append(word)


from collections import Counter
counts = Counter(noun_adj_list)
counts2 = Counter(alpha_adj_list)
counts3 = Counter(suffix_adj_list)
counts4 = Counter(exclamation_adj_list)
counts5 = Counter(punctuation_adj_list)
counts6 = Counter(conjunction_adj_list)
counts7 = Counter(preEomi_adj_list)
counts8 = Counter(foreign_adj_list)
counts9 = Counter(koreranparticle_adj_list)
counts10 = Counter(eomi_adj_list)
counts11 = Counter(josa_adj_list)
counts12 = Counter(nounprefix_adj_list)
counts13 = Counter(determiner_adj_list)
counts14 = Counter(adverb_adj_list)
counts15 = Counter(verbprefix_adj_list)

print(counts.most_common(100))
print(counts2.most_common(100))
print(counts3.most_common(100))
print(counts4.most_common(100))
print(counts5.most_common(100))
print(counts6.most_common(100))
print(counts7.most_common(100))
print(counts8.most_common(100))
print(counts9.most_common(100))
print(counts10.most_common(100))
print(counts11.most_common(100))
print(counts12.most_common(100))
print(counts13.most_common(100))
print(counts14.most_common(100))
print(counts15.most_common(100))


### 저장해둔 모델 파일 읽기
stopwords_read = pickle.load(open(os.path.join('dictionary/pkl_objects', 'stopwords.pkl'), 'rb'))

count1_list = ["요렇게", "달면", "됨"]