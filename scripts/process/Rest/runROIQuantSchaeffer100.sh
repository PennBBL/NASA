### This script runs a custom ROI quantification of reho and alff 
### for NASA Antarctica subjects... PROBABLY NOT DOABLE GIVEN DIMENSIONS OF IMAGES
###
### Ellyn Butler
### April 23, 2019

#!/bin/bash

export PATH=$PATH:/share/apps/singularity/2.5.1/bin

COHORTXCP=/data/jux/BBL/projects/nasa_antartica/xcpdocker/cohort/cohort_rehoalff.csv # needs to be reho and alff paths
FULL_COHORT=$COHORTXCP
NJOBS=$(wc -l <  ${FULL_COHORT})
num=$(expr $NJOBS - 1);

SNGL=/share/apps/singularity/2.5.1/bin/singularity
SIMG=/data/joy/BBL/applications/bids_apps/xcpEngine.simg # ask which version to use... this one was updated on April 10, 2019 by Azeez
OUTPUT=/data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine # Put on jux because joy was full on April 22, 2019

HEADER=$(head -n 1 ${FULL_COHORT})
bb=$(seq 1 $num)

for j in $bb; do
    l=$(expr $j + 1)
    LINE=$(awk "NR==$l" ${FULL_COHORT})
    name=`echo $LINE | cut -d ',' -f 1-2 | tr ',' '_'`
    TEMP_COHORT=/data/jux/BBL/projects/nasa_antartica/xcpdocker/cohort/${name}_cohort.csv

    echo $HEADER > ${TEMP_COHORT}
    echo $LINE >> ${TEMP_COHORT}

    echo ${SNGL} run --cleanenv  -B /data:/home/ebutler/data ${SIMG}  > /home/ebutler/xcpRehoAlff100/${name}.sh ###

    #qsub /home/ebutler/xcpRehoAlff100/${name}.sh

done

