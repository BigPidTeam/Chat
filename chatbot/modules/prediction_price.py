import pickle
import os
import pandas as pd
from sklearn.feature_extraction import DictVectorizer


X_train_factor = pickle.load(open(os.path.join('files', 'X_train_factor.pkl'), 'rb'))
X_dict = X_train_factor.T.to_dict().values()
vect = DictVectorizer(sparse=False)
X_vector = vect.fit_transform(X_dict)

forest = pickle.load(open(os.path.join('files', 'forest_for_prediction.pkl'), 'rb'))


def getPrice(modelName, currentMonth, rank, factoryPrice, currentRate):
    columns = ['제품명','date', '판매금액_z_rank']
    X_df = pd.DataFrame(columns=columns)
    X_factor_list = [modelName, currentMonth, rank]
    X_df = X_df.append(pd.Series(X_factor_list, index=columns), ignore_index=True)

    X_input_dict = X_df.T.to_dict().values()
    X_input_vector = vect.transform(X_input_dict)
    X_input_factor_vector = pd.DataFrame(X_input_vector)

    columns_2 = ['출고가','rate']
    X_df_2 = pd.DataFrame(columns=columns_2)
    X_numeric_list = [factoryPrice, currentRate]
    X_df_2 = X_df_2.append(pd.Series(X_numeric_list, index=columns_2), ignore_index=True)

    X_train_concat = pd.concat([X_df_2, X_input_factor_vector], axis=1)

    result = forest.predict(X_train_concat)
    return (int(result[0]))