#!/bin/bash

### This script finds the json files for resting BOLD images
###
### Ellyn Butler
### April 9, 2019

subjlist='/home/ebutler/subjlists/nasa/nasa_restbold_124.csv'

cat $subjlist | while read rest_image ; do
	rest_dir="$(echo $rest_image | cut -d '/' -f 1-11)"
	json=`find ${rest_dir}/x_conversion_nifti/* -name "*.json"`
	echo $json >> /home/ebutler/subjlists/nasa/nasa_restbold_jsons.csv
done
