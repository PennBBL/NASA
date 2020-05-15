### This script creates a csv of file name: 1) raw image, 2) brain segmentation, 3) cortical thickness
###
### Ellyn Butler
### February 21, 2019

rawpaths=/home/ebutler/subjlists/nasa/subjlist_T1_xconv.csv

for raw in $(cat $rawpaths | tr "\r" "\n"); do
	subj=`echo $raw | cut -d "/" -f 8-10`
	seg=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3/${subj}/struc/ -name "*BrainSegmentation.nii.gz"`
	cort=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3/${subj}/struc/ -name "*CorticalThickness.nii.gz"`
	echo $raw >> /home/ebutler/subjlists/nasa/T1_xconv_strucout.csv
	echo $seg >> /home/ebutler/subjlists/nasa/T1_xconv_strucout.csv
	echo $cort >> /home/ebutler/subjlists/nasa/T1_xconv_strucout.csv
done
