import pandas as pd
data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)

import numpy as np
msk = np.random.rand(len(sub)) < 0.8
train_data = sub[msk]
test_data = sub[~msk]
junggo_train_data = train_data
junggo_test_data = test_data

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


def tokenizer(text):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(text), norm=True, stem=True) if t[0] not in junggo_stopwords]


def stream_docs(dataframe):
    for index, row in dataframe.iterrows():
        text, label = row['contents'], row['판매금액_z_rank']
        yield text, label


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


### mini batch 방식으로 tf-idf 진행
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.linear_model import SGDClassifier

vect = HashingVectorizer(decode_error='ignore', 
                         n_features=2**21,
                         preprocessor=None, 
                         tokenizer=tokenizer)

clf = SGDClassifier(loss='log', random_state=1, n_iter=1) # z=0.5 ver :: 65%
                                                          # z=0.7 ver :: 67%
clf = SGDClassifier(loss="hinge", penalty="l2") # z=0.5 ver :: 67%
                                                # z=0.7 ver :: 69%
doc_stream = stream_docs(junggo_train_data)


### mini batch 방식으로 모델 학습
classes = np.array(["A", "B", "C"])
for _ in range(3):
    X_train, y_train = get_minibatch(doc_stream, size=1000)
    if not X_train:
        break
    X_train = vect.transform(X_train)
    clf.partial_fit(X_train, y_train, classes=classes)


### 성능 평가
test_stream = stream_docs(junggo_test_data)
X_test, y_test = get_minibatch(doc_stream, size=500)
X_test = vect.transform(X_test)
print('Accuracy: %.3f' % clf.score(X_test, y_test))
y_pred_clf=clf.predict(X_test)
#pickle.dump(clf, open(os.path.join(dest, 'clf_svm.pkl'), 'wb'))