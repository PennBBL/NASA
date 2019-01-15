#!/bin/bash

### This script finds the json files for T2 images
###
### Ellyn Butler
### October 31, 2018

subjlist='/home/ebutler/subjlists/nasa/subjlist_T2.csv'

cat $subjlist | while read T2_image ; do
	T2_dir="$(echo $T2_image | cut -d '/' -f 1-11)"
	
