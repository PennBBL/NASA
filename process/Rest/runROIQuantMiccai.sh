### This script runs a custom ROI quantification of reho and alff 
### for NASA Antarctica subjects... PROBABLY NOT DOABLE GIVEN DIMENSIONS OF IMAGES
###
### Ellyn Butler
### April 23, 2019

#!/bin/bash

export PATH=$PATH:/share/apps/singularity/2.5.1/bin

COHORTXCP=/data/jux/BBL/projects/nasa_antartica/xcpdocker/cohort/cohort_fMRIPrep2.csv # needs to be reho and alff paths
FULL_COHORT=$COHORTXCP
NJOBS=$(wc -l <  ${FULL_COHORT})
num=$(expr $NJOBS - 1);

SNGL=/share/apps/singularity/2.5.1/bin/singularity
SIMG=/data/joy/BBL/applications/bids_apps/xcpEngine.simg 
OUTPUT=/data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine

HEADER=$(head -n 1 ${FULL_COHORT})
bb=$(seq 1 $num)

for j in $bb; do
	l=$(expr $j + 1)
	LINE=$(awk "NR==$l" ${FULL_COHORT})
	id0=`echo $LINE | cut -d ',' -f 1`
	id1=`echo $LINE | cut -d ',' -f 2`
	name=`echo $LINE | cut -d ',' -f 1-2 | tr ',' '_'`

	#if [ ! -d "${OUTPUT}/${id0}/${id1}/roiquant/miccai/" ] ; then mkdir ${OUTPUT}/${id0}/${id1}/roiquant/miccai/ ; fi

	### Make image dimensions of reho and alff match that of FSL's MNI brain
	fslmni=/data/jux/BBL/projects/nasa_antartica/xcpdocker/MNIMiccai/mniJLFLabels.nii.gz
	rehoimg=${OUTPUT}/${id0}/${id1}/reho/${name}_reho.nii.gz
	alffimg=${OUTPUT}/${id0}/${id1}/alff/${name}_alff.nii.gz

	if [[ ! -n ${OUTPUT}/${id0}/${id1}/roiquant/miccai/${id0}_${id1}_miccai.nii.gz ]] ; then
		antsApplyTransforms -i ${fslmni} -r ${rehoimg} -o ${OUTPUT}/${id0}/${id1}/roiquant/miccai/${id0}_${id1}_miccai.nii.gz
	fi

	miccai=${OUTPUT}/${id0}/${id1}/roiquant/miccai/${id0}_${id1}_miccai.nii.gz

	### REHO
	echo ${SNGL} exec -B /data:/home/ebutler/data \ /data/joy/BBL/applications/bids_apps/xcpEngine.simg \ /xcpEngine/utils/quantifyAtlas \ -v /home/ebutler${rehoimg} \ -s mean \ -n miccai \ -p ${id0},${id1} \ -d reho \ -a /home/ebutler${miccai} \ -i /home/ebutler/data/jux/BBL/projects/nasa_antartica/miccaiIndices.txt \ -r /home/ebutler/data/jux/BBL/projects/nasa_antartica/miccaiNodeNames.txt \ -o /home/ebutler${OUTPUT}/${id0}/${id1}/roiquant/miccai/${id0}_${id1}_miccai_mean_reho.csv > /home/ebutler/xcpRehoAlffMiccai/${name}_reho.sh

	qsub /home/ebutler/xcpRehoAlffMiccai/${name}_reho.sh

	### ALFF
	echo ${SNGL} exec -B /data:/home/ebutler/data \ /data/joy/BBL/applications/bids_apps/xcpEngine.simg \ /xcpEngine/utils/quantifyAtlas \ -v /home/ebutler${alffimg} \ -s mean \ -n miccai \ -p ${id0},${id1} \ -d alff \ -a /home/ebutler${miccai} \ -i /home/ebutler/data/jux/BBL/projects/nasa_antartica/miccaiIndices.txt \ -r /home/ebutler/data/jux/BBL/projects/nasa_antartica/miccaiNodeNames.txt \ -o /home/ebutler${OUTPUT}/${id0}/${id1}/roiquant/miccai/${id0}_${id1}_miccai_mean_alff.csv > /home/ebutler/xcpRehoAlffMiccai/${name}_alff.sh

	qsub /home/ebutler/xcpRehoAlffMiccai/${name}_alff.sh
done

