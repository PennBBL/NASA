### This script is designed to get total CSF (mm3) from the 
### three class segmentation created by Stathis for NASA
###
### Ellyn Butler
### September 5, 2018 - present

echo "subject,Time,total_csf" > /home/ebutler/data/nasa/nasa_csf.csv

segNiftis_list=`ls /data/jux/BBL/studies/nasa/processedData/structural/xcpAccel/concordia_*/t*/gmd/*segmentation3class.nii.gz`

# put in the rows
for nifti in ${segNiftis_list}; do
	subject="$(echo $nifti | cut -d '/' -f 10)" ;
	Time="$(echo $nifti | cut -d '/' -f 11)" ;
	stats_output=`fslstats ${nifti} -H 4 0 3` ;
	numpix="$(echo $stats_output | cut -d ' ' -f 2)" ;
	info_output=`fslinfo ${nifti}` ;
	pixdim1="$(echo $info_output | cut -d ' ' -f 14)" ;
	pixdim2="$(echo $info_output | cut -d ' ' -f 16)" ;
	pixdim3="$(echo $info_output | cut -d ' ' -f 18)" ;
	total_csf="$( echo "${numpix} * ${pixdim1} * ${pixdim2} * ${pixdim3}" | bc -l)" ;
	echo "$subject,$Time,$total_csf" >> /home/ebutler/data/nasa/nasa_csf.csv ;
done
