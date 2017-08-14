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
junggo_dict_ko = pickle.load(open(os.path.join('files', 'dictionary_ko.pkl'), 'rb'))
model_svm_for_textClassify = pickle.load(open(os.path.join('files', 'svm_for_textClassify.pkl'), 'rb'))


def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]


def getItemClass(doc):
    X_tokens = tokenize(doc)
    corpus_ko = [junggo_dict_ko.doc2bow(text) for text in X_tokens]
    tfidf_ko = models.TfidfModel(corpus_ko)
    corpus_tfidf_ko = tfidf_ko[corpus_ko]
    X_tfidf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], dtype=np.float64)
    y_pred_class = model_svm_for_textClassify.predict(X_tfidf)
    return y_pred_class