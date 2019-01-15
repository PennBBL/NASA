#!/bin/bash


export PATH=/data/joy/BBL/applications/mrtrix3/bin:$PATH

dcmdir=${1}


winter=`echo $dcmdir | cut -d '/' -f 8`
subj=`echo $dcmdir | cut -d '/' -f 9`
time=`echo $dcmdir | cut -d '/' -f 10`

name="${subj}_${time}"

outputdir=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}

dwi2tensor ${outputdir}/${name}_dwip.mif ${outputdir}/${name}_dti_nomask.nii.gz
tensor2metric -fa ${outputdir}/${name}_fa_nomask.nii.gz ${outputdir}/${name}_dti.nii.gz
tensor2metric -adc ${outputdir}/${name}_md_nomask.nii.gz ${outputdir}/${name}_dti.nii.gz
