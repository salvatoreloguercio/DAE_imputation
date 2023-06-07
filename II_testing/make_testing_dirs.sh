#!/bin/bash -l

# MESA

echo "MESA"

mkdir -p MESA/VMV/hg19/validation


for ancestry in $(echo "AFR ALL AMR EAS EUR"); do 
  
  mkdir MESA/VMV/hg19/validation/$ancestry

done

# HGDP

echo "HGDP"

mkdir -p HGDP/VMV/hg19/validation

for ancestry in $(echo "AFR ALL AMR EAS EUR mixed"); do 

  mkdir HGDP/VMV/hg19/validation/$ancestry

done

# Wellderly

echo "Wellderly"

mkdir -p Wellderly/VMV/hg19/validation/EUR

