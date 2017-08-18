### data read

import pandas as pd
data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)

### 
import pickle
import os

dest = os.path.join('dictionary', 'pkl_objects')
if not os.path.exists(dest):
    os.makedirs(dest)
    
# pickle.dump(custom_stopwords, open(os.path.join(dest, 'junggo_stopwords.pkl'), 'wb')) 
junggo_stopwords = pickle.load(open(os.path.join('dictionary/pkl_objects', 'junggo_stopwords.pkl'), 'rb'))

####################################################### tf-idf 정리 후

import numpy as np
msk = np.random.rand(len(sub)) < 0.8
train_data = sub[msk]
test_data = sub[~msk]
junggo_train_data = train_data
junggo_test_data = test_data

from konlpy.tag import Twitter
pos_tagger = Twitter()

def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text

def tokenize(doc):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(doc), norm=True, stem=True) if t[0] not in junggo_stopwords]

junggo_train_docs = [(tokenize(row['contents']), row['판매금액_z_rank']) for index, row in train_data.iterrows()]
junggo_test_docs = [(tokenize(row['contents']), row['판매금액_z_rank']) for index, row in test_data.iterrows()]

### 문서를 스트리밍 형식으로 읽도록 하는 함수
def stream_docs(dataset):
    for row in dataset:
        text, label = row[0], row[1]
        yield text, label # yield 키워드를 사용하면 generator를 만들 수 있다


### 미니배치를 얻어오는 함수
def get_minibatch(doc_stream, size):
    docs, y = [], []
    try:
        for _ in range(size):
            text, label = next(doc_stream)
            docs.append(text)
            y.append(label)
    except StopIteration:
        return None, None
    return docs, y

import nltk
from gensim import models, corpora, matutils, similarities
token = [t for d in junggo_train_docs for t in d[0]]

text = nltk.Text(token, name="NMSC") # 형태소 단위 처리해주는 엔진
selected_words = [f[0] for f in text.vocab().most_common(2000)] # 문서 전체에서 등장한 단어들 top 2000

dict_ko = [[i] for i in selected_words]
dictionary_ko = corpora.Dictionary(dict_ko) # tf-idf의 검색 기반이 되는 사전 구축.
pickle.dump(dictionary_ko, open(os.path.join(dest, 'dictionary_ko_lowZ.pkl'), 'wb')) 

doc_stream = stream_docs(junggo_train_docs)

X_train, y_train = get_minibatch(doc_stream, size=3900) # tf-idf training set
corpus_ko = [dictionary_ko.doc2bow(text) for text in X_train]
tfidf_ko = models.TfidfModel(corpus_ko)
corpus_tfidf_ko = tfidf_ko[corpus_ko]
X_tfidf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                      dtype=np.float64)

test_stream = stream_docs(junggo_test_docs)
X_test, y_test = get_minibatch(test_stream, size=90) # tf-idf test set
corpus_ko = [dictionary_ko.doc2bow(text) for text in X_test]
tfidf_ko = models.TfidfModel(corpus_ko)
corpus_tfidf_ko = tfidf_ko[corpus_ko]
X_tfidf_test = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                           dtype=np.float64)

#==============================================================================
# # 차원축소
# from sklearn.lda import LDA
# lda = LDA(n_components=3)
# X_compressed = lda.fit_transform(X_tfidf, y_train)
# X_test_compressed = lda.transform(X_tfidf_test)
# pickle.dump(lda, open(os.path.join(dest, 'lda.pkl'), 'wb')) 
#==============================================================================
from sklearn.metrics import accuracy_score

# 선형 SVM
from sklearn.svm import SVC
svm = SVC(kernel='linear', C=1.0, random_state=0)
svm.fit(X_tfidf, y_train)
y_pred_svc = svm.predict(X_tfidf_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_svc)) # 선형 SVM 분류기 --> 82%

# pickle.dump(svm, open(os.path.join(dest, 'svm_for_textClassify_lowZ.pkl'), 'wb')) 

# 비선형 SVM
svm = SVC(kernel='rbf', C=10.0, random_state=0, gamma=0.10)
svm.fit(X_tfidf, y_train)
y_pred_ksvc = svm.predict(X_tfidf_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_ksvc)) # 비선형 SVM 분류기 --> 83%
pickle.dump(svm, open(os.path.join(dest, 'svm_for_textClassify.pkl'), 'wb')) 

# 나이브 베이즈 분류기
from sklearn.naive_bayes import GaussianNB
clf = GaussianNB()
clf.fit(X_tfidf, y_train)
y_pred_nb = svm.predict(X_tfidf_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_nb)) # 나이브베이즈 분류기 --> 83%

# 로지스틱 분류기
from sklearn.linear_model import LogisticRegression
clf = LogisticRegression(random_state=1234)
clf.fit(X_tfidf, y_train)
clf.score(X_tfidf_test, y_test) # 로지스틱 분류기 --> 81%