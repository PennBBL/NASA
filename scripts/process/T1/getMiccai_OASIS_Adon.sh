#!/bin/bash

export PATH=$PATH:/share/apps/singularity/2.5.1/bin

COHORTXCP=/data/jux/BBL/projects/nasa_antartica/xcpdocker/cohort/Adon/cohort3.csv # 3 has wo_2016 concordias not running on ebutler's account
FULL_COHORT=$COHORTXCP
NJOBS=$(wc -l <  ${FULL_COHORT})
num=$(expr $NJOBS - 1);

SNGL=/share/apps/singularity/2.5.1/bin/singularity
SIMG=/data/joy/BBL/applications/bids_apps/xcpEngineAnts3.simg
DESIGN=/data/jux/BBL/projects/nasa_antartica/xcpdocker/design/ANTs3_OASIS.dsn
OUTPUT=/data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/



HEADER=$(head -n 1 ${FULL_COHORT})
bb=$(seq 1 $num)

for j in $bb; do
    l=$(expr $j + 1)
    LINE=$(awk "NR==$l" ${FULL_COHORT})
    name=`echo $LINE | cut -d ',' -f 2-3 | tr , _ | cut -d '_' -f 2-3`
    if [[ `echo $LINE | cut -d ',' -f 2-3 | tr , _ | cut -d '_' -f 1` == "concordia" ]] ; then name="con_${name}" ; 
    elif [[ `echo $LINE | cut -d ',' -f 2-3 | tr , _ | cut -d '_' -f 1` == "DLR" ]] ; then name="DLR_${name}" ; fi
    TEMP_COHORT=${FULL_COHORT}.${j}.csv

    echo $HEADER > ${TEMP_COHORT}
    echo $LINE >> ${TEMP_COHORT}

    echo ${SNGL} run --cleanenv  -B /data:/home/arosen/data  ${SIMG} -c /home/arosen${TEMP_COHORT} -d /home/arosen${DESIGN} -o /home/arosen${OUTPUT} -r /home/arosen/data/jux/BBL/studies/nasa_antartica/rawData/ > /home/ebutler/xcpGetMiccaiSubjScripts_OASIS_ANTs3/Adon/${name}.sh

    qsub /home/ebutler/xcpGetMiccaiSubjScripts_OASIS_ANTs3/Adon/${name}.sh

done

#-B /data/jux/BBL/applications-from-joy/do_not_use_xcpEngine/xcpv0.6.1/space:/xcpEngine/space 
