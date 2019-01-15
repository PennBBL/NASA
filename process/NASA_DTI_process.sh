#set -x

source /home/prupert/.bashrc


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

alias python="python2"


#input is the subject ID from the loop script #####ERB: Change this back to $1 when working

subjlist=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv
# tried concordia_001 t0 (probably t18 too) and now (10/17) concordia_004 at t18
#ERB: Hard-coded in for now... should change to an input from pipeline

#cat /home/prupert/Conte_DTI/redo_subs.txt | while read id
#subjects=/home/prupert/Conte_DTI/redo_subs.txt
for dti_image in $(cat $subjects | tr "\r" "\n"); do 

	#id=$(cat $subjlist|sed -n "${SGE_TASK_ID}p")  #only use for array jobs, comment out for non-grid testing #ERB: This line isn't working
	winter=`echo $dti_image | cut -d '/' -f 8`
	subj=`echo $dti_image | cut -d '/' -f 9`
	time=`echo $dti_image | cut -d '/' -f 10`
	dtidir=`echo $dti_image | cut -d '/' -f 11`
	dti_name=`echo $subj"_"$time`
	pathtoraw=/data/jux/BBL/studies/nasa_antartica/rawData
	pathtoprocessed=/data/jux/BBL/studies/nasa_antartica/processedData/diffusion
#dti_image=`ls $pathtoraw/$winter/$subj/$time/$dtidir/nifti/*.nii.gz` 

#acqparams=/data/jux/BBL/projects/pncReproc2015/diffusionResourceFiles/acqparams.txt #ERB: Changed to two lines, only relevant for eddy
#index_trial=/data/jux/BBL/projects/nasa_antartica/dti/diffusionResourceFiles/index_trial.txt
#indexfile_30=/data/jux/BBL/projects/nasa_antartica/dti/diffusionResourceFiles/index_30.txt
#indexfile_34=/data/jux/BBL/projects/nasa_antartica/dti/diffusionResourceFiles/index_34.txt
#indexfile_64=/data/jux/BBL/projects/nasa_antartica/dti/diffusionResourceFiles/index_64.txt
# Select an index file based on the number of directions
#dim4=`fslval $id dim4`
#if [ "$dim4" -eq "31" ]; then indexfile=$indexfile_30
#elif [ "$dim4" -eq "35" ]; then indexfile=$indexfile_34
#elif [ "$dim4" -eq "65" ]; then indexfile=$indexfile_64
#fi

	bvecs=`ls $pathtoraw/$winter/$subj/$time/$dtidir/nifti/*.bvec` 
	bvals=`ls $pathtoraw/$winter/$subj/$time/$dtidir/nifti/*.bval`
	process_fail=/data/jux/BBL/projects/nasa/dti/dti_process_fail.csv
	date=`date +%Y-%m-%d`
	logfile=$pathtoprocessed/$winter/$subj/$time/$dti_name"_logfile_process_"$date".log"
	out=$pathtoprocessed/$winter/$subj/$time/DTI_30/qa/$dti_name"_quality".csv


	echo " Processing subject "$dti_name

#Make DTI coverage mask for each subject by backtransforming FSL's FMRIB58 DTI mask to native space

#Register single b=0 dwi image to FMRIB58 DTI FA map

	if [ ! -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/dti_eddy_with_CNI_rotated_bvecs_FA.nii.gz ] ; then 

		
		echo "register b=0 to FMRIB58"
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_DTI_split0000.nii.gz" ] ; then
		echo "move b=0 image to standard space" ;
		logrun flirt -dof 6 -in $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_DTI_split0000.nii.gz" -ref /data/jux/BBL/projects/pncReproc2015/diffusionResourceFiles/FMRIB58_FA_1mm.nii.gz -out $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dwi_n_standard_space.nii.gz" -omat $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dwi_n_standard_space.mat" ;
		# SHOULD NOT USE PNC SPACE
		echo "dwi to std space done" ;
		else 
		echo "ERROR: no mean b=0 image" ;
		error_msg1="ERROR: no b=0 image" ;
		fi 

#Invert transform
		echo "invert transform" ;
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dwi_n_standard_space.mat" ] ; then
		logrun convert_xfm -omat $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_std_n_dwi_space.mat" -inverse $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dwi_n_standard_space.mat" ;
		else 
		echo "ERROR: dwi to standard not run" ;
		error_msg2="ERROR: dwi to standard not run" ;
		fi 

##############################
#Transform FMRIB58 FA to single subject space
		echo "FMRIB to native"			
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_std_n_dwi_space.mat" ] ; then
		logrun flirt -in /data/jux/BBL/projects/pncReproc2015/diffusionResourceFiles/FMRIB58_mask.nii.gz -ref $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_DTI_split0000.nii.gz" -interp nearestneighbour -applyxfm -init $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_std_n_dwi_space.mat" -out $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dtistd_2.mask.nii.gz"
		else
		echo "ERROR: inverse transformation matrix does not exist"
		error_msg3="ERROR: inverse transformation matrix does not exist"
		fi

