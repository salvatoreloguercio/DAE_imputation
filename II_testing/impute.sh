#!/bin/bash -l

#bin=/mnt/stsi/stsi6/Internal/TOPmed/impute5_v1.1.5/impute5_1.1.5_static

bin=/gpfs/home/sfchen/bin/impute_v5/impute5


chr=$1

# $2 is array

in_d=$3

out_d=$4

ancestry=$5

study=$(echo $out_d | cut -f 7 -d / | cut -c 1-4)

map=/mnt/stsi/stsi5/raqueld/maps/shapeit4_map/chr$chr.b37.gmap.gz

refdir=/mnt/stsi/stsi6/Internal/TOPmed/TOPMed_chr22_VMV/unphased_impute5/chr${chr}


indir="${in_d}/${ancestry}/chr${chr}_$2_unphased"

outdir="${out_d}/${ancestry}/chr${chr}_$2_unphased_impute5"

[ ! -d $outdir ] && mkdir $outdir

cd $outdir

for i in $indir/*.masked.gz; do

    region=$(basename $i | sed -e 's/.*\.phased\.//g' | sed -e 's/.*\.dense\.//g' | sed -e "s/.*\.ancestry-.*\.chr${chr}\.//g" | sed -e 's/\.VMV1\..*//g' | sed -e 's/\.vcf//g')
    ref=$(find $refdir -name *.${region}.VMV1.vcf.gz)
    out=$(basename $i | sed -e 's/\.gz/\.imputed_impute.vcf.gz/g')
    cmd1="$bin --h $ref --g $i --o $outdir/$out --r $chr --m $map --b 1000; tabix -p vcf -f $outdir/$out"
    echo "$cmd1;"
done > $outdir/run_impute_unphased_chr${chr}_$2.sh
sbatch --export cmd=$outdir/run_impute_unphased_chr${chr}_$2.sh --job-name=impute_${study}_${ancestry}_$2 --output=impute_${study}_${ancestry}_$2.out /mnt/stsi/stsi6/Internal/TOPmed/preprocess.sbatch
