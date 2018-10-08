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

#input is the subject ID from the loop script #####ERB: Change this back to $1 when working

subjlist=/data/jux/BBL/projects/nasa/dti/subject_lists/subjlist_diffusion_09262018.txt #ERB: Hard-coded in for now... should change to an input from pipeline

#cat /home/prupert/Conte_DTI/redo_subs.txt | while read id
#subjects=/home/prupert/Conte_DTI/redo_subs.txt
#for id in $(cat $subjects | tr "\r" "\n"); do 

id=$(cat $subjlist|sed -n "${SGE_TASK_ID}p")  #only use for array jobs, comment out for non-grid testing #ERB: This line isn't working
winter=`echo $id | cut -d '/' -f 8`
subj=`echo $id | cut -d '/' -f 9`
time=`echo $id | cut -d '/' -f 10`
dtidir=`echo $id | cut -d '/' -f 11`
dti_name=`echo $subj"_"$time`
pathtoraw=/data/jux/BBL/studies/nasa_antartica/rawData
pathtoprocessed=/data/jux/BBL/studies/nasa_antartica/processedData/diffusion
dti_image=`ls $pathtoraw/$winter/$subj/$time/$dtidir/nifti/*.nii.gz` 

acqparams=/data/jux/BBL/projects/pncReproc2015/diffusionResourceFiles/acqparams.txt #ERB: Changed to two lines
index_trial=/data/jux/BBL/projects/nasa/dti/diffusionResourceFiles/index_trial.txt
indexfile_30=/data/jux/BBL/projects/nasa/dti/diffusionResourceFiles/index_30.txt #
indexfile_34=/data/jux/BBL/projects/nasa/dti/diffusionResourceFiles/index_34.txt #ERB: Check number of 1's match logic of index_trial
indexfile_64=/data/jux/BBL/projects/nasa/dti/diffusionResourceFiles/index_64.txt #
# Select an index file based on the number of directions
dim4=`fslval $id dim4`
if [ "$dim4" -eq "31" ]; then indexfile=$index_trial
elif [ "$dim4" -eq "35" ]; then indexfile=$indexfile_34
elif [ "$dim4" -eq "65" ]; then indexfile=$indexfile_64
fi

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


#Run FSL EDDY for motion correction and eddy current correction (should be done before distortion correction -per FSL's Mark Jenkinson)
		echo "Running eddy"
		if [ -e $dti_image ] && [ ! -e $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.nii.gz" ]; then
		logrun eddy --imain=$dti_image --mask="$pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/"$dti_name".BET_mask.nii.gz" --acqp=$acqparams --index=$indexfile --bvecs=$bvecs --bvals=$bvals --out="$pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/"$dti_name"_eddy_2acqp.nii.gz"; #ERB: Get rid of "_2acqp.nii.gz" when settle on acqparams
####ERB: EDDY DID NOT DO ANYTHING.... mask is super messed up, too... prefrontal cortex gone
		else
		echo "ERROR: DTI image does not exist or eddy image does exist"
		error_msg4="ERROR: DTI image does not exist"
		fi

#Extract Motion Parameters from EDDY Corrected data
		echo "extract motion parameters"
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.eddy_parameters" ] && [ ! -e $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_6param_eddy_parameters" ]; then 
		echo "eddy was run....time to extract 6 motion parameters"
		cat $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.eddy_parameters" | sed "s/  / /g" | cut  -d " " -f 1-6 > $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name.6param.eddy_parameters
		else 
		echo "ERROR: EDDY motion parameters do not exist"
		error_msg5="ERROR: EDDY motion parameters do not exist"
		fi

#Rotate bvecs file after motion correction
		echo "rotate bvecs"		
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.eddy_parameters" ] ; then
		logrun /home/melliott/scripts/ME_rotate_bvecs.sh $bvecs $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name".dti.rotated.bvec" $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.eddy_parameters"
		else 
		logrun echo "ERROR: EDDY motion parameters do not exist"
		error_msg5="ERROR: EDDY motion parameters do not exist"
		fi

