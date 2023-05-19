#!/bin/bash -l

# bash script to check if the tile folders contain just one (best model). Loops through all completed tile folders and extracts model paths for all available models.

while read tile; do
   
if [ "$(ls ${tile} | grep IMPUTATOR | wc -l)" -gt 0 ]; then
  echo "/mnt/stsi/stsi6/Internal/INCITE/II_testing/$(ls -d ${tile}/IMPUTATOR*)" >> tiles_done_avail


#   if [ "$(ls -d ${tile}/IMPUTATOR* | wc -l)" -gt 1 ]; then
#   echo $tile
#   fi
fi
done < all_tiles_done

