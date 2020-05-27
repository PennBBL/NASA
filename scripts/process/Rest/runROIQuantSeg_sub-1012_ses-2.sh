### This script quantifies reho and alff for sub-1012 at ses-2 using the 3-class segmentation
### due to an unknown failure in the pipeline
###
### Ellyn Butler
### May 31, 2019

#!/bin/bash

export PATH=$PATH:/share/apps/singularity/2.5.1/bin


SNGL=/share/apps/singularity/2.5.1/bin/singularity
SIMG=/data/joy/BBL/applications/bids_apps/xcpEngine.simg 
OUTPUT=/data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine

id0=sub-1012
id1=ses-2

if [ ! -d "${OUTPUT}/${id0}/${id1}/roiquant/segmentation/" ] ; then mkdir ${OUTPUT}/${id0}/${id1}/roiquant/segmentation/ ; fi


if [ ! -f "${OUTPUT}/${id0}/${id1}/roiquant/segmentation/${id0}_${id1}_segmentation.nii.gz" ] ; then 
	cp ${OUTPUT}/${id0}/${id1}/prestats/${id0}_${id1}_segmentation.nii.gz ${OUTPUT}/${id0}/${id1}/roiquant/segmentation/ ; 
fi

seg=${OUTPUT}/${id0}/${id1}/roiquant/segmentation/${id0}_${id1}_segmentation.nii.gz

rehoimg=${OUTPUT}/${id0}/${id1}/reho/${id0}_${id1}_reho.nii.gz
alffimg=${OUTPUT}/${id0}/${id1}/alff/${id0}_${id1}_alff.nii.gz

# REHO
echo ${SNGL} exec -B /data:/home/ebutler/data \ /data/joy/BBL/applications/bids_apps/xcpEngine.simg \ /xcpEngine/utils/quantifyAtlas \ -v /home/ebutler${rehoimg} \ -s mean \ -n segmentation \ -p ${id0},${id1} \ -d reho \ -a /home/ebutler${seg} \ -i /home/ebutler/data/jux/BBL/projects/nasa_antartica/segmentation3NodeIndex.1D \ -r /home/ebutler/data/jux/BBL/projects/nasa_antartica/segmentation3NodeNames.txt \ -o /home/ebutler${OUTPUT}/${id0}/${id1}/roiquant/segmentation/${id0}_${id1}_segmentation_mean_reho.csv > ${OUTPUT}/${id0}/${id1}/segreho.sh

# ALFF
echo ${SNGL} exec -B /data:/home/ebutler/data \ /data/joy/BBL/applications/bids_apps/xcpEngine.simg \ /xcpEngine/utils/quantifyAtlas \ -v /home/ebutler${alffimg} \ -s mean \ -n segmentation \ -p ${id0},${id1} \ -d alff \ -a /home/ebutler${seg} \ -i /home/ebutler/data/jux/BBL/projects/nasa_antartica/segmentation3NodeIndex.1D \ -r /home/ebutler/data/jux/BBL/projects/nasa_antartica/segmentation3NodeNames.txt \ -o /home/ebutler${OUTPUT}/${id0}/${id1}/roiquant/segmentation/${id0}_${id1}_segmentation_mean_alff.csv > ${OUTPUT}/${id0}/${id1}/segalff.sh








