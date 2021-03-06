### This script puts resting and T1-weighted images into BIDS format, as described by
### http://reproducibility.stanford.edu/bids-tutorial-series-part-1b/
###
### Ellyn Butler
### April 10, 2019

set -e

#usedcm2niix # required if running on Ellyn's account
export LD_LIBRARY_PATH=:/opt/python/lib:/share/apps/VoxBo/bin/lib32:/data/joy/BBL/applications/glibc-2.14/lib

#### Define pathways
toplvl=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep
dcmdir=${toplvl}/Dicom
niidir=${toplvl}/Nifti
dcm2niidir=/data/joy/BBL/applications/mricrogl_lx

#### Create dataset_description.json
/data/joy/BBL/applications/jo/bin/jo "Name"="NASA Antarctica Resting BOLD" "BIDSVersion"="1.1.1" > ${niidir}/dataset_description.json


while read -r line; do 
	subj=$(echo $line | awk -F',' '{printf "%s", $3}' | tr -d '"') ; 
	ses=$(echo $line | awk -F',' '{printf "%s", $4}' | tr -d '"') ; 

	if [ ${subj} != "sub_id" ] ; then	
		#### Anatomical Organization ####
		echo "Processing subject ${subj} ${ses}"

		#### Create structure
		if [ ! -f ${niidir}/${subj}/${ses}/*.nii ] ; then 
			if [ ! -d ${niidir}/${subj}/${ses}/anat ] ; then 
				if [ ! -d ${dcmdir}/${subj}/${ses}/anat ] ; then 
					${dcm2niidir}/dcm2niix -o ${niidir}/${subj}/${ses} -f ${subj}_${ses}_%p ${dcmdir}/${subj}/${ses} ; 
				else 
					${dcm2niidir}/dcm2niix -o ${niidir}/${subj}/${ses} -f ${subj}_${ses}_%p ${dcmdir}/${subj}/${ses}/anat ; 
					${dcm2niidir}/dcm2niix -o ${niidir}/${subj}/${ses} -f ${subj}_${ses}_%p ${dcmdir}/${subj}/${ses}/func ; 
				fi ;
			fi ;
		fi

		#### Rename anat scans
		# MPRAGE
		if [ -e ${niidir}/${subj}/${ses}/${subj}_${ses}_*MPRAGE*.json ] ; then 
			if [ ! -d ${niidir}/${subj}/${ses}/anat ] ; then mkdir ${niidir}/${subj}/${ses}/anat ; fi ; 
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*MPRAGE*.json ${niidir}/${subj}/${ses}/anat/${subj}_${ses}_T1w.json ; 
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*MPRAGE*.nii ${niidir}/${subj}/${ses}/anat/${subj}_${ses}_T1w.nii ;
		fi
		# BRAVO
		if [ -e ${niidir}/${subj}/${ses}/${subj}_${ses}_*BRAVO*.json ] ; then 
			if [ ! -d ${niidir}/${subj}/${ses}/anat ] ; then mkdir ${niidir}/${subj}/${ses}/anat ; fi ;
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*BRAVO*.json ${niidir}/${subj}/${ses}/anat/${subj}_${ses}_T1w.json ; 
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*BRAVO*.nii ${niidir}/${subj}/${ses}/anat/${subj}_${ses}_T1w.nii ;
		fi

		#### Rename resting bold scans
		if [ -e ${niidir}/${subj}/${ses}/${subj}_${ses}_*Rest*.json ] ; then 
			if [ ! -d ${niidir}/${subj}/${ses}/func ] ; then mkdir ${niidir}/${subj}/${ses}/func ; fi ; 
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*Rest*.json ${niidir}/${subj}/${ses}/func/${subj}_${ses}_task-rest_bold.json ;
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*Rest*.nii ${niidir}/${subj}/${ses}/func/${subj}_${ses}_task-rest_bold.nii ;
		fi
		if [ -e ${niidir}/${subj}/${ses}/${subj}_${ses}_*REST*.json ] ; then 
			if [ ! -d ${niidir}/${subj}/${ses}/func ] ; then mkdir ${niidir}/${subj}/${ses}/func ; fi ; 
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*REST*.json ${niidir}/${subj}/${ses}/func/${subj}_${ses}_task-rest_bold.json ;
			mv ${niidir}/${subj}/${ses}/${subj}_${ses}_*REST*.nii ${niidir}/${subj}/${ses}/func/${subj}_${ses}_task-rest_bold.nii ;
		fi
	fi
done < /home/ebutler/erb_data/nasa/nasa_origTofMRIPrep_key.csv





