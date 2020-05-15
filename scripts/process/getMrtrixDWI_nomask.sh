#!/bin/bash

dcmdirs=/home/ebutler/subjlists/nasa/nasa_DWI_dcm_dirs.csv

cat $dcmdirs | while read dcmdir; do
	winter=`echo $dcmdir | cut -d '/' -f 8`
	subj=`echo $dcmdir | cut -d '/' -f 9`
	time=`echo $dcmdir | cut -d '/' -f 10`

	outputdir=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}

	name="${subj}_${time}"
	/home/ebutler/scripts/NASA/process/mrtrix_diffusion_womask.sh ${dcmdir}
done

