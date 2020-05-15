### This script creates a csv of dicoms 
### 
### Ellyn Butler
### December 17, 2018

subjlist=/home/ebutler/subjlists/nasa/nasa_DWI_dcm_dirs.csv

cat $subjlist | while read dicom_dir ; do
	files=`find ${dicom_dir}/ -name "*.dcm"`
	if [ "X${files}" == "X" ] ; then files=`find ${dicom_dir}/ -name "*.IMA"` ; fi
	files=( $files )
	onefile=`echo "${files[0]}"`
	echo ${onefile} >> /home/ebutler/subjlists/nasa/nasa_DWI_dcms.csv ; 
done
