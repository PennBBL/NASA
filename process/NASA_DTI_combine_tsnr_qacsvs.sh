### This script creates a csv: winterover,subject_1,Time,tsnr_b1000
### 
### Ellyn Butler
### December 13, 2018

subjlist=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv

echo "winterover","subject_1","Time","tsnr_b1000">/home/ebutler/erb_data/nasa/nasa_dti_tsnr.csv


for dti_image in $(cat $subjlist | tr "\r" "\n"); do 
	winter=`echo $dti_image | cut -d '/' -f 8`
	subj=`echo $dti_image | cut -d '/' -f 9`
	time=`echo $dti_image | cut -d '/' -f 10`
	dtidir=`echo $dti_image | cut -d '/' -f 11`
	dti_name=`echo $subj"_"$time`
	pathtoprocessed=/data/jux/BBL/studies/nasa_antartica/processedData/diffusion
	out=$pathtoprocessed/$winter/$subj/$time/DTI_30/qa/$dti_name"_quality".csv
	tsnr_b1000=`cat ${out} | awk 'FNR == 2' | cut -d ',' -f 20`
	echo "${winter},${subj},${time},${tsnr_b1000}">>/home/ebutler/erb_data/nasa/nasa_dti_tsnr.csv
done
