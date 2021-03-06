#!/bin/bash

### This script downloads the hippocampal subfield segmentation for the NASA subjects
### 
### Ellyn Butler
### October 22, 2018

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv
processed_dir=/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus

# max 146
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

output_dir=$processed_dir/$winter/$subj/$time/ ; 

#ticket_id=$((${i} + 1169)) # changes each run, potentially
ticket_id=$((1285))

# --- Download images ---
/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -dss-tickets-download ${ticket_id} ${output_dir}
	
#done
