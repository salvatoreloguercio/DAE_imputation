# coding: utf-8

import itertools

import random #masking

import timeit #measure runtime


def make_new_grid(l1_arr, l2_arr, beta_arr, rho_arr, act_arr, learning_rate_arr, gamma_arr, opt_array, loss_arr, hs_arr, lb_array, rb_array, kp_arr, N=1000,flname):
    print("Building grid search combinations.")

    grid = [l1_arr, l2_arr, beta_arr, rho_arr, gamma_arr, dis_alpha_arr, flip_alpha_arr, inv_alpha_arr, learning_rate_arr, act_arr, opt_array, loss_arr, n_layers_arr, size_ratio_arr, decay_rate_arr, batch_size_arr]
    
    l = list(itertools.product(*grid))

    print("Extracted", N, "from", len(l), "possible combinations.")
    list_of_random_items = random.sample(l, N)
    idx=0

    file_name = "hyper_parameter_list."+ flname + "_" +str(N)+".txt"

    print("Saving new grid to", file_name)    
    #open(file_name, "w").close()

    with open(file_name, "w") as f:
        f.write("L1 L2 beta rho gamma disable_alpha flip_alpha inverse_alpha learn_rate activation optimizer loss_type n_layers size_ratio decay_rate batch_size")
    f.close()

    while idx < len(list_of_random_items):
        par_list = ''
        for i in range(len(list_of_random_items[idx])):
            par_list += " " + str(list_of_random_items[idx][i])

        with open(file_name, "a") as par_file:
            print(par_list[1:], file=par_file)
        
        idx+=1

#############

# loss: FL
l1_arr = [1e-1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-7,1e-8,0]
l2_arr = [1e-1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-7,1e-8,0]
beta_arr = [0,1e-1,1e-2,1e-3,1,5]
rho_arr = [0.005, 0.01, 0.05, 0.1, 0.25, 0.5]
gamma_arr = [0,0.5,1,3,5,7]
dis_alpha_arr = [0,1]
flip_alpha_arr = [0,1]
inv_alpha_arr = [0,1]
learning_rate_arr = [1e-1,1e-2,1e-3,1e-4,1e-5]
act_arr = ['relu', 'tanh', 'sigmoid']
opt_array = ['adam', 'sgd', 'radam']
loss_arr = "FL"
n_layers_arr = [2,4,6,8,10]
size_ratio_arr = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.25]
decay_rate_arr = [0.0, 1e-4, 1e-3, 1e-2, 0.1]
batch_size_arr = [64,128,256,512]

make_new_grid(l1_arr, l2_arr, beta_arr, rho_arr, gamma_arr, dis_alpha_arr, flip_alpha_arr, inv_alpha_arr, learning_rate_arr, act_arr, opt_array, loss_arr, n_layers_arr, size_ratio_arr, decay_rate_arr, batch_size_arr,500000,"FL")

# loss: CE
gamma_arr = 0
dis_alpha_arr = 1
flip_alpha_arr = 0
inv_alpha_arr = 0
loss_arr = "CE"

make_new_grid(l1_arr, l2_arr, beta_arr, rho_arr, gamma_arr, dis_alpha_arr, flip_alpha_arr, inv_alpha_arr, learning_rate_arr, act_arr, opt_array, loss_arr, n_layers_arr, size_ratio_arr, decay_rate_arr, batch_size_arr,500000,"CE")




#Old version used until may 2019
#act_arr = ['sigmoid','tanh', 'relu']
#l1_arr = [1e-3,1e-4,1e-5,1e-6,1e-1,1e-2,1e-7,1e-8] #RR these are the values for l1 that we want to test in the search grid, should be between zero and 1, near zero
#l2_arr = [1e-3,1e-4,1e-5,1e-6,1e-1,1e-2,1e-7,1e-8]  #RR these are the values for l2 that we want to test in the search grid, should be between zero and 1, near zero
#beta_arr = [0.001, 0.01,0.05,1,2,4,6,8,10] #RR these are the values for beta that we want to test in the search grid, should be greater than zero
#rho_arr = [0.001, 0.004, 0.007, 0.01, 0.04, 0.07, 0.1, 0.4, 0.7, 1.0] #RR these are the values for rho that we want to test in the search grid, should be between 0 and 1
#learning_rate_arr = [0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100]
#gamma_arr = [0,0.5,1,2,3,5]
#opt_array = ["Adam", "RMSProp", "GradientDescent"]
#loss_arr = ["MSE", "CE", "FL"]
#grid_sizes = [25, 50, 100, 500, 1000, 5000, 10000]

# #Old version used for initial refinement, Minimac blocks, July, 2019
# act_arr = ['tanh']
# l1_arr = [1e-3,1e-4,1e-5,1e-6,1e-1,1e-2,1e-7,1e-8] #RR these are the values for l1 that we want to test in the search grid, should be between zero and 1, near zero
# l2_arr = [0]  #RR these are the values for l2 that we want to test in the search grid, should be between zero and 1, near zero
# beta_arr = [1,2,4,6,8,10] #RR these are the values for beta that we want to test in the search grid, should be greater than zero
# rho_arr = [0.001, 0.004, 0.007, 0.01, 0.04, 0.07, 0.1, 0.4, 0.7, 1.0] #RR these are the values for rho that we want to test in the search grid, should be between 0 and 1
# learning_rate_arr = [0.00001, 0.0001, 0.001]
# gamma_arr = [0,0.5,1,2,3,5]
# opt_array = ["RMSProp"]
# loss_arr = ["FL"]
# hs_arr = ['sqrt', '0.10', '0.20', '0.40', '0.60', '0.80', '1']
# #new parameters added/edited on june 2019
# lb_array = ['0'] #let them as fixed labels to replace them by custom values later (i.e neighbor block sizes)
# rb_array = ['0'] #let them as fixed labels to replace them by custom values later (i.e neighbor block sizes)
# grid_sizes = [25, 50, 100, 500, 1000, 5000, 10000]


# #new version for final fine tunning on our final VMV data, November, 2019
# act_arr = ['tanh']
# l1_arr = [1e-2,1e-3,1e-4,1e-6] #RR these are the values for l1 that we want to test in the search grid, should be between zero and 1, near zero
# l2_arr = [0,1e-3,1e-4,1e-6]  #RR these are the values for l2 that we want to test in the search grid, should be between zero and 1, near zero
# beta_arr = [0.1,1,5,10] #RR these are the values for beta that we want to test in the search grid, should be greater than zero
# rho_arr = [0.001, 0.004, 0.007, 0.01, 0.04, 0.07, 0.1] #RR these are the values for rho that we want to test in the search grid, should be between 0 and 1
# learning_rate_arr = [0.00001, 0.0001, 0.001]
# gamma_arr = [0,0.5,1,3,5,10]
# opt_array = ["RMSProp"]
# loss_arr = ["FL"]
# hs_arr = ['1']
# lb_array = ['0'] #let them as fixed labels to replace them by custom values later (i.e neighbor block sizes)
# rb_array = ['0'] #let them as fixed labels to replace them by custom values later (i.e neighbor block sizes)
# kp_arr = ['1,0.5','1,0.7','1,1','1']

# grid_sizes = [25, 50, 100]

# for N in grid_sizes:
#     make_new_grid(l1_arr, l2_arr, beta_arr, rho_arr, act_arr,learning_rate_arr, gamma_arr, opt_array, loss_arr, hs_arr, lb_array, rb_array, kp_arr,N)
