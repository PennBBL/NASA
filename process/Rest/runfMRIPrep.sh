### This script runs fMRIPrep on NASA Antarctica T1w and BOLD data
###
### Ellyn Butler
### April 12, 2019

paths=`find /data/jux/BBL/studies/nasa_antartica/forfMRIPrep/Nifti/sub-*/ses-* -name "*T1w.nii"`

for path in $paths ; do
	sub=`echo $path | cut -d "/" -f 9 | cut -d "-" -f 2`
	ses=`echo $path | cut -d "/" -f 10 | cut -d "-" -f 2`
	processedDir=/data/joy/BBL/studies/nasa_antartica/processedData/fMRIPrep
	#if [ ! -d ${processedDir}/sub-${sub}/ ] ; then mkdir ${processedDir}/sub-${sub}/ ; fi
	#if [ ! -d ${processedDir}/sub-${sub}/ses-${ses} ] ; then mkdir ${processedDir}/sub-${sub}/ses-${ses} ; fi
	#echo /share/apps/singularity/2.5.1/bin/singularity run -B /data:/home/ebutler/data /data/joy/BBL/applications/bids_apps/fmriprep.simg --skip_bids_validation --output-space template --template MNI152NLin2009cAsym --skull-strip-template OASIS --fs-license-file /home/ebutler/data/joy/BBL/studies/ptsd/processedData/anatomical/freesurfer60/license.txt --participant_label sub-${sub} --session_label ses-${ses} /home/ebutler/data/jux/BBL/studies/nasa_antartica/forfMRIPrep/Nifti/ /home/ebutler${processedDir}/ participant > /home/ebutler/NASA_fMRIPrep_RestBOLD/sub-${sub}_ses-${ses}.sh 

	#if [ ! -f /home/ebutler/NASA_fMRIPrep_RestBOLD/sub-${sub}.sh ] ; then
	echo /share/apps/singularity/2.5.1/bin/singularity run -B /data:/home/ebutler/data /data/joy/BBL/applications/bids_apps/fmriprep.simg /home/ebutler/data/jux/BBL/studies/nasa_antartica/forfMRIPrep/Nifti/ /home/ebutler${processedDir}/ participant --participant-label ${sub} --fs-license-file /home/ebutler/data/joy/BBL/studies/ptsd/processedData/anatomical/freesurfer60/license.txt -w $TMP > /home/ebutler/NASA_fMRIPrep_RestBOLD/sub-${sub}.sh 

	#qsub  -q basic.q,all.q -l h_vmem=10.0G,s_vmem=10.0G /home/ebutler/NASA_fMRIPrep_RestBOLD/sub-${sub}.sh ; 
	#fi

done


