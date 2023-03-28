import numpy as np
import pandas as pd
from sklearn.impute import KNNImputer
import re

from sklearn import preprocessing
from sklearn.model_selection import KFold
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import LogisticRegression
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
from sklearn.metrics import r2_score
import xgboost as xgb
from sklearn.ensemble import RandomForestRegressor
#xgb.__version__


vmv_hp_one_hot=pd.read_pickle("vmv_hp_one_hot.pkl")

X = pd.DataFrame(vmv_hp_one_hot.loc[:,vmv_hp_one_hot.columns!="r2"]) 
y = pd.DataFrame(vmv_hp_one_hot['r2'])

lmodel = LinearRegression()
xmodel = xgb.XGBRegressor(random_state = 123, nthread=-1)
rmodel = RandomForestRegressor(n_estimators = 100, random_state = 123)

lscores = []
xscores = []
rscores = []
ly_preds = []
y_trues = []
xy_preds = []
ry_preds = []

#clean column labels, required for xgboost
regex = re.compile(r"\[|\]|<", re.IGNORECASE)
X.columns = [regex.sub("_", col) if any(x in str(col) for x in set(('[', ']', '<'))) else col for col in X.columns.values]

kfold = KFold(n_splits = 10, shuffle = True, random_state = 123)

for i, (train, test) in enumerate(kfold.split(X, y)):
    print("Iteration", i)
    lmodel.fit(X.iloc[train,:], y.iloc[train,:])
    xmodel.fit(X.iloc[train,:], np.asarray(y.iloc[train,:]).flatten())
    rmodel.fit(X.iloc[train,:], np.asarray(y.iloc[train,:]).flatten())
    lscore = lmodel.score(X.iloc[test,:], y.iloc[test,:])
    xscore = xmodel.score(X.iloc[test,:], np.asarray(y.iloc[test,:]))
    rscore = rmodel.score(X.iloc[test,:], np.asarray(y.iloc[test,:]))
    #score = r2_score(np.array(y.iloc[test,:]).flatten(), lmodel.predict(X.iloc[test,:]).flatten())
    y_trues += [list(np.array(y.iloc[test,:]).flatten())]
    ly_preds += [list(lmodel.predict(X.iloc[test,:]).flatten())]
    xy_preds += [list(xmodel.predict(X.iloc[test,:]).flatten())]
    ry_preds += [list(rmodel.predict(X.iloc[test,:]).flatten())]

    lscores.append(lscore)
    #score = r2_score(np.array(y.iloc[test,:]).flatten(), xmodel.predict(X.iloc[test,:]).flatten())
    xscores.append(xscore)
    rscores.append(rscore)
    print(lscore)
    print(xscore)
    print(rscore)

my_df = pd.DataFrame()
my_df['LR'] = lscores
my_df['XGB'] = xscores
my_df['RF'] = rscores

my_df.to_csv('XGBOOST_results_imputator_r2_summary_expanded.csv', mode='w', index=False)        

for i in range(10):
    my_df = pd.DataFrame()
    my_df['K'] = np.repeat(i,len(y_trues[i]))
    my_df['LR'] = ly_preds[i]
    my_df['XGB'] = xy_preds[i]
    my_df['RF'] = ry_preds[i]
    my_df['R2true'] = y_trues[i]
    if(i==0):
        my_df.to_csv('XGBOOST_results_imputator_ypreds_ytrues_expanded.csv', mode='w', index=False)        
    else:
        my_df.to_csv('XGBOOST_results_imputator_ypreds_ytrues_expanded.csv', mode='a', index=False, header=False)


# scatterplot - lr

figure(figsize=(10, 8), dpi=100)

plt.plot(ly_preds[0], y_trues[0], 'o')
#obtain m (slope) and b(intercept) of linear regression line
m, b = np.polyfit(ly_preds[0], y_trues[0], 1)
slope = m*np.asarray(ly_preds[0])+b
#add linear regression line to scatterplot 
plt.plot(ly_preds[0], slope)
plt.xlabel('predicted r2')
plt.ylabel('observed r2')
plt.xlim([0,0.6])
plt.ylim([0,0.6])
print(lscores)

plt.savefig('vmv_hp_lin_reg.png',dpi=100)

plt.plot(xy_preds[0], y_trues[0], 'o')
#obtain m (slope) and b(intercept) of linear regression line
m, b = np.polyfit(xy_preds[0], y_trues[0], 1)
slope = m*np.asarray(xy_preds[0])+b
#add linear regression line to scatterplot 
plt.plot(xy_preds[0], slope)
plt.xlabel('predicted r2')
plt.ylabel('observed r2')
plt.xlim([0,0.6])
plt.ylim([0,0.6])
print(xscores)

plt.savefig('vmv_hp_xgboost.png',dpi=100)

plt.plot(ry_preds[0], y_trues[0], 'o')
#obtain m (slope) and b(intercept) of linear regression line
m, b = np.polyfit(ry_preds[0], y_trues[0], 1)
slope = m*np.asarray(ry_preds[0])+b
#add linear regression line to scatterplot 
plt.plot(ry_preds[0], slope)
plt.xlabel('predicted r2')
plt.ylabel('observed r2')
plt.xlim([0,0.6])
plt.ylim([0,0.6])
print(rscores)

plt.savefig('vmv_hp_RF.png',dpi=100)










