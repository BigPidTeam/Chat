import pickle
import os
import pandas as pd
import numpy as np
from konlpy.tag import Twitter
import nltk


pos_tagger = Twitter()
junggo_stopwords = pickle.load(open(os.path.join('files', 'junggo_stopwords.pkl'), 'rb'))


def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]