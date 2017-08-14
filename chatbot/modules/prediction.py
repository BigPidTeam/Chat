import pickle
import os
from konlpy.tag import Twitter
from sklearn.feature_extraction.text import HashingVectorizer


pos_tagger = Twitter()
junggo_stopwords = pickle.load(open(os.path.join('files', 'junggo_stopwords.pkl'), 'rb'))
clf = pickle.load(open(os.path.join('files', 'clf_svm.pkl'), 'rb'))


def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


def tokenizer(text):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(text), norm=True, stem=True) if t[0] not in junggo_stopwords]


def getItemClass(doc):
    vect = HashingVectorizer(decode_error='ignore',
                             n_features=2 ** 21,
                             preprocessor=None,
                             tokenizer=tokenizer)
    X = vect.transform([doc])
    y_pred_class = clf.predict(X)

    return str(y_pred_class[0])