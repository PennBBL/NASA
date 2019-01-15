#!/bin/bash

### This script converts dicoms to niftis with dcm2niix for the diffusion scans that
### were originally not converted this way as a way to get json files
###
### Ellyn Butler
### October 23, 2018

# For scans that follow this directory structure: 
#/data/jux/BBL/studies/nasa_antartica/rawData/wo_2015/*/*/*DTI*FoV240/Dicoms

subjlist=/home/ebutler/subjlists/nasa/subjlist_DWI_getjson1.csv

cat $subjlist | while read dicom_dir ; do
	echo $dicom_dir #
	dcm2niix $dicom_dir/*
	diffusion_dir="$(echo $dicom_dir | cut -d '/' -f 1-11)"
	mkdir $diffusion_dir/x_conversion_nifti
	mv $dicom_dir/Dicoms* $diffusion_dir/x_conversion_nifti
	gzip $diffusion_dir/x_conversion_nifti/*.nii
done
