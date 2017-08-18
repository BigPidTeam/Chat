import pandas as pd
data =pd.read_csv('/Users/yoon/Downloads/trimed_junggo_data2.csv', encoding ='UTF-8')
sub = data.drop('판매금액_month_mean', 1)
sub = sub.drop('Unnamed: 0', 1)

from sklearn.cross_validation import train_test_split
import numpy as np
from sklearn.feature_extraction import DictVectorizer

X = sub.iloc[:, 1:]
y = sub.iloc[:, 0]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)

## train data trim
X_train_numerical = X_train.ix[:, ['출고가', 'rate']]
X_train_factor = X_train.ix[:, ['제품명', 'date', '판매금액_z_rank']]

X_dict = X_train_factor.T.to_dict().values()
vect = DictVectorizer(sparse=False)
X_vector = vect.fit_transform(X_dict)
X_train_factor_vector = pd.DataFrame(X_vector)

X_train_numerical = X_train_numerical.reset_index(drop=True)
X_train_concat = pd.concat([X_train_numerical, X_train_factor_vector], axis=1)


## test data trim
X_test_numerical = X_test.ix[:, ['출고가', 'rate']]
X_test_factor = X_test.ix[:, ['제품명', 'date', '판매금액_z_rank']]

X_dict_test = X_test_factor.T.to_dict().values()
X_vector_test = vect.transform(X_dict_test)
X_test_factor_vector = pd.DataFrame(X_vector_test)

X_test_numerical = X_test_numerical.reset_index(drop=True)
X_test_concat = pd.concat([X_test_numerical, X_test_factor_vector], axis=1)


## training
from sklearn.ensemble import RandomForestRegressor

forest = RandomForestRegressor(n_estimators=1000, 
                               criterion='mse', # mse
                               random_state=1, 
                               n_jobs=-1)
forest.fit(X_train_concat, y_train)
y_train_pred = forest.predict(X_train_concat)
y_test_pred = forest.predict(X_test_concat)

from sklearn.metrics import r2_score
from sklearn.metrics import mean_squared_error
print('MSE train: %.3f, test: %.3f' % (
        mean_squared_error(y_train, y_train_pred),
        mean_squared_error(y_test, y_test_pred)))
print('R^2 train: %.3f, test: %.3f' % (
        r2_score(y_train, y_train_pred),
        r2_score(y_test, y_test_pred)))

importances = forest.feature_importances_

import matplotlib.pyplot as plt
## categorical data encoding(vectorize) 처리후 78개의 피처의 중요도 평가 plot
plt.plot(importances, "o") 
# random forest 모델의 feature selection을 auto로 설정하여 하이퍼 파라미터 튜닝 없이 최적의 모델 도출.
# 핸드폰 모델명 피처, 판매 랭크 피처가 가장 중요하고 (33%, 20%)
# 다른 피처들은 대략적으로 비슷하였음. --> 피처 선택을 조정하여 다시 진행해봄.
# 모든 피처 선택시, 954/897
# 출고가 피처 제거시, 950/895
# rate 피처 제거시, 953/896
# date 피처 제거시, 950/902
# 모델명과 판매 랭크 피처가 가장 중요하고, 다른 피처들을 제외해도 성능 자체는 비슷하게 나왔지만
# 출고가, rate, date를 조합한 특정 벡터의 설명력이 10%에 육박하는 피처가 2개가 존재하기 때문에
# 특정 상황(예를 들어, 물가지수가 매우 높은 달에 출고가가 높은 핸드폰을 구매하는 경우)에는 의미가 있다고 판단하여,
# 다른 피처들을 제거하지 않기로 결정.


## prediction - real y // 1:1 scatter flot
from sklearn import metrics
import pandas as pd

preds = forest.predict(X_test_concat)
plt.plot(y_test, preds, "o")

## 가격 오차범위 계산 : 아웃라이어를 제거한 오차범위 약 += 11%
preds2 = forest.predict(X_train_concat)
za = ((abs(preds2 - y_train) / y_train * 100)).tolist()
remove_outlier = []
for i in za: # 아웃라이어 약 200여개 제거
    if i < 50:
        remove_outlier.append(i)
np.mean(remove_outlier)
plt.plot(remove_outlier)
import random
plot_data = [ remove_outlier[i] for i in sorted(random.sample(range(len(remove_outlier)), 100)) ]
plt.plot(plot_data)


## 교차검증 실시 -> 오버피팅 정도 체크
from sklearn.model_selection import cross_val_score
scores = cross_val_score(forest, X_train_concat, y_train, cv=10)
print(scores)
# 86~94% 사이의 CV 결과. 오버피팅은 심하지 않은 것으로 결론.

pickle.dump(forest, open(os.path.join(dest, 'forest_for_prediction.pkl'), 'wb'))