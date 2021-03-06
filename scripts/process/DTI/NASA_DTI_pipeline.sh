#!/bin/bash

#######add logs
logfile=""
logrun(){
run="$*"
lrn=$(($lrn+1))
printf ">> `date`: $lrn: ${run}\n" >> $logfile
$run 2>> $logfile
ec=$?
printf "exit code: $ec\n" #|tee -a $logfile
#[ ! $ec -eq 0 ] && printf "\nError running $exe; exit code: $ec; aborting.\n" |tee -a $logfile && exit 1
}

#alias python='/share/apps/python/Python-2.7.9/bin/python'


###check for necessary software/scripts
fsl=`ls $FSLDIR/bin/feat 2> /dev/null`
seq2nifti=`ls /home/melliott/scripts/sequence2nifti.sh 2> /dev/null`
dti_qa=`ls /home/melliott/scripts/qa_dti_v2.sh 2> /dev/null`
if [ ! -z $fsl ]  && [ ! -z $seq2nifti ] && [ ! -z $dti_qa ];then echo "All necessary programs/scripts found." echo "Checking for necessary files by subject."


####
#List of subjects to be analyzed (off of subject list or xnat audit)
subjects=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv

#List to be populated for grid submission
joblist=/data/jux/BBL/projects/nasa_antartica/dti/eons_joblist.txt 

#List of subjects missing direction file; Check and see if anyone missing DTI. 
no_dti=/data/jux/BBL/projects/nasa_antartica/dti/no_dti.csv 

#error file
process_fail=/data/jux/BBL/projects/nasa_antartica/dti/process_fail.csv

#Remove all previous versions of joblist and missing 
rm -f $joblist
rm -f $no_dti #ERB added
rm -f $process_fail #ERB added

#id person and timepoint 

s=/data/jux/BBL/studies/nasa_antartica/rawData/wo_2015/concordia_001/t0/S0010_DTI_30dir_FoV240/nifti/E1S0010X01I00001DTI30dirFoV240.nii.gz
#for s in $(cat $subjects | tr "\r" "\n"); do #December 13, 2018
	winter=`echo $s | cut -d "/" -f 8`
	subj=`echo $s | cut -d '/' -f 9`
	time=`echo $s | cut -d '/' -f 10`
	dtidir=`echo $s | cut -d '/' -f 11`
	echo $s
	echo $winter
	echo $subj
	echo $time
	echo $dtidir
	dti_name=`echo $subj"_"$time` # ERB: Is this how we want it?
	echo $dti_name	

	date=`date +%Y-%m-%d`
	echo $date
	i=/data/jux/BBL/studies/nasa_antartica/processedData/diffusion
	echo $i
	#dti_nii_out=/data/jux/BBL/studies/nasa/rawData/$winter/$subj/$time/$dtidir/nifti/*.nii 
	#echo $dti_nii_out
	logfile=$i/$winter/$subj/$time/$dti_name"_logfile_pipeline_"$date".log"
	echo $logfile


#Check if 'nasa' folder exists (dtifit is the last folder populated), if not make one
	if [ ! -e $i/$winter/$subj/$time/DTI_30/dtifit ]; then
		echo "making nasa directory"
		mkdir $i/DTI # ERB: What is this used for?

		#Make directories for 30 direction processing

		mkdir $i/$winter
		mkdir $i/$winter/$subj
		mkdir $i/$winter/$subj/$time/
		mkdir $i/$winter/$subj/$time/DTI_30
		mkdir $i/$winter/$subj/$time/DTI_30/raw_dti 
		mkdir $i/$winter/$subj/$time/DTI_30/qa
		mkdir $i/$winter/$subj/$time/DTI_30/eddy
		mkdir $i/$winter/$subj/$time/DTI_30/corrected_b_files
		mkdir $i/$winter/$subj/$time/DTI_30/dico_corrected
		mkdir $i/$winter/$subj/$time/DTI_30/dtifit
		mkdir $i/$winter/$subj/$time/DTI_30/dtitk/		
		mkdir $i/$winter/$subj/$time/DTI_30/dtitk/raw 
		mkdir $i/$winter/$subj/$time/DTI_30/dtitk/transforms
		mkdir $i/$winter/$subj/$time/DTI_30/dtitk/output
		
	else
		echo "NASA DTI folder structure complete"
	fi


