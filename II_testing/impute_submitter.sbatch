#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
##SBATCH --mem=64G
#SBATCH --partition=shared
#SBATCH --time=120:00:00


module load python/3.8.3
module load samtools



echo "workdir: $SLURM_SUBMIT_DIR"
cd $SLURM_SUBMIT_DIR

start=`date +%s`

# MESA

echo "MESA"

in_d=/mnt/stsi/stsi5/raqueld/MESA/VMV/hg19/validation
out_d=/mnt/stsi/stsi6/Internal/TOPmed/MESA/VMV/hg19/validation

for ancestry in $(echo "ALL AMR EAS EUR"); do # AFR already done

  for array in $(echo "AFFY6 AXIOM OMNI1M"); do

    for i in 22; do echo "bash impute.sh $i $array $in_d $out_d $ancestry"; bash impute.sh $i $array $in_d $out_d $ancestry; done

  done

done

# HGDP

echo "HGDP"

in_d=/mnt/stsi/stsi5/raqueld/HGDP/VMV/hg19/validation
out_d=/mnt/stsi/stsi6/Internal/TOPmed/HGDP/VMV/hg19/validation

for ancestry in $(echo "ALL AMR EAS EUR mixed"); do  # AFR already done

  for array in $(echo "AFFY6 AXIOM OMNI1M"); do

    for i in 22; do echo "bash impute.sh $i $array $in_d $out_d $ancestry"; bash impute.sh $i $array $in_d $out_d $ancestry; done

  done

done

# Wellderly

#echo "Wellderly"

#in_d=/mnt/stsi/stsi5/raqueld/wellderly/VMV/hg19/validation
#out_d=/mnt/stsi/stsi6/Internal/TOPmed/wellderly/VMV/hg19/validation

#for ancestry in $(echo "EUR"); do

#  for array in $(echo "AFFY6 AXIOM OMNI1M"); do

#    for i in 22; do echo "bash impute.sh $i $array $in_d $out_d $ancestry"; bash impute.sh $i $array $in_d $out_d $ancestry; done

#  done

#done



#for i in {1..21}; do echo -e "bash beagle.sh $i AFFY6; bash run_imputation_jobs_SLURM_${i}_AFFY6.sh"; done > parallel_beagle_AFFY6.sh; parallel -j 22 < parallel_beagle_AFFY6.sh
#for i in {1..21}; do echo -e "bash beagle.sh $i AXIOM; bash run_imputation_jobs_SLURM_${i}_AXIOM.sh"; done > parallel_beagle_AXIOM.sh; parallel -j 22 < parallel_beagle_AXIOM.sh
#for i in {1..21}; do echo -e "bash beagle.sh $i OMNI5M; bash run_imputation_jobs_SLURM_${i}_OMNI5M.sh"; done > parallel_beagle_OMNI5M.sh; parallel -j 22 < parallel_beagle_OMNI5M.sh
#for i in {1..21}; do echo -e "bash beagle.sh $i OMNI2M; bash run_imputation_jobs_SLURM_${i}_OMNI2M.sh"; done > parallel_beagle_OMNI2M.sh; parallel -j 22 < parallel_beagle_OMNI2M.sh

    end=`date +%s`

    runtime=$((end-start))

    echo "Total runtime using 16 cores, 32GB RAM: ${runtime}"

