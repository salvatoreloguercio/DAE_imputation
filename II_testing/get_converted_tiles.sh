#!/bin/bash -l

# count converted tiles and grab nvar for each

for i in {1..22}; do

	for tile in chr$i/*; do
        echo $tile
        if [ -e $tile/IMPUTATOR*/*.pth ]
        	then
        		echo $tile >> tiles_converted.txt
	         paste -d '\t' <(echo $tile) <(grep -r nvar $tile/tile.yaml | cut -d : -f 2 | tr -d " ") >> tiles_converted_nvar.txt   
        fi
	done
done



