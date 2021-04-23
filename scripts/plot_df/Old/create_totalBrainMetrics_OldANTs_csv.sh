### This script creates a csv of total brain metrics (should be in plot_df)
### 
### Ellyn Butler
### January 14, 2018 # NOT DONE. MAY NOT USE

subjects=`ls /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF_OldAnts/*/*/*/antsCT/*_BrainSegmentation.nii.gz`

echo "winterover","subject_1","Time","BVOL","GVol","WVol" > /home/ebutler/erb_data/nasa/nasa_OldAnts_totalBrainMetrics.csv

for subject in $subjects ; do
	winterover=`echo $subject | cut -d '/' -f 10`
	subject_1=`echo $subject | cut -d '/' -f 11`
	Time=`echo $subject | cut -d '/' -f 12`

	BVOL=`sed '2q;d' $subject | cut -d ',' -f 2` # don't use these... go straight from segmented image
	GVol=`sed '2q;d' $subject | cut -d ',' -f 3`
	WVol=`sed '2q;d' $subject | cut -d ',' -f 4`

	echo ${winterover},${subject_1},${Time},${BVOL},${GVol},${WVol} >> /home/ebutler/erb_data/nasa/nasa_OldAnts_totalBrainMetrics.csv
done
