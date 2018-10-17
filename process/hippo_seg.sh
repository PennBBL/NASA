#!/bin/bash

### This script runs the hippocampal subfield segmentation for the NASA subjects
### 
### Ellyn Butler
### October 1, 2018

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv
processed_dir=/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus

# max 143
for i in `seq 1 10`; do
	# ---identify the T1 image---
	T1_image=`sed "${i}q;d" $T1_subjects`

	# ---identify the T2 image---
	T2_image=`sed "${i}q;d" $T2_subjects`

	# ---make the output directory---
	winter=`echo $T1_image | cut -d '/' -f 8`
	subj=`echo $T1_image | cut -d '/' -f 9`
	time=`echo $T1_image | cut -d '/' -f 10`

	if [ ! -e $processed_dir/$winter/ ] ;
		mkdir $processed_dir/$winter/ ;
	if [ ! -e $processed_dir/$winter/$subj/ ] ; 
		mkdir $processed_dir/$winter/$subj/ ;
	if [ ! -e $processed_dir/$winter/$subj/$time/ ] ; 
		mkdir $processed_dir/$winter/$subj/$time/ ;
	fi	

	output_dir=$processed_dir/$winter/$subj/$time/ ; 

	# ---add images to workspace---
	/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -layers-set-main $T2_image -tags-add T2_MRI \ 
		-layers-add-anat $T1_image -tags-add T1-MRI \
		-layers-list -o $output_dir/hipp_seg

	# ---send workspace to cloud--- #ERB: Adapt for local machine
	#ERB: Find services manually... get number using "itksnap-wt -dss-services-list"... use Princeton Young Adult Atlas... figure out if the service code is stable over time
	service_code=`/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -dss-services-list | `
	/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -i $output_dir/hipp_seg -dss-tickets-create $service_code
	
done


# Questions...ish
# 1) Cannot run on cloud
# 2) How can I run this script from Chead and have the jobs submitted to my local machine? And have the output put back on Chead?

