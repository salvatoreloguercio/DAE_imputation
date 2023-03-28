#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --exclusive
#SBATCH --partition=shared
#SBATCH --time=20:00:00
#SBATCH -J vmv_hp_train
#SBATCH -o vmv_hp_train.%J

export PYTHONUNBUFFERED=TRUE

module load python/3.8.3

cd /gpfs/group/torkamani/loguerci/INCITE

python train_VMV_HP_model.py

