### This script concatenates all images with the same dimensions into the same 4D nifti file.
### The images are of the following types: raw T1, brain segmentation, and cortical thickness.
###
### Ellyn Butler
### February 26, 2019

images=/home/ebutler/subjlists/nasa/T1_xconv_strucout.csv

for image in $(cat $images | tr "\r" "\n"); do
	
done
