#!/bin/bash -l

# generate list of error tiles
ls -l rclone_logs | awk '{if ($5 != 0) print $9}' | sed -e "s/_rclone.log//g" | sed '1d' > tiles_err

# for each tile, if there is a "IMPUTATOR" folder, loop through the top 5 tiles (ranked based on r2) in summary.csv, from the top r2 in decreasing order. Stop when find a match.

echo -e "Tile\tBest_model\tRank" > tiles_recovered.txt

while read tile_err; do

	tile_prefix=$(echo ${tile_err} | cut -d '/' -f2)

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
    echo "${tile_err}\t${best_trial}\t$i"
    echo -e "${tile_err}\t${best_trial}\t$i" >> /mnt/stsi/stsi6/Internal/INCITE/II_testing/tiles_recovered.txt
  fi


done < tiles_err
