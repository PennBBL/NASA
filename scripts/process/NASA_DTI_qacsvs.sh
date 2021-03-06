### This script compiles the QA metrics for Mark Elliott's DTI pipeline
###
### Ellyn Butler
### December 11, 2018

subjlist=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv

dti_image=/data/jux/BBL/studies/nasa_antartica/rawData/wo_2015/concordia_001/t0/S0010_DTI_30dir_FoV240/nifti/E1S0010X01I00001DTI30dirFoV240.nii.gz
#for dti_image in $(cat $subjlist | tr "\r" "\n"); do 
	winter=`echo $dti_image | cut -d '/' -f 8`
	subj=`echo $dti_image | cut -d '/' -f 9`
	time=`echo $dti_image | cut -d '/' -f 10`
	dtidir=`echo $dti_image | cut -d '/' -f 11`
	dti_name=`echo $subj"_"$time`
	pathtoraw=/data/jux/BBL/studies/nasa_antartica/rawData
	pathtoprocessed=/data/jux/BBL/studies/nasa_antartica/processedData/diffusion

	bvecs=`ls $pathtoraw/$winter/$subj/$time/$dtidir/nifti/*.bvec` 
	bvals=`ls $pathtoraw/$winter/$subj/$time/$dtidir/nifti/*.bval`
	process_fail=/data/jux/BBL/projects/nasa/dti/dti_process_fail.csv
	date=`date +%Y-%m-%d`
	logfile=$pathtoprocessed/$winter/$subj/$time/$dti_name"_logfile_process_"$date".log"
	out=$pathtoprocessed/$winter/$subj/$time/DTI_30/qa/$dti_name"_quality".csv

	qafile=$pathtoprocessed/$winter/$subj/$time/DTI_30/qa/"$dti_name".qa

	echo ${dti_name}

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

	echo "dti_name","date","clipval","clipcount","meanABSrms_b0","meanRELrms_b0","maxABSrms_b0","maxRELrms_b0","tsnr_b0","gmean_b0","drift_b0","outmax_b0","outmean_b0","outcount_b0","outlist_b0","meanABSrms_b1000","meanRELrms_b1000","maxABSrms_b1000","maxRELrms_b1000","tsnr_b1000","gmean_b1000","drift_b1000","driftpercent_b1000","outmax_b1000","outmean_b1000","outcount_b1000">$out
	echo ${dti_name},${date},${clipval},${clipcount},${meanABSrms_b0},${meanRELrms_b0},${maxABSrms_b0},${maxRELrms_b0},${tsnr_b0},${gmean_b0},${drift_b0},${outmax_b0},${outmean_b0},${outcount_b0},${outlist_b0},${meanABSrms_b1000},${meanRELrms_b1000},${maxABSrms_b1000},${maxRELrms_b1000},${tsnr_b1000},${gmean_b1000},${drift_b1000},${driftpercent_b1000},${outmax_b1000},${outmean_b1000},${outcount_b1000}>>$out;

#done
