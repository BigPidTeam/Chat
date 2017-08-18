import pandas as pd
data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)

import numpy as np
msk = np.random.rand(len(sub)) < 0.8
train_data = sub[msk]
test_data = sub[~msk]
junggo_train_data = train_data
junggo_test_data = test_data
junggo_A = sub.ix[sub['판매금액_z_rank']=="A"]
junggo_B = sub.ix[sub['판매금액_z_rank']=="B"]
junggo_C = sub.ix[sub['판매금액_z_rank']=="C"]

import pickle
import os

dest = os.path.join('dictionary', 'pkl_objects')
if not os.path.exists(dest):
    os.makedirs(dest)

from konlpy.tag import Twitter


pos_tagger = Twitter()
junggo_stopwords = pickle.load(open(os.path.join('dictionary/pkl_objects', 'junggo_stopwords.pkl'), 'rb'))

###############################################################################
import random
import webbrowser
import pytagcloud # requires Korean font support
import sys
from collections import Counter

def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text

def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]

C_docs = [(tokenize(row['contents']), row['판매금액_z_rank']) for index, row in junggo_C.iterrows()]

import nltk
token = [t for d in C_docs for t in d[0]]

r = lambda: random.randint(0,255)
color = lambda: (r(), r(), r())

def get_tags(text, ntags=50, multiplier=1):
    count = Counter(text)
    return [{ 'color': color(), 'tag': n, 'size': int(c*multiplier*0.03) }\
                for n, c in count.most_common(ntags)]

def draw_cloud(tags, filename, fontname='Korean', size=(800, 600)):
    pytagcloud.create_tag_image(tags, filename, fontname=fontname, size=size)
    webbrowser.open(filename)

tags = get_tags(token)
draw_cloud(tags, 'wordcloud.png')