#!/bin/bash

#dcmdirs=/home/ebutler/subjlists/nasa/nasa_DWI_dcm_dirs.csv
dcmdir=/data/jux/BBL/studies/nasa_antartica/rawData/phantoms/PK/t3/DTI30+52mmIsotropic_9/Dicoms

#cat $dcmdirs | while read dcmdir; do
	winter=`echo $dcmdir | cut -d '/' -f 8`
	subj=`echo $dcmdir | cut -d '/' -f 9`
	time=`echo $dcmdir | cut -d '/' -f 10`

	outputdir=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}

	name="${subj}_${time}"
	echo /home/ebutler/scripts/NASA/process/mrtrix_diffusion.sh ${dcmdir} > /home/ebutler/scripts/NASA/mrtrixDWI/${name}_DWI.sh 
	qsub -o ${outputdir}/ -e ${outputdir}/ /home/ebutler/scripts/NASA/mrtrixDWI/${name}_DWI.sh
#done