#Run FSL EDDY_CORRECT for eddy current correction
		echo "Running eddy_correct"
		if [ -e $dti_image ] && [ ! -e $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy_correct.nii.gz" ]; then
		logrun /share/apps/fsl/5.0.9/bin/eddy_correct $dti_image $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/"$dti_name"_eddy_correct.nii.gz 0 #ERB: Failing here
		else
		echo "ERROR: DTI image does not exist or eddy image does exist"
		error_msg4="ERROR: DTI image does not exist"
		fi

#Estimate tensors with and without motion regressors and rotated b-vectors file distortion correction
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/"$dti_name"_eddy_correct.nii.gz ] ; then
		
		#Estimate tensor with raw b-vectors and bvals	
		echo "moving on to next, using 6 parameter motion as confound regressors and rotating bvecs"
		logrun dtifit -k $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/"$dti_name"_eddy_correct.nii.gz -o $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_dti_eddy_rbvecs -m $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dtistd_2.mask.nii.gz" -r ${bvecs} -b ${bvals}
		echo "running dtifit in standard FSL pipeline"





	echo "End of direction processing" 

#echo "Pull 32 direction QA data" 

#cd $path/$bblid/$sessionid/DTI_32/qa
	qafile=$pathtoprocessed/$winter/$subj/$time/DTI_30/qa/"$dti_name".qa

	clipval=$(cat $qafile | grep clipval | awk '{print $2}');
	clipcount=$(cat $qafile | grep clipcount | awk '{print $2}');
	meanABSrms_b0=$(cat $qafile | grep meanABSrms_b0 | awk '{print $2}');
	meanRELrms_b0=$(cat $qafile | grep meanRELrms_b0 | awk '{print $2}');
	maxABSrms_b0=$(cat $qafile | grep maxABSrms_b0 | awk '{print $2}');
	maxRELrms_b0=$(cat $qafile | grep maxRELrms_b0 | awk '{print $2}');
	tsnr_b0=$(cat $qafile | grep tsnr_b0 | awk '{print $2}'); 
	gmean_b0=$(cat $qafile | grep gmean_b0 | awk '{print $2}');
	drift_b0=$(cat $qafile | grep drift_b0 | awk '{print $2}');
	outmax_b0=$(cat $qafile | grep outmax_b0 | awk '{print $2}');
	outmean_b0=$(cat $qafile | grep outmean_b0 | awk '{print $2}');
	outcount_b0=$(cat $qafile | grep outcount_b0 | awk '{print $2}');
	outlist_b0=$(cat $qafile | grep outlist_b0 | awk '{print $2}');
	meanABSrms_b1000=$(cat $qafile | grep meanABSrms_b1000 | awk '{print $2}');
	meanRELrms_b1000=$(cat $qafile | grep meanRELrms_b1000 | awk '{print $2}');
	maxABSrms_b1000=$(cat $qafile | grep maxABSrms_b1000 | awk '{print $2}');
	maxRELrms_b1000=$(cat $qafile | grep maxRELrms_b1000 | awk '{print $2}');
	tsnr_b1000=$(cat $qafile | grep tsnr_b1000 | awk '{print $2}'); 
	gmean_b1000=$(cat $qafile | grep gmean_b1000 | awk '{print $2}');
	drift_b1000=$(cat $qafile | grep drift_b1000 | awk '{print $2}');
	driftpercent_b1000=$(cat $qafile | grep driftpercent_b1000 | awk '{print $2}');
	outmax_b1000=$(cat $qafile | grep outmax_b1000 | awk '{print $2}');
	outmean_b1000=$(cat $qafile | grep outmean_b1000 | awk '{print $2}');
	outcount_b1000=$(cat $qafile | grep outcount_b1000 | awk '{print $2}');

	echo "dti_name","date","clipval","clipcount","meanABSrms_b0","meanRELrms_b0","maxABSrms_b0","maxRELrms_b0","tsnr_b0","gmean_b0","drift_b0","outmax_b0","outmean_b0","outcount_b0","outlist_b0","outlist_b0","meanABSrms_b1000","meanRELrms_b1000","tsnr_b1000","gmean_b1000","drift_b1000","driftpercent_b1000","outmax_b1000","outmean_b1000","outcount_b1000">$out
	echo ${dti_name},${date},${clipval},${clipcount},${meanABSrms_b0},${meanRELrms_b0},${maxABSrms_b0},${maxRELrms_b0},${tsnr_b0},${gmean_b0},${drift_b0},${outmax_b0},${outmean_b0},${outcount_b0},${outlist_b0},${outlist_b0},${meanABSrms_b1000},${meanRELrms_b1000},${tsnr_b1000},${gmean_b1000},${drift_b1000},${driftpercent_b1000},${outmax_b1000},${outmean_b1000},${outcount_b1000}>>$out;


#Change file names to not have "." and have "_" instead 


	if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*FA.nii.gz ] ; then 

	logrun mv $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name".BET_mask.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name"_BET_mask.nii.gz
	logrun mv $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name".BET.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name"_BET.nii.gz
	logrun mv $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name"_dtistd_2.mask.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name"_dtistd_2_mask.nii.gz

	fi


#Rename and create RD and AD images

	if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L1.nii.gz ] ; then

	cp $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L1.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_dti_eddy_rbvecs_AD.nii.gz 

	fi


	if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L2.nii.gz ] && [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L3.nii.gz ] ; then 

	fslmaths $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L2.nii.gz -add $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L3.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_RDtmp.nii.gz

	fslmaths $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_RDtmp.nii.gz -div 2 $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_dti_eddy_rbvecs_RD.nii.gz

	rm $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_RDtmp.nii.gz

fi

done












