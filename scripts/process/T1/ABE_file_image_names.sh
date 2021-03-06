### This script creates a csv of file name: 1) raw image, 2) brain segmentation, 3) cortical thickness
###
### Ellyn Butler
### February 21, 2019

rawpaths=/home/ebutler/subjlists/nasa/subjlist_T1_xconv.csv

for raw in $(cat $rawpaths | tr "\r" "\n"); do
	subj=`echo $raw | cut -d "/" -f 8-10`
	mask=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/${subj}/struc/ -name "*BrainExtractionMask.nii.gz"`
	echo $raw >> /home/ebutler/subjlists/nasa/T1_xconv_ABEout.csv
	echo $mask >> /home/ebutler/subjlists/nasa/T1_xconv_ABEout.csv
done
