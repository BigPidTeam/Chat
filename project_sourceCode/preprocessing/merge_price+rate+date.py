# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 12:51:15 2017

@author: forR
"""

import pandas as pd
data1=pd.read_csv("C:/py_exam/fixed_data1.csv",encoding = "UTF-8")
data2=pd.read_csv("C:/py_exam/lower_phonePrice2.csv",encoding = "UTF-8")

data1.drop("Unnamed: 0")

data1['제품명']=data1['제품명'].str.lower()
data1['용량']=data1['용량'].str.strip()

data3 = pd.merge(data1, data2,how='left',on=('용량','제품명'))

data4 = data3['제품명'].str.contains('galaxy a8 2016')
data3[data3['제품명'].str.contains('galaxy a8 2016')]

data5=data4[data4.values==True]
(data5)

data3[data6]

data3['출고가_x'].isnull().sum().sum()#nan 숫자

data1['출고가'].isnull().sum().sum()
data1['제품명'].isnull().sum().sum()

data1=pd.read_csv("C:/py_exam/data1.csv",encoding = "UTF-8")

index=data1['제목'].str.contains("데이터")

###################################################################

import pandas as pd
count=0
data1=pd.read_csv("C:/py_exam/mydata3.csv",encoding = "UTF-8")
type(data1.shape[0])
for i in range(0,data1.shape[0]) : 
        if data1['판매금액'][i]<100 :
            data1['판매금액'][i] = data1['판매금액'][i]*10000
  
data1.to_csv("mydata2.csv",encoding = "UTF-8")        

data1=pd.read_csv("C:/py_exam/finaldata.csv",encoding = "UTF-8")


data1=pd.read_csv("C:/py_exam/finaldata2.csv",encoding = "UTF-8")
mulga = pd.read_csv('C:/py_exam/mulga.csv',encoding='UTF-8')


data1 = pd.merge(data1, mulga,how='left',on='key')
data = data.drop('key',1)
data1.to_csv("finaldata3.csv", encoding="utf-8")

######################################################################

visual = pd.read_csv("C:/py_exam/trimed_junggo_data2.csv",encoding='UTF-8')

visual=visual.drop("ID",axis=1)
visual = visual.drop("카테고리_ID",axis=1)
visual = visual.drop("카테고리명",axis=1)
visual = visual.drop("제목",axis=1)
visual = visual.drop("등록날짜",axis=1)
visual = visual.drop("거래구분",axis=1)
visual = visual.drop("제품설명",axis=1)
visual = visual.drop("지불방법",axis=1)
visual = visual.drop("배송방법",axis=1)
visual = visual.drop("상세설명",axis=1)
visual = visual.drop("contents",axis=1)
visual = visual.drop("제조사",axis=1)
visual = visual.drop("date",axis=1)

returns = visual.pct_change()

visual['용량'].replace(regex=True,inplace=True,to_replace=r'\D',value=r'')



import pandas as pd 
visual = pd.read_csv("C:/py_exam/trimed_junggo_data2.csv",encoding='UTF-8')
visual = visual.drop("Unnamed: 0",axis=1)

import matplotlib.pyplot as plt
from wordcloud import WordCloud
import nltk
from konlpy.corpus import kolaw
from matplotlib import font_manager,rc
font_name = font_manager.FontProperties(fname = "C:/Windows/Fonts/Art.ttf").get_name()
rc('font',family=font_name)
from konlpy.tag import Twitter
t = Twitter()

visual1= visual[visual['판매금액_z_rank']=='A']
my=visual1['contents'].tolist()


mystr=' ' 

for i in range(0,len(my)) : 
    mystr = mystr+ my[i]



tokens_ko = t.nouns(mystr)

ko = nltk.Text(tokens_ko,name='제품상태 상')
data=ko.vocab().most_common(50)
tmp_data = dict(data)

%matplotlib qt

wordcloud = WordCloud(font_path="C:/Windows/Fonts/Art.ttf",
                      relative_scaling=0.2,
                      background_color='white'
                      ).generate_from_frequencies(tmp_data)
plt.figure(figsize=(500,500))
plt.imshow(wordcloud)
plt.axis("off")
plt.show()

import matplotlib as mpl
import matplotlib.pylab as plt

plt.plot(visual['판매금액'])
plt.suptitle("즐")

mpl.matplotlib_fname()
font_manager.get_fontconfig_fonts()

import matlab
a=fitdist(visual['판매금액'],'normal')

import numpy as np
from scipy.stats import norm
import matplotlib.mlab as mlab

plt.plot(visual['판매금액'],norm.pdf(visual['판매금액'],0,2))
from sklearn.preprocessing import scale
sca = scale(visual['판매금액'])
plt.figure(figsize=(300,500))
plt.plot(sca,mlab.normpdf(sca,0,1),c="b",lw=5,ls="--",marker = "o",ms=15,mec="g",mew=5, mfc="r")