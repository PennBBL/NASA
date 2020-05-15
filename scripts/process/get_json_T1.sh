#!/bin/bash

### This script finds the json files for T1 images
###
### Ellyn Butler
### October 31, 2018

subjlist='/home/ebutler/subjlists/nasa/subjlist_T1.csv'

cat $subjlist | while read T1_image ; do
	T1_dir="$(echo $T1_image | cut -d '/' -f 1-11)"
	json=`find ${T1_dir}/* -name "*.json"`
	echo $json
done
