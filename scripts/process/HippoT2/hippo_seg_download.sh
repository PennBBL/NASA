#!/bin/bash

### This script downloads the hippocampal subfield segmentation for the NASA subjects
### 
### Ellyn Butler
### October 22, 2018

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv
processed_dir=/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus

# max 146
for i in `seq 1 146`; do

# ---identify the T1 image---
T1_image=`sed "${i}q;d" $T1_subjects`
#T1_image=/data/jux/BBL/studies/nasa_antartica/rawData/phantoms/BM/t4/MPRAGE_TI1100_P2_0002/x_conversion_nifti/BM_t4_T1.nii.gz

# ---identify the T2 image---
T2_image=`sed "${i}q;d" $T2_subjects`
#T2_image=/data/jux/BBL/studies/nasa_antartica/rawData/phantoms/BM/t4/HIGHRESHIPPO-FOV150TR8020_VIA_DCM_31SL_0016/__HighResHippo-fov150tr8020_via_DCM_31sl_20170530144947_16.nii

# ---make the output directory---
winter=`echo $T1_image | cut -d '/' -f 8`
subj=`echo $T1_image | cut -d '/' -f 9`
time=`echo $T1_image | cut -d '/' -f 10`

output_dir=${processed_dir}/${winter}/${subj}/${time}/ ; 
#output_dir=${processed_dir}/${winter}/${subj}/${time}.2/ ; 

ticket_id=$((${i} + 1169)) # changes each run, potentially
#ticket_id=$((1976))

# --- Download images ---
/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -dss-tickets-download ${ticket_id} ${output_dir}
	
done
