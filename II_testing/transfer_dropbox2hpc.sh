#!/bin/bash -l

while read tile; do

    echo ${tile}

    cd /mnt/stsi/stsi6/Internal/INCITE/II_testing/${tile}

    tile_prefix=$(echo ${tile} | cut -d '/' -f2)

    best=$(cat summary.csv | sort -k3g -t',' | tail -n 1 | cut -f 2 -d ',')

   rclone copy dropbox:Torkamani_Lab/archive/INCITE/${tile}/IMPUTATOR${best} IMPUTATOR${best} --transfers 5 --dropbox-chunk-size 128M --log-file=/mnt/stsi/stsi6/Internal/INCITE/II_testing/rclone_logs/${tile_prefix}_rclone.log

done < all_tiles_done

# default is transfers=4 and dropbox-chunk-size 64M


# generate list of error tiles
ls -l rclone_logs | awk '{if ($5 != 0) print $9}' | sed -e "s/_rclone.log//g" | sed '1d' > tiles_err

# for each tile, if there is a "IMPUTATOR" folder, loop through the top 5 tiles (ranked based on r2) in summary.csv, from the top r2 in decreasing order. Stop when find a match.

echo -e "Tile\tBest_model\tRank" > /mnt/stsi/stsi6/Internal/INCITE/II_testing/tiles_recovered.txt

while read tile_err; do
    echo $tile_err
	chr=$(echo $tile_err | cut -d '_' -f1)
  
  imp=$(rclone lsf dropbox:Torkamani_Lab/archive/INCITE/chr${chr}/${tile_err} | grep "IMPUTATOR")
  
  i=1
  if [ ! -z "$imp" ]; then 

    while [ $i -le 6 ] ; do
       echo $i
       best_trial=$(cat /mnt/stsi/stsi6/Internal/INCITE/II_testing/chr$chr/$tile_err/summary.csv | sort -k3g -t',' | tail -n $i | head -1 | cut -f 2 -d ',')
       if (echo $imp | grep -wq "IMPUTATOR${best_trial}") ; then break ; fi
       i=$((i+1))
         
    done
    cd /mnt/stsi/stsi6/Internal/INCITE/II_testing/chr$chr/$tile_err
    rclone copy dropbox:Torkamani_Lab/archive/INCITE/chr${chr}/${tile_err}/IMPUTATOR${best_trial} IMPUTATOR${best_trial} --transfers 5 --dropbox-chunk-size 128M --log-file=/mnt/stsi/stsi6/Internal/INCITE/II_testing/rclone_logs_recov/${tile_prefix}_rclone.log
    echo -e "${tile_err}\t${best_trial}\t$i" >> /mnt/stsi/stsi6/Internal/INCITE/II_testing/tiles_recovered.txt
  fi


done < tiles_err

#echo -e "TILE\t\