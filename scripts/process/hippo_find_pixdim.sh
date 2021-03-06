#!/bin/bash

### This script finds the pixel dimensions for all of the jlfcllite (layer 3) 
### hippocampal subfield segmentation images and creates a csv of these values
###
### Ellyn Butler
### November 13, 2018

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv

processed_dir=/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus

echo "winterover","subject_1","Time","pixdim1","pixdim2","pixdim3" > /home/ebutler/erb_data/nasa/nasa_pixdim_hippo.csv 

for i in `seq 1 146`; do

	# --- identify the T1 image ---
	T1_image=`sed "${i}q;d" $T1_subjects`

	# --- find subject info ---
	winterover=`echo $T1_image | cut -d '/' -f 8`
	subject_1=`echo $T1_image | cut -d '/' -f 9`
	Time=`echo $T1_image | cut -d '/' -f 10`

	output_dir=$processed_dir/$winterover/$subject_1/$Time ; 

	# --- find pixel dimensions --- 
	layer_three=`fslinfo ${output_dir}/layer_003*` ;

	pixdim1="$(echo $layer_three | cut -d ' ' -f 14)" ;
	pixdim2="$(echo $layer_three | cut -d ' ' -f 16)" ;
	pixdim3="$(echo $layer_three | cut -d ' ' -f 18)" ;

	echo "$winterover,$subject_1,$Time,$pixdim1,$pixdim2,$pixdim3" >> /home/ebutler/erb_data/nasa/nasa_pixdim_hippo.csv ;
done