#copy bvals from raw
		
		if [ ! -e $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/*.bval ]; then 
		echo "copy bvals"		
		cp $bvals $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/


		else 

		echo "bvals already exist" 

		fi

#copy bvecs from eddy ==========================
		echo "copy bvecs"		
		mv $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name".dti.rotated.bvec" $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dti_rotated.bvec"	
	
		cp $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dti_rotated.bvec" $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/


#Apply distortion correction using field map #ERB: This will be a problem...At what point was b0mapwT2star supposed to be created? Also, if we do manage to create this, we need to identify a common path to the raw dicoms
		echo "apply distortion"		
		if [ -e $pathtoprocessed/b0mapwT2star/$winter/$subj/$time/*mag1_brain.nii* ] && [ -e $pathtoprocessed/b0mapwT2star/$winter/$subj/$time/*rpsmap.nii* ] && [ -e $pathtoprocessed/b0mapwT2star/$winter/$subj/$time/*mask.nii* ] && [ ! -e $pathtoprocessed/$winter/$subj/$time/"$dti_name".dico_dico.nii.gz ]; then
		cd $pathtoprocessed/$winter/$subj/$time/DTI_30/dico_corrected/
		echo "running distortion correction"
		logrun /home/melliott/scripts/dico_correct_v2.sh -n -k -f /data/jux/BBL/studies/nasa_antartica/processedData/b0mapwT2star/$winter/$subj/$time/*mag1_brain.nii* -e $pathtoraw/$winter/$subj/$time/$dtidir/Dicoms/* $pathtoprocessed/$winter/$subj/$time/DTI_30/dico_corrected/$dti_name".dico." /data/jux/BBL/studies/nasa_antartica/processedData/b0mapwT2star/$winter/$subj/$time/*rpsmap.nii* /data/jux/BBL/studies/nasa_antartica/processedData/b0mapwT2star/$winter/$subj/$time/*mask.nii* $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy".nii.gz
		cd $pathtoprocessed #ERB: No idea if this is right
		else 
		logrun echo "ERROR: Distortion Correction could not be run. Check B0_map_new folder"
		error_msg6="ERROR: Distortion Correction could not be run. Check B0_map_new folder"
		fi



#Estimate tensors with and without motion regressors and rotated b-vectors file distortion correction
		if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dico_corrected/$dti_name".dico_dico.nii" ] ; then
		
		#Estimate tensor with confound regressors and with rotated b-vectors file distortion correction		
		echo "moving on to next, using 6 parameter motion as confound regressors and rotating bvecs"
		logrun dtifit -k $pathtoprocessed/$winter/$subj/$time/DTI_30/dico_corrected/$dti_name".dico_dico.nii" -o $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_dti_eddy_rbvecs -m $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dtistd_2.mask.nii.gz" -r $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/$dti_name"_dti_rotated".bvec -b $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/*.bval --cni=$pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name".6param.eddy_parameters"
		echo "running dtifit in standard FSL pipeline"

		elif [ ! -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dico_corrected/$dti_name".dico_dico.nii" ] ; then
		logrun dtifit -k $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.nii.gz" -o $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/$dti_name"_dti_eddy_rbvecs" -m $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dtistd_2.mask.nii.gz" -r $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/$dti_name"_dti_rotated".bvec -b $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/*.bval --cni=$pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name.6param.eddy_parameters
		echo "running dtifit in standard FSL pipeline"

#ERB: dtifit -k itself is failing
#ERB: This does not exist $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/$dti_name"_dti_eddy_rbvecs", or anywhere in the DTI_30 dir... fine, because output
#ERB: This exists $pathtoprocessed/$winter/$subj/$time/DTI_30/raw_dti/$dti_name"_dtistd_2.mask.nii.gz"
#ERB: This exists $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/$dti_name"_dti_rotated".bvec
#ERB: This exists $pathtoprocessed/$winter/$subj/$time/DTI_30/corrected_b_files/*.bval
#ERB: This exists $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name.6param.eddy_parameters

#terminate called after throwing an instance of 'NEWMAT::SingularException'



		else
		logrun echo "ERROR: DTIFIT fail NO distortion corrected image availabe"
		error_msg7="ERROR: DTIFIT fail NO distortion corrected image availabe"
		echo $dti_name $error_msg1 $error_msg2 $error_msg3 $error_msg4 $error_msg5 $error_msg6 $error_msg7 >> $process_fail
		fi
#ERB: This does not exist $pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/$dti_name"_eddy.nii.gz"
#$pathtoprocessed/$winter/$subj/$time/DTI_30/eddy/"$dti_name"_eddy

fi 

echo "End of direction processing" 

#echo "Pull 32 direction QA data" 

#cd $path/$bblid/$sessionid/DTI_32/qa
qafile=$pathtoprocessed/$winter/$subj/$time/DTI_30/qa/"$dti_name".qa

clipcount=$(cat $qafile | grep clipcount |awk '{print $2}');
tsnr=$(cat $qafile | grep tsnr_bX | awk '{print $2}'); 
gmean=$(cat $qafile | grep gmean_bX | awk '{print $2}');
drift=$(cat $qafile | grep drift_bX | awk '{print $2}');
outmax=$(cat $qafile | grep outmax_bX | awk '{print $2}');
outmean=$(cat $qafile | grep outmean_bX | awk '{print $2}');
outcount=$(cat $qafile | grep outcount_bX | awk '{print $2}');
meanABSrms=$(cat $qafile | grep meanABSrms | awk '{print $2}');
meanRELrms=$(cat $qafile | grep meanRELrms | awk '{print $2}');
maxABSrms=$(cat $qafile | grep maxABSrms | awk '{print $2}');
maxRELrms=$(cat $qafile | grep maxRELrms | awk '{print $2}');


echo "dti_name", "date","clipcount", "temporal_signal-to-noise_ratio","gmean", "drift", "maximum_intensity_outlier", "mean_intensity_outlier", "count_outlier", "abs_mean_rms_motion","rel_mean_rms_motion","abs_max_rms_motion", "rel_max_rms_motion">>$out
echo $dti_name, $date, $clipcount, $tsnr, $gmean, $drift, $outmax, $outmean, $outcount, $meanABSrms, $meanRELrms, $maxABSrms,$maxRELrms >>$out;

for l in $pathtoprocessed/$winter/$subj/$time/DTI_30/dico_corrected/*.nii ;

do

/share/apps/fsl/5.0.8/bin/fslchfiletype NIFTI_GZ $l

done



#Change file names to not have "." and have "_" instead 


if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*FA.nii.gz ] ; then 

cd $pathtoprocessed/$winter/$subj/$time/DTI_30/
logrun mv dico_corrected/"$dti_name".dico_dico.nii.gz dico_corrected/"$dti_name"_dico_dico.nii.gz
logrun mv dico_corrected/"$dti_name".dico_magmap_coreg.nii.gz dico_corrected/"$dti_name"_dico_magmap_coreg.nii.gz
logrun mv dico_corrected/"$dti_name".dico_magmap_masked.nii.gz dico_corrected/"$dti_name"_dico_magmap_masked.nii.gz
logrun mv dico_corrected/"$dti_name".dico.mat dico_corrected/"$dti_name"_dico.mat
logrun mv dico_corrected/"$dti_name".dico_rpsmap_coreg.nii.gz dico_corrected/"$dti_name"_dico_rpsmap_coreg.nii.gz
logrun mv dico_corrected/"$dti_name".dico_rpsmap_mask_coreg.nii.gz dico_corrected/"$dti_name"_dico_rpsmap_mask_coreg.nii.gz
logrun mv dico_corrected/"$dti_name".dico_shiftmap.nii.gz dico_corrected/"$dti_name"_dico_shiftmap.nii.gz
logrun mv dico_corrected/"$dti_name".dico_shims.txt dico_corrected/"$dti_name"_dico_shims.txt

logrun mv eddy/"$dti_name".6param.eddy_parameters eddy/"$dti_name"_6param_eddy_parameters
logrun mv eddy/"$dti_name"_eddy.eddy_parameters eddy/"$dti_name"_eddy_eddy_parameters

logrun mv raw_dti/"$dti_name".dti.32_rotated.bvec raw_dti/"$dti_name"_dti_32_rotated.bvec
logrun mv raw_dti/"$dti_name"_dtistd_2.mask.nii.gz raw_dti/"$dti_name"_dtistd_2_mask.nii.gz

fi


#Rename and create RD and AD images

if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L1.nii.gz ] ; then

cp $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L1.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_dti_eddy_rbvecs_AD.nii.gz 

fi


if [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L2.nii.gz ] && [ -e $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L3.nii.gz ] ; then 

fslmaths $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/*L2.nii.gz -add $pathtoprocessed/$winter/$subj/$time/DTI_30/*L3.nii.gz $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_RDtmp.nii.gz

fslmaths $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_RDtmp.nii.gz -div 2 $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_dti_eddy_rbvecs_RD.nii.gz

rm $pathtoprocessed/$winter/$subj/$time/DTI_30/dtifit/"$dti_name"_RDtmp.nii.gz

fi
