#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=gpu
#SBATCH --time=6:00:00
##SBATCH --job-name=2_validate_and_select_best
#SBATCH --output=%x.oe%j
#SBATCH --error=%x.oe%j


module load samtools
module load R
module load pytorch/1.11.1py38-cuda

cd $SLURM_SUBMIT_DIR


while read mdir; do
    
    echo $mdir
    bash 2_validate_and_select_best.sh $mdir $input

done < $batch

