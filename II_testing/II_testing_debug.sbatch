#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=100G
#SBATCH --partition=highmem
#SBATCH --time=600:00:00
#SBATCH --job-name=II_testing
#SBATCH --output=%x.oe%j
#SBATCH --error=%x.oe%j


module load samtools

module load R

module load pytorch/1.9.0py38-cuda


#sbatch --export=mdir=chr22/22_17274081-17382360,input=input.cfg --job-name=2_validate_and_select_best 2_validate_and_select_best.sbatch


cd $SLURM_SUBMIT_DIR

inference_script=inference_function_dip_oh_pytorch.py


# VMV 

chr=$( basename $mdir | cut -f1 -d '_' )

region=$( basename $mdir | tr '_' '\t' | cut -f 2 )


VMVpath=$(find $(grep "^TRAIN_DIR" $cfg | tr -d ' ' | tr '=' ' ' | cut -f 2 -d ' ') | grep $region | grep "\.gz$")

(zcat $VMVpath || cat $VMVpath) | cut -f 1-5 | grep -v '#' > ${VMV}.1-5




pos=$2











python3 $inference_script $pos $ga_path $model_dir --model_name $model_name --output $out_path; bgzip -c $out_path > $out_path.gz; tabix -p vcf -f $out_path.gz; rm $out_path"
















#bash 2_validate_and_select_best.sh $mdir $input