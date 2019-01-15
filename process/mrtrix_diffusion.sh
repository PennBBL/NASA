#!/bin/bash


export PATH=/data/joy/BBL/applications/mrtrix3/bin:$PATH

dcmdir=${1}
#dcmdir=/data/jux/BBL/studies/nasa_antartica/rawData/wo_2016/concordia_104/t12/DTI_30+5_2mm_Isotropic/Dicoms

winter=`echo $dcmdir | cut -d '/' -f 8`
subj=`echo $dcmdir | cut -d '/' -f 9`
time=`echo $dcmdir | cut -d '/' -f 10`

outputdir=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}

if [ ! -d "/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}" ] ; then
	mkdir /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter} ;
fi
if [ ! -d "/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}" ] ; then 
	mkdir /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj} ;
fi
if [ ! -d "/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time}" ] ; then
	mkdir /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/${winter}/${subj}/${time} ;
fi

# Remove contents of outputdir
rm $outputdir/*.nii.gz
rm $outputdir/*.mif
rm $outputdir/*eddy*

name="${subj}_${time}"

dcm=`find $dcmdir/* -maxdepth 0 -name "*.dcm" -o -name "*.IMA" -quit | head -n 1`

pedir=`dicom_hdr $dcm | grep 'Phase Encoding Direction' | cut -d '/' -f 5 | tr " " "\n"`
	
# Create a key for different ways of referencing phase encoding direction (based off of Python dictionary)
if [[ "$pedir" == "COL" ]] ; then
	pedir_two="j-" ;
else
	pedir_two="j" ;
fi


mrconvert ${dcmdir} ${outputdir}/${name}_dwi.mif
dwidenoise ${outputdir}/${name}_dwi.mif ${outputdir}/${name}_dwid.mif -noise ${outputdir}/${name}_noise.mif
dwiextract ${outputdir}/${name}_dwid.mif - -bzero | mrmath - mean ${outputdir}/${name}_meanb0.nii.gz -axis 3
dwipreproc -pe_dir "${pedir_two}" -rpe_none -tempdir ${TMPDIR} -eddy_options " --slm=linear " -eddyqc_all ${outputdir} ${outputdir}/${name}_dwid.mif ${outputdir}/${name}_dwip.mif
dwi2mask ${outputdir}/${name}_dwip.mif ${outputdir}/${name}_dwimask.mif 
mrconvert ${outputdir}/${name}_dwip.mif ${outputdir}/${name}_dwip.nii.gz
dwi2tensor -mask ${outputdir}/${name}_dwimask.mif ${outputdir}/${name}_dwip.mif ${outputdir}/${name}_dti.nii.gz # Redone without mask January 8, 2019
tensor2metric -fa ${outputdir}/${name}_fa.nii.gz ${outputdir}/${name}_dti.nii.gz
tensor2metric -adc ${outputdir}/${name}_md.nii.gz ${outputdir}/${name}_dti.nii.gz


