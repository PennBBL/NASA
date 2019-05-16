#!/bin/bash

export PATH=$PATH:/share/apps/singularity/2.5.1/bin

BIDS=/data/jux/BBL/studies/nasa_antartica/BIDS

SNGL=/share/apps/singularity/2.5.1/bin/singularity
SIMG=/data/joy/BBL/applications/bids_apps/pl-mriqc0.12.0-dev0.simg
OUTPUT=/data/jux/BBL/studies/nasa_antartica/qualityAssessment

qsub ${SNGL} run --cleanenv -B /data:/home/ebutler/data ${SIMG} /home/ebutler${BIDS} /home/ebutler${OUTPUT} participant --participant_label wo_2015/concordia_001/t0


qsub ${SNGL} run --cleanenv -B /data:/home/ebutler/data ${SIMG} -o /home/ebutler${OUTPUT} -r ${BIDS}