#If QA has already been run, then skip the next two steps
echo "Run QA for 30 directions"
qa_file=`ls $i/$winter/$subj/$time/DTI_30/qa/$dti_name.qa`

		if [ -e ${s} ] && [ ! -e "$qa_file" ]; then	
		echo "running QA"
		# unzip
		
		# qa
	logrun /home/melliott/scripts/qa_dti_v3.sh -keep /data/jux/BBL/studies/nasa_antartica/rawData/$winter/$subj/$time/$dtidir/nifti/*.nii /data/jux/BBL/studies/nasa_antartica/rawData/$winter/$subj/$time/$dtidir/nifti/*.bval /data/jux/BBL/studies/nasa_antartica/rawData/$winter/$subj/$time/$dtidir/nifti/*.bvec $i/$winter/$subj/$time/DTI_30/qa/$dti_name.qa #ERB: This was changed from v2 to v3
		# rezip
		
		echo "QA complete"		
		else
		echo "QA Already Done"
		fi



#for a in /data/jux/BBL/studies/nasa_antartica/rawData/$winter/$subj/$time/$dtidir/nifti/*.nii* # ERB: Changed this path to rawData because that's where we stored our nifti files

#do

#/share/apps/fsl/5.0.8/bin/fslchfiletype NIFTI_GZ $a

#done

#fslsplit raw image, bet the b0 volume (first volume), then delete all volumes except the first volume and BET images (this is because there is no B0 map to use as a mask)

bet_image=`ls $i/$winter/$subj/$time/DTI_30/raw_dti/*BET.nii.gz`

	if [ "X$bet_image" == "X" ]; then
		cd $i/$winter/$subj/$time/DTI_30/raw_dti/
		#fslsplit
		fslsplit $s ${dti_name}_DTI_split -t
		mkdir $i/$winter/$subj/$time/DTI_30/raw_dti/b0
		cp $i/$winter/$subj/$time/DTI_30/raw_dti/*_DTI_split0000.nii.gz $i/$winter/$subj/$time/DTI_30/raw_dti/b0
		cd $i/$winter/$subj/$time/DTI_30/raw_dti/b0
		#bet b0		
		/share/apps/freesurfer/6.0.0/bin/bet.fsl $i/$winter/$subj/$time/DTI_30/raw_dti/*_DTI_split0000.nii.gz ${dti_name}.BET -R -f 0.5 -g 0 -c 0.00 0.00 0.00 -n -m 
		#clean up directory		
		rm -rf $i/$winter/$subj/$time/DTI_30/raw_dti/*_DTI_split*
		mv $i/$winter/$subj/$time/DTI_30/raw_dti/b0/*.nii.gz $i/$winter/$subj/$time/DTI_30/raw_dti
		rm -rf $i/$winter/$subj/$time/DTI_30/raw_dti/b0
	elif [ ! "X$bet_image" == "X" ]; then
	echo "BET image exists"
	fi 


		#Create list of subjects to run DTI processing steps
		if [ -e /data/jux/BBL/studies/nasa_antartica/rawData/$winter/$subj/$time/$dtidir/nifti/*.nii.gz ]; then 
			echo $s >> $joblist #ERB: Changed to the full path because we will need that in process... but now all of the subjects are in joblist and process_fail files (wasn't true when used dti_name, but then the actual dti_names were only showing up in $joblist)

		else 
		
			echo $s >> $no_dti
		fi
			
				
		if [ -e /data/jux/BBL/studies/nasa_antartica/rawData/$winter/$subj/$time/$dtidir/nifti/*.nii.gz ] && [ ! -e $i/$winter/$subj/$time/DTI_30/qa/*.qa ] ; then

			echo $s >> $process_fail
		fi

	
#done

echo "done, ready to submit to Q"
ntasks=$(cat $joblist | wc -l)
echo "number of jobs in array is $ntasks"

# Azeez's version of submitting jobs



#new
#qsub -V -q all.q -S /bin/bash -j y -t 1-${ntasks} /home/ebutler/scripts/NASA/process/NASA_DTI_process.sh $joblist ##### ERB: Uncomment this line when you are ready to run the process script
#/data/joy/BBL/projects/pncReproc2015/diffusionResourceFiles/GO1_DTI_process.sh $joblist
# ERB: Make /data/jux/BBL/projects/nasa/dti/Concordia_DTI_process.sh 

else 
echo "*******"
echo "ERROR: One or more of the scripts required to quantify and register DTI is missing."
echo "FSL: "$fsl
echo "seq2nifti: "$seq2nifti
echo "dti_qa: "$dtiqa
echo "*******"

fi #if [ ! -z $fsl ]  && [ ! -z $seq2nifti ] && [ ! -z $dti_qa ];then


#ERB: To Change
# 1) Name DTI folders by number of directions? And then use this to specify later scripts to be run in process?
