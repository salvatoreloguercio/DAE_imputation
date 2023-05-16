import numpy as np
import pandas as pd
import joblib
import pickle
from numpy import mean
from numpy import std
from sklearn.datasets import make_regression
from sklearn.model_selection import RepeatedKFold
from keras.models import Sequential
from keras.layers import Dense
import matplotlib.pyplot as plt

# full training of the MLP model, with training evaluation

# load vmv / hp dataset
vmv_hp_one_hot=pd.read_pickle("vmv_hp_one_hot.pkl")

# X: all vmv +r2
# y: all hps

X = vmv_hp_one_hot.iloc[:,np.r_[0:30,43]] # 31
y = vmv_hp_one_hot.iloc[:,np.r_[30:43,44:52]] # 21


# define the MLP model
def get_model(n_inputs, n_outputs):
    model = Sequential()
    model.add(Dense(60, input_dim=n_inputs, kernel_initializer='he_uniform', activation='relu'))
    model.add(Dense(60, kernel_initializer='he_uniform', activation='relu'))
    model.add(Dense(n_outputs))
    model.compile(loss='mae', optimizer='adam')
    return model

def plot_loss(history):
    plt.plot(history.history['loss'], label='loss')
    plt.plot(history.history['val_loss'], label='val_loss')
    plt.ylim([0, 10])
    plt.xlabel('Epoch')
    plt.ylabel('MSE')
    plt.legend()
    plt.grid(True)
    plt.savefig('training_zoom_2L.png')


n_inputs, n_outputs = X.shape[1], y.shape[1]


# get model
model = get_model(n_inputs, n_outputs)

# fit the model on all data, with 20% for validation - generate learning curve
history=model.fit(X, y, verbose=2, epochs=100,validation_split = 0.2)

with open("MLP_2L_multiTarget_regression_train_history.pkl", "wb") as fp:   #Pickling
    pickle.dump(history.history, fp)

plot_loss(history)

# train model on full dataset and save it

# get model
#full_model = get_model(n_inputs, n_outputs)
#full_model.fit(X, y, verbose=2, epochs=100)

#full_model.save("full_MLP")









