#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=gpu
#SBATCH --time=20:00:00
#SBATCH -J vmv_hp_multiT
#SBATCH -o vmv_hp_multiT.%J

export PYTHONUNBUFFERED=TRUE

module load python/3.8.3
module load tensorflow

cd /gpfs/group/torkamani/loguerci/INCITE

python $1