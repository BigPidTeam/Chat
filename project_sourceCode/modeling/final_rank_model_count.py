import pandas as pd
data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)

import numpy as np
msk = np.random.rand(len(sub)) < 0.8
train_data = sub[msk]
test_data = sub[~msk]

import pickle
import os

dest = os.path.join('dictionary', 'pkl_objects')
if not os.path.exists(dest):
    os.makedirs(dest)

from konlpy.tag import Twitter


pos_tagger = Twitter()
junggo_stopwords = pickle.load(open(os.path.join('dictionary/pkl_objects', 'junggo_stopwords.pkl'), 'rb'))

###############################################################################

def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text

def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]

junggo_train_docs = [(tokenize(row['contents']), row['판매금액_z_rank']) for index, row in train_data.iterrows()]
junggo_test_docs = [(tokenize(row['contents']), row['판매금액_z_rank']) for index, row in test_data.iterrows()]

import nltk
token = [t for d in junggo_train_docs for t in d[0]]

text = nltk.Text(token, name="NMSC") # 형태소 단위 처리해주는 엔진
selected_words = [f[0] for f in text.vocab().most_common(2000)] # 문서 전체에서 등장한 단어들 top 2000

def term_exists(doc): # nltk classifier에 들어갈 형태로 리턴해줌. top 2000에 있는 단어면 True, 없으면 False
    return {'exists({})'.format(word): (word in set(doc)) for word in selected_words}

train_xy = [(term_exists(d), c) for d,c in junggo_train_docs]
test_xy = [(term_exists(d), c) for d,c in junggo_test_docs]


classifier = nltk.NaiveBayesClassifier.train(train_xy) # z=0.5 ver :: 60%
print(nltk.classify.accuracy(classifier, test_xy)) # z=0.7 ver :: 64%

from sklearn.svm import LinearSVC
classifier = nltk.classify.SklearnClassifier(LinearSVC()) # z=0.5 ver :: 62%
classifier.train(train_xy)
print(nltk.classify.accuracy(classifier, test_xy)) # z=0.7 ver :: 70%