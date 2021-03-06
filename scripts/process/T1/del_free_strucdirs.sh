### This script deletes struc directories from session directories that have not gone through anything except for brain extraction,
### or have completed the entire pipeline.
###
### Ellyn Butler
### March 13, 2019

subjdirs=`find /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/*/*/* -maxdepth 1 -name "t*"`

echo $subjdirs > /home/ebutler/subjlists/nasa/nasa_diffExtract_dirs.csv

paths=/home/ebutler/subjlists/nasa/nasa_diffExtract_dirs.csv

for subjdir in $(cat $paths | tr "\r" "\n") ; do
	if [ -f ${subjdir}/roiquant/miccai/*_miccai_vol.csv ] ; then rm -r ${subjdir}/struc ; fi
	if [ ! -d ${subjdir}/gmd ] ; then rm -r ${subjdir}/* ; fi
done
