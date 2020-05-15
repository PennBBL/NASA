#!/bin/bash

# This script was used on September 19, 2018 to edit the directory structure for the NASA-Antartica control subjects such 
# that it conformed to the structure necessary for the DTI pipeline and process scripts (/data/jux/BBL/projects/nasa/dti/nasa)

subjlist=/data/jux/BBL/projects/nasa/dti/subject_lists/ControlDiff_09182018.txt

for id in $(cat $subjlist | tr "\r" "\n") ; do 
	tenthDir=`echo $id | cut -d "/" -f 11` # *nii.gz OR PAC*
	timeDir=`echo $id | cut -d "/" -f 1-10`
	# NO DTIDIR
	if [[ $tenthDir == *".nii.gz" ]] ; then 
		dtidir="DTI_64dir_FoV240"
		mkdir $timeDir/DTI_64dir_FoV240/
		mkdir $timeDir/DTI_64dir_FoV240/nifti/ 
		mv $id $timeDir/DTI_64dir_FoV240/nifti/
		mv $timeDir/*bvec $timeDir/DTI_64dir_FoV240/nifti/
		mv $timeDir/*bval $timeDir/DTI_64dir_FoV240/nifti/ ;
	fi
        # DTIDIR, BUT NO NIFTI DIR, AND PAC* AND STUDY*:
	if [[ $tenthDir == "PAC"* ]] ; then
		eleventhDir=`echo $id | cut -d "/" -f 12` # STUDY*
		dtidir=`echo $id | cut -d "/" -f 13`
		mv -v $timeDir/$tenthDir/$eleventhDir/* $timeDir/ ###ERB: Is this definitely right? Yes.
		mkdir $timeDir/$dtidir/nifti/
		mv $timeDir/$dtidir/*.nii.gz $timeDir/$dtidir/nifti/
		mv $timeDir/$dtidir/*.bvec $timeDir/$dtidir/nifti/
		mv $timeDir/$dtidir/*.bval $timeDir/$dtidir/nifti/
		rm -R $timeDir/PAC*/ ;
	# FUCK UP
	else
		echo "$id has a different directory structure" ;
	fi 
	if [ -e $timeDir/$dtidir/nifti/201*.bvec ] ; then
		rm $timeDir/$dtidir/nifti/201*.bvec
		rm $timeDir/$dtidir/nifti/201*.bval
	fi
done


