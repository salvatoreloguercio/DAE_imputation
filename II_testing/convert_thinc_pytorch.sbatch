#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=stsi
#SBATCH --gpus=v100:1
#SBATCH --time=72:00:00
#SBATCH -J thinc2pth
#SBATCH -o thinc2pth.%J


module load pytorch/1.11.1py38-cuda

PYTHONPATH=$PYTHONPATH:/mnt/stsi/stsi6/Internal/INCITE/II_testing

echo $PYTHONPATH

script=/mnt/stsi/stsi6/Internal/INCITE/II_testing/genomeai/convert.py

while read model; do

tile=$(dirname $model)

cd $tile

echo $model | cut -d "/" -f 8-9

best=$( basename $model | sed -e "s/IMPUTATOR//g" )

#best=$(cat summary.csv | sort -k3g -t',' | tail -n 1 | cut -f 2 -d ',')
python $script IMPUTATOR${best} torch IMPUTATOR${best}/model_${best}


done < tiles_done_avail