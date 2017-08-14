import pickle
import os
import pandas as pd
import numpy as np
from konlpy.tag import Twitter
import nltk
from gensim import models, corpora, matutils, similarities
from sklearn.svm import SVC


pos_tagger = Twitter()
junggo_stopwords = pickle.load(open(os.path.join('files', 'junggo_stopwords.pkl'), 'rb'))
junggo_dict_ko = pickle.load(open(os.path.join('files', 'dictionary_ko_lowZ.pkl'), 'rb'))
model_svm_for_textClassify = pickle.load(open(os.path.join('files', 'svm_for_textClassify_lowZ.pkl'), 'rb'))

data =pd.read_csv('/home/ubuntu/Chat/chatbot/files/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)
ab = sub['contents'].tolist()[:50]
abc = sub['판매금액_z_rank'].tolist()[:50]


def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]


def getItemClass(doc):
    X_tokens = tokenize(doc)
    corpus_ko = junggo_dict_ko.doc2bow(X_tokens)

    corpus_ko_list = []
    corpus_ko_innerlist = []
    for k in corpus_ko:
        corpus_ko_innerlist.append(k)
    corpus_ko_list.append(corpus_ko_innerlist)

    tfidf_ko = models.TfidfModel(corpus_ko_list)
    corpus_tfidf_ko = tfidf_ko[corpus_ko_list]
    X_tfidf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], dtype=np.float64)
    y_pred_class = model_svm_for_textClassify.predict(X_tfidf)

    return y_pred_class


index = 0
for i in ab:
    index = index + 1
    print (str(index), " : ", getItemClass(i))