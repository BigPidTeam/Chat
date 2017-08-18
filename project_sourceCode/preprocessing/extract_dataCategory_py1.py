w#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 28 15:10:33 2017

@author: yoon
"""

import os
os.chdir("/Users/yoon/Downloads/chunk_data")

### chunk data로 분산 처리하기

import pandas as pd
import numpy as np

for i in range(1,13):
    filename = "/Users/yoon/Downloads/data_junggo/used_" + str(i) + ".csv"
    
    data = pd.read_csv(filename, chunksize = 300)
    
    columns = ["ID", "카테고리_ID", "카테고리명", "제목", 
               "등록날짜", "거래구분", "판매금액", "제품설명", 
               "지불방법", "배송방법", "상세설명", "수집날짜"]
    df = pd.DataFrame(columns=columns)
    
    for chunk in data:
        chunk.columns = columns
        chunk['ID'].astype(np.float64)
        subchunk_skt = chunk.loc[chunk['카테고리_ID'] == 339]
        subchunk_kt = chunk.loc[chunk['카테고리_ID'] == 424]
        subchunk_lg = chunk.loc[chunk['카테고리_ID'] == 425]
        subchunk_extra = chunk.loc[chunk['카테고리_ID'] == 426]
        
        if subchunk_skt.empty:
            pass
        else:
            frames = [df, subchunk_skt]
            df = pd.concat(frames)
            
        if subchunk_kt.empty:
            pass
        else:
            frames = [df, subchunk_kt]
            df = pd.concat(frames)
            
        if subchunk_lg.empty:
            pass
        else:
            frames = [df, subchunk_lg]
            df = pd.concat(frames)
            
        if subchunk_extra.empty:
            pass
        else:
            frames = [df, subchunk_extra]
            df = pd.concat(frames)
            
    df.to_csv("chunk" + str(i) + ".csv", encoding='utf-8', 
              columns=columns, index=False)
    
### 데이터들 합치기

columns = ["ID", "카테고리_ID", "카테고리명", "제목", 
               "등록날짜", "거래구분", "판매금액", "제품설명", 
               "지불방법", "배송방법", "상세설명", "수집날짜"]
df = pd.DataFrame(columns=columns)
for i in range(1,13):
    filename = "/Users/yoon/Downloads/chunk_data/chunk" + str(i) + ".csv"
    
    data = pd.read_csv(filename)
    data.columns = columns
    
    if data.empty:
        pass
    else:
        frames = [df, data]
        df = pd.concat(frames)

df.to_csv("newdata.csv", encoding='utf-8', columns=columns, index=False)


filename = "/Users/yoon/Downloads/data_junggo/used_10.csv"
filename = "/Users/yoon/Downloads/chunk_data/chunk12.csv"
data = pd.read_csv(filename)