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

from collections import namedtuple

TaggedDocument = namedtuple("TaggedDocument", "words tags")
tagged_train_docs = [TaggedDocument(d, [c]) for d,c in junggo_train_docs]
tagged_test_docs = [TaggedDocument(d, [c]) for d,c in junggo_test_docs]

from gensim.models import doc2vec

doc_vectorizer = doc2vec.Doc2Vec(size=300, alpha=0.025, min_alpha=0.025, seed=1234)
doc_vectorizer.build_vocab(tagged_train_docs)

for epoch in range(10):
    doc_vectorizer.train(tagged_train_docs, total_words = 2000, epochs=10)
    doc_vectorizer.alpha -= 0.002
    doc_vectorizer.min_alpha = doc_vectorizer.alpha

train_x = [doc_vectorizer.infer_vector(doc.words) for doc in tagged_train_docs]
train_y = [doc.tags[0] for doc in tagged_train_docs]

test_x = [doc_vectorizer.infer_vector(doc.words) for doc in tagged_test_docs]
test_y = [doc.tags[0] for doc in tagged_test_docs]

# 로지스틱 분류기
from sklearn.linear_model import LogisticRegression
clf = LogisticRegression(random_state=1234)
clf.fit(train_x, train_y)
clf.score(test_x, test_y) # z=0.5 ver :: 50%
                          # z=0.7 ver :: 60%

# 선형 SVM
from sklearn.svm import SVC 
svm = SVC(kernel='linear', C=1.0, random_state=0)
svm.fit(train_x, train_y)
y_pred_svc = svm.predict(test_x)
print('Accuracy: %.2f' % accuracy_score(test_y, y_pred_svc)) # z=0.5 ver :: 50%
                                                             # z=0.7 ver :: 60%
# 비선형 SVM
svm = SVC(kernel='rbf', C=10.0, random_state=0, gamma=0.10)
svm.fit(train_x, train_y)
y_pred_ksvc = svm.predict(test_x)
print('Accuracy: %.2f' % accuracy_score(test_y, y_pred_ksvc)) # z=0.5 ver :: 44%
                                                              # z=0.5 ver :: 57%
# 나이브 베이즈 분류기
from sklearn.naive_bayes import GaussianNB
clf = GaussianNB()
clf.fit(train_x, train_y)
y_pred_nb = svm.predict(test_x)
print('Accuracy: %.2f' % accuracy_score(test_y, y_pred_nb)) # z=0.5 ver :: 44%
                                                            # z=0.5 ver :: 57%