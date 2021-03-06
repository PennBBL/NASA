### This script is designed to get total CSF (mm3) from the 
### three class segmentation created by Stathis for NASA
###
### Ellyn Butler
### March 22, 2019

echo "winterover,subject_1,Time,Third_Ventricle,Fourth_Ventricle,CSF,R_Inf_Lat_Vent,L_Inf_Lat_Vent,R_Lateral_Ventricle,L_Lateral_Ventricle,ventricles_csf" > /home/ebutler/erb_data/nasa/nasa_OASIScsfVentricles.csv

ventNiftis_list=`ls /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/*/*/t*/jlf/*LabelsGMIntersect.nii.gz`

# put in the rows
for nifti in ${ventNiftis_list}; do
	winterover="$(echo $nifti | cut -d '/' -f 10)" ;
	subject="$(echo $nifti | cut -d '/' -f 11)" ;
	Time="$(echo $nifti | cut -d '/' -f 12)" ;
	stats_output=`fslstats ${nifti} -H 208 0 207` ;
	# find the number of pixels in each region
	numpix_Third_Ventricle="$(echo $stats_output | cut -d ' ' -f 5)" ;
	numpix_Fourth_Ventricle="$(echo $stats_output | cut -d ' ' -f 12)" ;
	numpix_CSF="$(echo $stats_output | cut -d ' ' -f 47)" ;
	numpix_R_Inf_Lat_Vent="$(echo $stats_output | cut -d ' ' -f 50)" ;
	numpix_L_Inf_Lat_Vent="$(echo $stats_output | cut -d ' ' -f 51)" ;
	numpix_R_Lateral_Ventricle="$(echo $stats_output | cut -d ' ' -f 52)" ;
	numpix_L_Lateral_Ventricle="$(echo $stats_output | cut -d ' ' -f 53)" ;
	numpix_ventricles="$( echo "${numpix_Third_Ventricle} + ${numpix_Fourth_Ventricle} + ${numpix_CSF} + ${numpix_R_Inf_Lat_Vent} + ${numpix_L_Inf_Lat_Vent} + ${numpix_R_Lateral_Ventricle} + ${numpix_L_Lateral_Ventricle}" | bc -l)" ;
	# get the pixel dimensions
	info_output=`fslinfo ${nifti}` ;
	pixdim1="$(echo $info_output | cut -d ' ' -f 14)" ;
	pixdim2="$(echo $info_output | cut -d ' ' -f 16)" ;
	pixdim3="$(echo $info_output | cut -d ' ' -f 18)" ;
	pixdim_product="$( echo "${pixdim1} * ${pixdim2} * ${pixdim3}" | bc -l)" ; 
	# calculate the volumes
	Third_Ventricle="$( echo "${numpix_Third_Ventricle} * ${pixdim_product}" | bc -l)" ;
	Fourth_Ventricle="$( echo "${numpix_Fourth_Ventricle} * ${pixdim_product}" | bc -l)" ;
	CSF="$( echo "${numpix_CSF} * ${pixdim_product}" | bc -l)" ;
	R_Inf_Lat_Vent="$( echo "${numpix_R_Inf_Lat_Vent} * ${pixdim_product}" | bc -l)" ;
	L_Inf_Lat_Vent="$( echo "${numpix_L_Inf_Lat_Vent} * ${pixdim_product}" | bc -l)" ;
	R_Lateral_Ventricle="$( echo "${numpix_R_Lateral_Ventricle} * ${pixdim_product}" | bc -l)" ;
	L_Lateral_Ventricle="$( echo "${numpix_L_Lateral_Ventricle} * ${pixdim_product}" | bc -l)" ;
	ventricles_csf="$( echo "${numpix_ventricles} * ${pixdim_product}" | bc -l)" ;
	echo "$winterover,$subject,$Time,$Third_Ventricle,$Fourth_Ventricle,$CSF,$R_Inf_Lat_Vent,$L_Inf_Lat_Vent,$R_Lateral_Ventricle,$L_Lateral_Ventricle,$ventricles_csf" >> /home/ebutler/erb_data/nasa/nasa_OASIScsfVentricles.csv ;
done
