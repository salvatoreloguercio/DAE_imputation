#!/bin/bash -l

while read tile; do

    echo ${tile}

    cd /mnt/stsi/stsi6/Internal/INCITE/II_testing/${tile}

    tile_prefix=$(echo ${tile} | cut -d '/' -f2)

    

   rclone copy dropbox:Torkamani_Lab/archive/INCITE/${tile}/IMPUTATOR${best} IMPUTATOR${best} --transfers 5 --dropbox-chunk-size 128M --log-file=/mnt/stsi/stsi6/Internal/INCITE/II_testing/rclone_logs/${tile_prefix}_rclone.log

done < $1

# default is transfers=4 and dropbox-chunk-size 64M

