### This script unlinks niftis, bvecs and bvals in the raw DTI nifti directories
###
### Ellyn Butler
### December 12, 2018

subjects=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv

cat $subjects | while read line ; do
	base_dir="$(echo $line | cut -d '/' -f 1-12)"
	winter="$(echo $base_dir | cut -d '/' -f 8)"
	subject="$(echo $base_dir | cut -d '/' -f 9)"
	time="$(echo $base_dir | cut -d '/' -f 10)"
	nifti=`find ${base_dir}/ -name "*.nii.gz" | cut -d '/' -f 13`
	bvec=`find ${base_dir}/ -name "*.bvec" | cut -d '/' -f 13`
	bval=`find ${base_dir}/ -name "*.bval" | cut -d '/' -f 13`
	# find and unlink
	dicomDump_nifti=`find /data/jux/BBL/studies/nasa_antartica/rawData/${winter}/${subject}/${time}/dicomDump/ -name ${nifti}`
	unlink ${dicomDump_nifti}
	dicomDump_bvec=`find /data/jux/BBL/studies/nasa_antartica/rawData/${winter}/${subject}/${time}/dicomDump/ -name ${bvec}`
	unlink ${dicomDump_bvec}
	dicomDump_bval=`find /data/jux/BBL/studies/nasa_antartica/rawData/${winter}/${subject}/${time}/dicomDump/ -name ${bval}`
	unlink ${dicomDump_bval}
done
