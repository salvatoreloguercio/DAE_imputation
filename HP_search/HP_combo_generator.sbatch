#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --job-name=HP_gen

module load python/3.8.3

python3 HP_combo_generator.py
