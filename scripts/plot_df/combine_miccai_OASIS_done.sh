### This script finds the volume and gmd values for all of the NASA Antarctica subjects who have finished
### as of March 25, 2019, and puts them into csvs
###
### Ellyn Butler
### March 25, 2019

finishANTsCT=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/*/*/*/struc/* -name "*CorticalThickness.nii.gz"`


for image in ${finishANTsCT}; do
	scandir=`echo $image |cut -d '/' -f 1-12`
	if [ -f ${scandir}/roiquant/miccai/*_corticalThickness.csv ] ; then 
		#cortcsv=`find ${scandir}/roiquant/miccai/* -name "*corticalThickness.csv"`
		#echo ${gmdcsv} >> /home/ebutler/subjlists/nasa/complete_OASIS_cort_03252019.csv
		gmdcsv=`find ${scandir}/roiquant/miccai/* -name "*miccai_mean_gmd.csv"` ; 
		echo ${gmdcsv} >> /home/ebutler/subjlists/nasa/complete_OASIS_gmd_03252019.csv
		volcsv=`find ${scandir}/roiquant/miccai/* -name "*miccai_vol.csv"` ; 
		echo ${volcsv} >> /home/ebutler/subjlists/nasa/complete_OASIS_vol_03252019.csv ; fi
done

#gmd
gmd_files=`cat /home/ebutler/subjlists/nasa/complete_OASIS_gmd_03252019.csv`
i=0                                       # Reset a counter
for filename in $gmd_files; do 
 if [ "$filename"  != "$OutFileName" ] ;      # Avoid recursion 
 then 
   if [[ $i -eq 0 ]] ; then 
      head -1  "$filename" >   /home/ebutler/erb_data/nasa/nasa_OASIS_gmd.csv # Copy header if it is the first file
   fi
   tail -n +2  "$filename" >>  /home/ebutler/erb_data/nasa/nasa_OASIS_gmd.csv # Append from the 2nd line each file
   i=$(( $i + 1 ))                            # Increase the counter
 fi
done

#vol
vol_files=`cat /home/ebutler/subjlists/nasa/complete_OASIS_vol_03252019.csv`
i=0                                       # Reset a counter
for filename in $vol_files; do 
 if [ "$filename"  != "$OutFileName" ] ;      # Avoid recursion 
 then 
   if [[ $i -eq 0 ]] ; then 
      head -1  "$filename" >   /home/ebutler/erb_data/nasa/nasa_OASIS_vol.csv # Copy header if it is the first file
   fi
   tail -n +2  "$filename" >>  /home/ebutler/erb_data/nasa/nasa_OASIS_vol.csv # Append from the 2nd line each file
   i=$(( $i + 1 ))                            # Increase the counter
 fi
done


	
