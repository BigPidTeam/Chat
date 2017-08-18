data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data.csv', encoding ='UTF-8')
sub = data.drop('Unnamed: 0', 1)
ab = sub['contents'].tolist()[100:2000]
abc = sub['판매금액_z_rank'].tolist()[100:2000]

pos_tagger = Twitter()

junggo_stopwords = pickle.load(open(os.path.join('dictionary/pkl_objects', 'junggo_stopwords.pkl'), 'rb'))
clf = pickle.load(open(os.path.join('dictionary/pkl_objects', 'clf_svm.pkl'), 'rb'))

def removeNumberNpunct(doc):
    text = ''.join(c for c in doc if c.isalnum() or c in '+, ')
    text = ''.join([i for i in text if not i.isdigit()])
    return text


def tokenizer(text):
    return [t[0] for t in pos_tagger.pos(removeNumberNpunct(text), norm=True, stem=True) if t[0] not in junggo_stopwords]


vect = HashingVectorizer(decode_error='ignore',
                         n_features=2**21,
                         preprocessor=None,
                         tokenizer=tokenizer)


for i in range(100):
    X = vect.transform([ab[i]])
    Y = clf.predict(X)
    print(Y, ", ", ab[i])
    
    
X = vect.transform([ab[3]])
Y = clf.predict(X)
print(type(str(Y[0])))




import pandas as pd
from sklearn.feature_extraction import DictVectorizer

X_train_factor = pickle.load(open(os.path.join('dictionary/pkl_objects', 'X_train_factor.pkl'), 'rb'))
X_dict = X_train_factor.T.to_dict().values()
vect = DictVectorizer(sparse=False)
X_vector = vect.fit_transform(X_dict)


columns = ['제품명','date', '판매금액_z_rank']
X_df = pd.DataFrame(columns=columns)
X_factor_list = ['iphone 6 64gb', 'Oct', 'A'] # 924000 103
X_df = X_df.append(pd.Series(X_factor_list, index=columns), ignore_index=True)

X_input_dict = X_df.T.to_dict().values()
X_input_vector = vect.transform(X_input_dict)
X_input_factor_vector = pd.DataFrame(X_input_vector)

columns_2 = ['출고가','rate']
X_df_2 = pd.DataFrame(columns=columns_2)
X_numeric_list = [924000, 103] # 924000 103
X_df_2 = X_df_2.append(pd.Series(X_numeric_list, index=columns_2), ignore_index=True)

X_train_concat = pd.concat([X_df_2, X_input_factor_vector], axis=1)

forest = pickle.load(open(os.path.join('dictionary/pkl_objects', 'forest_for_prediction.pkl'), 'rb'))
result = forest.predict(X_train_concat)
int(result[0])
