#!/bin/bash -l

while read tile; do

    echo ${tile}

    cd /mnt/stsi/stsi6/Internal/INCITE/II_testing/${tile}

    tile_prefix=$(echo ${tile} | cut -d '/' -f2)

    best=$(cat summary.csv | sort -k3g -t',' | tail -n 1 | cut -f 2 -d ',')

   rclone copy dropbox:Torkamani_Lab/archive/INCITE/${tile}/IMPUTATOR${best} . --transfers 2 --dropbox-chunk-size 128Mi --log-file=/mnt/stsi/stsi6/Internal/INCITE/II_testing/rclone_logs/${tile_prefix}_rclone.log

done < all_tiles_done