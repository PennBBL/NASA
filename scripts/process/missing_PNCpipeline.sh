### This script finds all of the subjects from the PNC pipeline who have
###
### Ellyn Butler
### January 16, 2018


miccaisegs=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF_OldAnts/*/*/*/roiquant/miccai/* -name "*_corticalThickness.csv"`
qcanatimg=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF_OldAnts/*/*/*/qcanat -name "*cortexMask.nii.gz"`

miccainames=`for segimg in $miccaisegs ; do subject="$(echo $segimg | cut -d '/' -f 11)" ; Time="$(echo $segimg | cut -d '/' -f 12)" ; name="${subject}_${Time}" ; echo $name ; done`

qcanatnames=`for qcanatname in $qcanatimg ; do subject="$(echo $qcanatname | cut -d '/' -f 11)" ; Time="$(echo $qcanatname | cut -d '/' -f 12)" ; name="${subject}_${Time}" ; echo $name ; done`

printf "${miccainames}\n${qcanatnames}" > /home/ebutler/PNCpipe_miccaivssomething.csv

missingnames=`sort /home/ebutler/PNCpipe_miccaivssomething.csv | uniq -u`

