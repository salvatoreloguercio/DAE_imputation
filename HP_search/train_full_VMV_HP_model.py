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
import joblib
#xgb.__version__


vmv_hp_one_hot=pd.read_pickle("vmv_hp_one_hot.pkl")

X = pd.DataFrame(vmv_hp_one_hot.loc[:,vmv_hp_one_hot.columns!="r2"]) 
y = pd.DataFrame(vmv_hp_one_hot['r2'])

#lmodel = LinearRegression()
#xmodel = xgb.XGBRegressor(random_state = 123, nthread=-1)
rmodel = RandomForestRegressor(n_estimators = 100, random_state = 123)

rmodel.fit(X, np.asarray(y).flatten())

joblib.dump(rmodel, "VMV_HP_full_RF_regr_model.pkl") 

