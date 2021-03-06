#!/bin/bash

### This script find the bvals for NASA Antartica, identifies the number of 0's and the number of non 0's
### and puts all of this information into a csv.
###
### Ellyn Butler
### November 14, 2018

subjlist=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv

echo "winterover","subject_1","Time","num_B0","num_BOther" > /home/ebutler/erb_data/nasa/nasa_B0Other.csv

for scan in `cat $subjlist`; do
	winterover=`echo $scan | cut -d '/' -f 8`
	subject_1=`echo $scan | cut -d '/' -f 9`
	Time=`echo $scan | cut -d '/' -f 10`

	directory="$(dirname $scan)"
	bval=`find $directory/* -name "*bval"`
	echo $bval
	num_B0=`cat $bval | tr " " "\n" | sort | uniq -c | grep -w "0" | cut -d ' ' -f 7`
	num_BOther=`cat $bval | tr " " "\n" | sort | awk '$1>200{c++} END{print c+0}'`

	echo ${winterover},${subject_1},${Time},${num_B0},${num_BOther}>> /home/ebutler/erb_data/nasa/nasa_B0Other.csv
done
