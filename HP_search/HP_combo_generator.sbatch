#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=90G
#SBATCH --time=8:00:00
#SBATCH --job-name=HP_gen
#SBATCH -o HP_gen.%J

module load python/3.8.3

python3 HP_combo_generator.py
