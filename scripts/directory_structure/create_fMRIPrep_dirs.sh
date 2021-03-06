### This script creates the necessary directory structure to run /home/ebutler/scripts/NASA/process/Rest/bids_format.sh
###
### Ellyn Butler
### April 11, 2019

dicomdir=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep/Dicom
niftidir=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep/Nifti

# Make BIDS-style directories
while read -r line; do
	col1=$(echo $line | awk -F',' '{printf "%s", $1}' | tr -d '"') ; 
	col2=$(echo $line | awk -F',' '{printf "%s", $2}' | tr -d '"') ; 
	col3=$(echo $line | awk -F',' '{printf "%s", $3}' | tr -d '"') ; 
	col4=$(echo $line | awk -F',' '{printf "%s", $4}' | tr -d '"') ; 

	if [ "${col1}" != "subject_1" ] ; then 
		# Make directories in Dicom 
		if [ ! -d ${dicomdir}/${col3} ] ; then 
			mkdir ${dicomdir}/${col3} ; 
		fi
		if [ ! -d ${dicomdir}/${col3}/${col4} ] ; then
			mkdir ${dicomdir}/${col3}/${col4} ; 
		fi
		# Make directories in Nifti
		if [ ! -d ${niftidir}/${col3} ] ; then 
			mkdir ${niftidir}/${col3} ; 
		fi
		if [ ! -d ${niftidir}/${col3}/${col4} ] ; then
			mkdir ${niftidir}/${col3}/${col4} ; 
		fi

	fi
done < /home/ebutler/erb_data/nasa/nasa_origTofMRIPrep_key.csv

# Move dicoms
while read -r line; do
	if [ "${col1}" != "subject_1" ] ; then 
		col1=$(echo $line | awk -F',' '{printf "%s", $1}' | tr -d '"') ; 
		col2=$(echo $line | awk -F',' '{printf "%s", $2}' | tr -d '"') ; 
		col3=$(echo $line | awk -F',' '{printf "%s", $3}' | tr -d '"') ; 
		col4=$(echo $line | awk -F',' '{printf "%s", $4}' | tr -d '"') ; 
	
		olddirname="${col1}_${col2}" ; 
		mv ${dicomdir}/${olddirname}/* ${dicomdir}/${col3}/${col4} ;
	fi
done < /home/ebutler/erb_data/nasa/nasa_origTofMRIPrep_key.csv
