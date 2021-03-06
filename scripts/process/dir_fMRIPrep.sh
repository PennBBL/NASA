### This script makes the directories and copies the dicoms for NASA subjects in preparation
### for using fMRI prep
###
### Ellyn Butler
### April 9, 2019

# Resting BOLD dicoms
#dicomdirs=/home/ebutler/subjlists/nasa/nasa_restbold_dicoms.csv
#newrawdir=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep

#cat $dicomdirs | while read dicomdir ; do
#	subj="$(echo ${dicomdir} | cut -d '/' -f 9)"
#	time="$(echo ${dicomdir} | cut -d '/' -f 10)"
#	name="${subj}_${time}"
#	if [ ! -d "${newrawdir}/${name}" ] ; then mkdir ${newrawdir}/${name} ; fi
#	cp ${dicomdir}/* ${newrawdir}/${name}
#done

# Version with the correctly named directories from the get-go (April 29, 2019)

#dicomdirs=/home/ebutler/subjlists/nasa/nasa_restbold_dicoms.csv
dicomdirs=/home/ebutler/subjlists/nasa/nasa_restbold_dicoms_all.csv
toplvl=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep
dcmdir=${toplvl}/Dicom
namekey=/home/ebutler/erb_data/nasa/nasa_origTofMRIPrep_key.csv
newrawdir=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep

cat $dicomdirs | while read dicomdir ; do
	# Old naming
	subj="$(echo ${dicomdir} | cut -d '/' -f 9)"
	time="$(echo ${dicomdir} | cut -d '/' -f 10)"
	# BIDS naming
	subid=`grep "${subj}" ${namekey} | grep "${time}" | cut -d ',' -f 3 | tr -d '"'`
	sesid=`grep "${subj}" ${namekey} | grep "${time}" | cut -d ',' -f 4 | tr -d '"'`
	if [ ! -d "${newrawdir}/Dicom/${subid}" ] ; then mkdir ${newrawdir}/Dicom/${subid} ; fi
	if [ ! -d "${newrawdir}/Dicom/${subid}/${sesid}" ] ; then mkdir ${newrawdir}/Dicom/${subid}/${sesid} ; fi
	# Check to see if one of the dicoms from the previous dicom directory is in the BIDS one
	checkfile=`ls ${dicomdir} | sort -n | head -1`
	if [ ! -f ${newrawdir}/Dicom/${subid}/${sesid}/${checkfile} ] ; then cp ${dicomdir}/* ${newrawdir}/Dicom/${subid}/${sesid} ; fi
done
