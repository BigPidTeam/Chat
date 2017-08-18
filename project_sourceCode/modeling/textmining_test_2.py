######################################################################## 준비작업
import pickle
import os

dest = os.path.join('dictionary', 'pkl_objects')
if not os.path.exists(dest):
    os.makedirs(dest)
    
pickle.dump(custom_stopwords, open(os.path.join(dest, 'stopwords.pkl'), 'wb')) 
stopwords_read = pickle.load(open(os.path.join('dictionary/pkl_objects', 'stopwords.pkl'), 'rb'))

######################################## 사전 기반 단어 출현 count 후, 나이브베이즈 분류
import nltk
from konlpy.tag import Twitter

pos_tagger = Twitter() # 형태소, 단어 추출기


def tokenize(doc): # doc data에서 형태소, 단어 형태로 추출하여 리턴
    return ['/'.join(t) for t in pos_tagger.pos(doc, norm=True, stem=True)]


train_docs = [(tokenize(row[1]), row[2]) for row in train_data]
test_docs = [(tokenize(row[1]), row[2]) for row in test_data]

token = [t for d in train_docs for t in d[0]]

text = nltk.Text(token, name="NMSC") # 형태소 단위 처리해주는 엔진
selected_words = [f[0] for f in text.vocab().most_common(2000)] # 문서 전체에서 등장한 단어들 top 2000


def term_exists(doc): # nltk classifier에 들어갈 형태로 리턴해줌. top 2000에 있는 단어면 True, 없으면 False
    return {'exists({})'.format(word): (word in set(doc)) for word in selected_words}


train_xy = [(term_exists(d), c) for d,c in train_docs]
test_xy = [(term_exists(d), c) for d,c in test_docs]


classifier = nltk.NaiveBayesClassifier.train(train_xy)
print(nltk.classify.accuracy(classifier, test_xy))

####################################################### tf-idf 정리 후 로지스틱 분류
import numpy as np
from gensim import models, corpora, matutils, similarities
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.linear_model import SGDClassifier


### 문서를 스트리밍 형식으로 읽도록 하는 함수
def stream_docs(dataset):
    for row in dataset:
        text, label = row[0], int(row[1])
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
doc_stream = stream_docs(train_docs)

classes = np.array([0, 1])
for _ in range(100):
    X_train, y_train = get_minibatch(doc_stream, size=1000)
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
test_stream = stream_docs(test_docs)
X_test, y_test = get_minibatch(test_stream, size=1000)

corpus_ko = [dictionary_ko.doc2bow(text) for text in X_test]
tfidf_ko = models.TfidfModel(corpus_ko)
corpus_tfidf_ko = tfidf_ko[corpus_ko]
X_asdf = np.asarray([matutils.sparse2full(vec, 2000) for vec in corpus_tfidf_ko], 
                     dtype=np.float64)
print('Accuracy: %.3f' % clf.score(X_asdf, y_test))

########################################################### doc2vec으로 피처셋 정리
from collections import namedtuple

TaggedDocument = namedtuple("TaggedDocument", "words tags")
tagged_train_docs = [TaggedDocument(d, [c]) for d,c in train_docs]
tagged_test_docs = [TaggedDocument(d, [c]) for d,c in test_docs]

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

from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression(random_state=1234)
classifier.fit(train_x, train_y)
classifier.score(test_x, test_y)