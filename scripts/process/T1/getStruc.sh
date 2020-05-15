#!/bin/bash

export PATH=$PATH:/share/apps/singularity/2.5.1/bin

COHORTXCP=/data/jux/BBL/projects/nasa_antartica/xcpdocker/cohort/cohort.csv
FULL_COHORT=$COHORTXCP
NJOBS=$(wc -l <  ${FULL_COHORT})
num=$(expr $NJOBS - 1);

SNGL=/share/apps/singularity/2.5.1/bin/singularity
SIMG=/data/joy/BBL/applications/bids_apps/xcpEngineAnts3.simg
DESIGN=/data/jux/BBL/projects/nasa_antartica/xcpdocker/design/ANTs3_struc.dsn
OUTPUT=/data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3/



HEADER=$(head -n 1 ${FULL_COHORT})
bb=$(seq 1 $num)

for j in $bb; do
    l=$(expr $j + 1)
    LINE=$(awk "NR==$l" ${FULL_COHORT})
    name=`echo $LINE | cut -d ',' -f 2-3 | tr , _`
    TEMP_COHORT=${FULL_COHORT}.${j}.csv

    echo $HEADER > ${TEMP_COHORT}
    echo $LINE >> ${TEMP_COHORT}

    echo ${SNGL} run --cleanenv  -B /data:/home/ebutler/data  ${SIMG} -c /home/ebutler${TEMP_COHORT} -d /home/ebutler${DESIGN} -o /home/ebutler${OUTPUT} -r /home/ebutler/data/jux/BBL/studies/nasa_antartica/rawData/ > /home/ebutler/xcpGetStrucSubjScripts_ANTs3/${name}_${j}.sh

    qsub /home/ebutler/xcpGetStrucSubjScripts_ANTs3/${name}_${j}.sh

done
