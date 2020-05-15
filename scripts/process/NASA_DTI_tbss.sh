### This script runs FSL's TBSS scripts on the MrTrix FA maps
### 
### Ellyn Butler
### December 19, 2018


faniftis=/home/ebutler/subjlists/nasa/nasa_FA.csv

# Copy niftis into TBSS directory
cat $faniftis | while read fanifti; do
	cp ${fanifti} /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/TBSS/
done

# Run tbss
cd /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/TBSS/
tbss_1_preproc *.nii.gz
tbss_2_reg -T
tbss_3_postreg -S 
tbss_4_prestats 0.15

# Split the output
fslsplit /data/joy/BBL/studies/nasa_antartica/processedData/diffusion/TBSS/stats/all_FA_skeletonised.nii.gz

# Get the ordering of subjects
cat $faniftis | while read fanifti; do
	subj=`echo $fanifti | cut -d '/' -f 10`
	time=`echo $fanifti | cut -d '/' -f 11`
	name="${subj}_${time}"
	echo ${name} >> /home/ebutler/subjlists/nasa/nasa_ids_alphabetized.csv
done

echo `sort /home/ebutler/subjlists/nasa/nasa_ids_alphabetized.csv` > /home/ebutler/subjlists/nasa/nasa_ids_alphabetized.csv

# convert the volumes 
alphaids=/home/ebutler/subjlists/nasa/nasa_ids_alphabetized.csv

i=0
cat $alphaids | while read alphaid ; do
	if [ ${i} -lt 10 ] ; then
		name=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/TBSS/stats/"vol000${i}.nii.gz" ; 
	elif [ ${i} -lt 100 ] ; then
		name=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/TBSS/stats/"vol00${i}.nii.gz" ; 
	elif [ ${i} -lt 1000 ] ; then
		name=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/TBSS/stats/"vol0${i}.nii.gz" ; 
	fi
	echo $name ; 
	i=$((${i} + 1)) ; 
	echo $i
done













