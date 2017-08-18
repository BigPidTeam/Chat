### data read

import pandas as pd
data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)

### 
import pickle
import os

custom_stopwords = list()

def makedict(words):    
    for word in words:
        if word not in custom_stopwords:
            custom_stopwords.append(word)
            
            
dest = os.path.join('dictionary', 'pkl_objects')
if not os.path.exists(dest):
    os.makedirs(dest)
    
# pickle.dump(custom_stopwords, open(os.path.join(dest, 'junggo_stopwords.pkl'), 'wb')) 
junggo_stopwords = pickle.load(open(os.path.join('dictionary/pkl_objects', 'junggo_stopwords.pkl'), 'rb'))


import numpy as np
msk = np.random.rand(len(sub)) < 0.8
train_data = sub[msk]
test_data = sub[~msk]


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

######################################## 사전 기반 단어 출현 count 후, 나이브베이즈 분류
import nltk
token = [t for d in junggo_train_docs for t in d[0]]

text = nltk.Text(token, name="NMSC") # 형태소 단위 처리해주는 엔진
selected_words = [f[0] for f in text.vocab().most_common(2000)] # 문서 전체에서 등장한 단어들 top 2000

def term_exists(doc): # nltk classifier에 들어갈 형태로 리턴해줌. top 2000에 있는 단어면 True, 없으면 False
    return {'exists({})'.format(word): (word in set(doc)) for word in selected_words}

train_xy = [(term_exists(d), c) for d,c in junggo_train_docs]
test_xy = [(term_exists(d), c) for d,c in junggo_test_docs]


classifier = nltk.NaiveBayesClassifier.train(train_xy) # 나이브베이즈 분류기 --> 70%
print(nltk.classify.accuracy(classifier, test_xy))

from sklearn.svm import LinearSVC # SVM 분류기 --> 75%
classifier = nltk.classify.SklearnClassifier(LinearSVC())
classifier.train(train_xy)
print(nltk.classify.accuracy(classifier, test_xy))

####################################################### tf-idf 정리 후 로지스틱 분류
import numpy as np
from gensim import models, corpora, matutils, similarities
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.linear_model import SGDClassifier


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


dict_ko = [[i] for i in selected_words]
dictionary_ko = corpora.Dictionary(dict_ko) # tf-idf의 검색 기반이 되는 사전 구축.
# dictionary_ko.save('ko.dict')


### mini batch 방식으로 모델 학습
import pyprind
pbar = pyprind.ProgBar(100)

clf = SGDClassifier(loss='log', random_state=1, n_iter=1)
doc_stream = stream_docs(junggo_train_docs)

classes = np.array(['A', 'B', 'C'])
for _ in range(10):
    X_train, y_train = get_minibatch(doc_stream, size=500)
    if not X_train:
        break
    corpus_ko = [dictionary_ko.doc2bow(text) for text in X_train]
    tfidf_ko = models.TfidfModel(corpus_ko)
    corpus_tfidf_ko = tfidf_ko[corpus_ko]
    X_tfidf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                      dtype=np.float64)
    clf.partial_fit(X_tfidf, y_train, classes=classes)
    pbar.update()


### 성능 평가
test_stream = stream_docs(junggo_test_docs)
X_test, y_test = get_minibatch(test_stream, size=100)

corpus_ko = [dictionary_ko.doc2bow(text) for text in X_test]
tfidf_ko = models.TfidfModel(corpus_ko)
corpus_tfidf_ko = tfidf_ko[corpus_ko]
X_asdf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                     dtype=np.float64)
print('Accuracy: %.3f' % clf.score(X_asdf, y_test)) # 로지스틱 분류기 --> 74%

############################################################## tf-idf batch 버전
dict_ko = [[i] for i in selected_words]
dictionary_ko = corpora.Dictionary(dict_ko) # tf-idf의 검색 기반이 되는 사전 구축.

doc_stream = stream_docs(junggo_train_docs)

X_train, y_train = get_minibatch(doc_stream, size=3900) # tf-idf training set
corpus_ko = [dictionary_ko.doc2bow(text) for text in X_train]
tfidf_ko = models.TfidfModel(corpus_ko)
corpus_tfidf_ko = tfidf_ko[corpus_ko]
X_tfidf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                      dtype=np.float64)

test_stream = stream_docs(junggo_test_docs)
X_test, y_test = get_minibatch(test_stream, size=900) # tf-idf test set
corpus_ko = [dictionary_ko.doc2bow(text) for text in X_test]
tfidf_ko = models.TfidfModel(corpus_ko)
corpus_tfidf_ko = tfidf_ko[corpus_ko]
X_tfidf_test = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                           dtype=np.float64)

# 로지스틱 회귀
from sklearn.linear_model import LogisticRegression

lr = LogisticRegression(C=1000.0, random_state=0) #C는 벌칙 상수.
lr.fit(X_tfidf, y_train) #표준화된 데이터 적용

lr.predict_proba(X_tfidf_test[0,:]) #해당 분류에 속할 확률값으로 결과 도출
y_pred_lr=lr.predict(X_tfidf_test) #예측한 분류값을 보고싶을 때

from sklearn.metrics import accuracy_score
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_lr)) # 로지스틱 분류기 --> 75%

# 선형 SVM
from sklearn.svm import SVC
svm = SVC(kernel='linear', C=1.0, random_state=0)
svm.fit(X_tfidf, y_train)
y_pred_svc = svm.predict(X_tfidf_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_svc)) # 선형 SVM 분류기 --> 80%

# 비선형 SVM
svm = SVC(kernel='rbf', C=10.0, random_state=0, gamma=0.10)
svm.fit(X_tfidf, y_train)
y_pred_ksvc = svm.predict(X_tfidf_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_ksvc)) # 비선형 SVM 분류기 --> 82%

# 나이브 베이즈 분류기
from sklearn.naive_bayes import GaussianNB
clf = GaussianNB()
clf.fit(X_tfidf, y_train)
y_pred_nb = svm.predict(X_tfidf_test)
print('Accuracy: %.2f' % accuracy_score(y_test, y_pred_nb)) # 나이브베이즈 분류기 --> 77%

########################################################### doc2vec으로 피처셋 정리
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
clf.score(test_x, test_y) # 로지스틱 분류기 --> 70%

# 선형 SVM
from sklearn.svm import SVC 
svm = SVC(kernel='linear', C=1.0, random_state=0)
svm.fit(train_x, train_y)
y_pred_svc = svm.predict(test_x)
print('Accuracy: %.2f' % accuracy_score(test_y, y_pred_svc)) # 선형 SVM 분류기 --> 73%

# 비선형 SVM
svm = SVC(kernel='rbf', C=10.0, random_state=0, gamma=0.10)
svm.fit(train_x, train_y)
y_pred_ksvc = svm.predict(test_x)
print('Accuracy: %.2f' % accuracy_score(test_y, y_pred_ksvc)) # 비선형 SVM 분류기 --> 72%

# 나이브 베이즈 분류기
from sklearn.naive_bayes import GaussianNB
clf = GaussianNB()
clf.fit(train_x, train_y)
y_pred_nb = svm.predict(test_x)
print('Accuracy: %.2f' % accuracy_score(test_y, y_pred_nb)) # 나이브베이즈 분류기 --> 72%