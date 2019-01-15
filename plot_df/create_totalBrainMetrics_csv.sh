### This script creates a csv of total brain metrics (should be in plot_df)
### 
### Ellyn Butler
### December 18, 2018


# xcp csv
subjects=`ls /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF/*/*/*/struc/*_brainvols.csv`

echo "winterover","subject_1","Time","BVOL","GVol","WVol" > /home/ebutler/erb_data/nasa/nasa_totalBrainMetrics.csv

for subject in $subjects ; do
	winterover=`echo $subject | cut -d '/' -f 10`
	subject_1=`echo $subject | cut -d '/' -f 11`
	Time=`echo $subject | cut -d '/' -f 12`

	BVOL=`sed '2q;d' $subject | cut -d ',' -f 2`
	GVol=`sed '2q;d' $subject | cut -d ',' -f 3`
	WVol=`sed '2q;d' $subject | cut -d ',' -f 4`

	echo ${winterover},${subject_1},${Time},${BVOL},${GVol},${WVol} >> /home/ebutler/erb_data/nasa/nasa_totalBrainMetrics.csv
done

# calculated from image

niftis=`ls /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF/*/*/*/roiquant/miccai/*_miccai.nii.gz`

echo "winterover","subject_1","Time","R_Cerebral_White_Matter","L_Cerebral_White_Matter" > /home/ebutler/erb_data/nasa/nasa_WhiteMatterVolume.csv

# separate lines
for nifti in $niftis ; do
	winterover="$(echo $nifti | cut -d '/' -f 10)" ;
	subject="$(echo $nifti | cut -d '/' -f 11)" ;
	Time="$(echo $nifti | cut -d '/' -f 12)" ;
	stats_output=`fslstats ${nifti} -H 208 0 207` ;
	# find the number of pixels in each region
	numpix_R_Cerebral_White_Matter="$(echo $stats_output | cut -d ' ' -f 45)" ; #add 1
	numpix_L_Cerebral_White_Matter="$(echo $stats_output | cut -d ' ' -f 46)" ; #add 1
	# get the pixel dimensions
	info_output=`fslinfo ${nifti}` ;
	pixdim1="$(echo $info_output | cut -d ' ' -f 14)" ;
	pixdim2="$(echo $info_output | cut -d ' ' -f 16)" ;
	pixdim3="$(echo $info_output | cut -d ' ' -f 18)" ;
	pixdim_product="$( echo "${pixdim1} * ${pixdim2} * ${pixdim3}" | bc -l)" ; 
	# calculate the volumes
	R_Cerebral_White_Matter="$( echo "${numpix_R_Cerebral_White_Matter} * ${pixdim_product}" | bc -l)" ;
	L_Cerebral_White_Matter="$( echo "${numpix_L_Cerebral_White_Matter} * ${pixdim_product}" | bc -l)" ;

	echo ${winterover},${subject},${Time},${R_Cerebral_White_Matter},${L_Cerebral_White_Matter} >> /home/ebutler/erb_data/nasa/nasa_WhiteMatterVolume.csv
done



# all on one line
for nifti in $niftis ; do winterover="$(echo $nifti | cut -d '/' -f 10)" ; subject="$(echo $nifti | cut -d '/' -f 11)" ; Time="$(echo $nifti | cut -d '/' -f 12)" ; stats_output=`fslstats ${nifti} -H 208 0 207` ; numpix_R_Cerebral_White_Matter="$(echo $stats_output | cut -d ' ' -f 45)" ;  numpix_L_Cerebral_White_Matter="$(echo $stats_output | cut -d ' ' -f 46)" ;  info_output=`fslinfo ${nifti}` ; pixdim1="$(echo $info_output | cut -d ' ' -f 14)" ; pixdim2="$(echo $info_output | cut -d ' ' -f 16)" ; pixdim3="$(echo $info_output | cut -d ' ' -f 18)" ; pixdim_product="$( echo "${pixdim1} * ${pixdim2} * ${pixdim3}" | bc -l)" ;  R_Cerebral_White_Matter="$( echo "${numpix_R_Cerebral_White_Matter} * ${pixdim_product}" | bc -l)" ; L_Cerebral_White_Matter="$( echo "${numpix_L_Cerebral_White_Matter} * ${pixdim_product}" | bc -l)" ; echo ${winterover},${subject},${Time},${R_Cerebral_White_Matter},${L_Cerebral_White_Matter} >> /home/ebutler/erb_data/nasa/nasa_WhiteMatterVolume.csv ; done




