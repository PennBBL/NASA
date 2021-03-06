#!/bin/bash

### This script runs the hippocampal subfield segmentation for the NASA subjects
### 
### Ellyn Butler
### October 19, 2018

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv
processed_dir=/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus

# max 144
#for i in `seq 1 146`; do
i=145

# ---identify the T1 image---
T1_image=`sed "${i}q;d" $T1_subjects`

# ---identify the T2 image---
T2_image=`sed "${i}q;d" $T2_subjects`

# ---make the output directory---
winter=`echo $T1_image | cut -d '/' -f 8`
subj=`echo $T1_image | cut -d '/' -f 9`
time=`echo $T1_image | cut -d '/' -f 10`

if [ ! -e $processed_dir/$winter/ ] ; then mkdir $processed_dir/$winter/ ; fi
if [ ! -e $processed_dir/$winter/$subj/ ] ; then mkdir $processed_dir/$winter/$subj/ ; fi
if [ ! -e $processed_dir/$winter/$subj/$time/ ] ; then mkdir $processed_dir/$winter/$subj/$time/ ; fi

# ---add images to workspace---
/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -layers-set-main $T2_image -tags-add T2-MRI -layers-add-anat $T1_image -tags-add T1-MRI -layers-list -o ${subj}_${time}.itksnap

# ---send workspace to cloud--- #ERB: Adapt for local machine
#ERB: Find services manually... get number using "itksnap-wt -dss-services-list"... use Princeton Young Adult Atlas... figure out if the service code is stable over time
service_code="ff2310615264f162966fe7d4ddc2e4dba409a35b" #Princeton Young Adult Atlas
/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -i ${subj}_${time}.itksnap -dss-tickets-create $service_code ;
	
#done

