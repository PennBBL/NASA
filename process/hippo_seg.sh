#!/bin/bash

### This script runs the hippocampal subfield segmentation for the NASA subjects
### 
### Ellyn Butler
### October 1, 2018

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv

for i in `seq 1 143`;
	# ---identify the T1 image---
	T1_image=`sed "${i}q;d" $T1_subjects` ;

	# ---identify the T2 image---
	T2_image=`sed "${i}q;d" $T2_subjects` ;

	# ---make the output directory---
	winter=`echo $T1_image | cut -d '/' -f 8` ;
	subj=`echo $T1_image | cut -d '/' -f 9` ; 
	time=`echo $T1_image | cut -d '/' -f 10` ;
	processed_dir=/data/jux/BBL/studies/nasa_antartica/processedData/hippocampus
	if [ ! -e $processed_dir/$winter/ ] ; 
		mkdir $processed_dir/$winter/ ;
	fi
	if [ ! -e $processed_dir/$winter/$subj/ ] ; 
		mkdir $processed_dir/$winter/$subj/ ;
	fi
	if [ ! -e $processed_dir/$winter/$subj/$time/ ] ; 
		mkdir $processed_dir/$winter/$subj/$time/ ;
	fi	

	output_dir=$processed_dir/$winter/$subj/$time/ ; 

	# ---add images to workspace---
	itksnap-wt -layers-set-main $T2_image -tags-add T2_MRI \ 
		-laters-add-anat $T1_image -tags-add T1-MRI \
		-layers-list -o $output_dir/hipp_seg

	# ---send workspace to cloud---
	#ERB: Find services manually... get number using "itksnap-wt -dss-services-list"... use Princeton Young Adult Atlas... figure out if the service code is stable over time
	service_code=`itksnap-wt -dss-services-list | `
	/data/picsl/pauly/bin/itksnap-wt -i $output_dir/hipp_seg -dss-tickets-create $service_code
	
done


# Questions...ish
# 1) May not be able to use the cloud version, given the number of jobs
# 2) On own computer?... On CHEAD... how change command? Should probably use qsub
# 3) Why do I have to download the result?
