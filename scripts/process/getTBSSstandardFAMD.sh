#!/bin/bash

faniftis=/home/ebutler/subjlists/nasa/nasa_FA.csv


#cat $faniftis | while read fanifti; do

fanifti=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/phantoms/BJ/t1/BJ_t1_fa.nii.gz

	winter=`echo $fanifti | cut -d '/' -f 8`
	subj=`echo $fanifti | cut -d '/' -f 9`
	time=`echo $fanifti | cut -d '/' -f 10`

	outputdir=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}/FA_ROIs/
	if [ ! -d "${outputdir}" ] ; then
		mkdir /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}/FA_ROIs/ ;
	fi
	cp ${fanifti} ${outputdir}

	fanifti_two=${outputdir}/*FA.nii.gz

	name="${subj}_${time}"

	echo /home/ebutler/scripts/NASA/process/NASA_DTI_tbss.sh ${fanifti_two} > /home/ebutler/scripts/NASA/TBSS/${name}_DWItbss.sh 

	qsub -o ${outputdir}/ -e ${outputdir}/ /home/ebutler/scripts/NASA/TBSS/${name}_DWItbss.sh ${fanifti_two}
#done
