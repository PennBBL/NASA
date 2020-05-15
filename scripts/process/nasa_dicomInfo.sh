#!/bin/bash

SNGL=/share/apps/singularity/2.5.1/bin/singularity

### Phantoms
# obtain scan and session labels
scans_phantoms=/data/jux/BBL/studies/nasa_antartica/rawData/phantoms/*/*/

for sc in $scans_phantoms; do
	subID=$(echo $sc | cut -d '/' -f 9);
	ses=$(echo $sc | cut -d '/' -f 10); 

	#dir=$(echo /data/jux/BBL/studies/nasa_antartica/rawData/output/.heudiconv/${subID});

# USE SINGULARITY HERE TO RUN HEUDICONV FOR DICOM INFO

	${SNGL} run -B /data/jux/BBL/studies/nasa_antartica/rawData/phantoms:/home/ebutler/base_phantoms /data/joy/BBL/applications/heudiconv/heudiconv-latest.simg -d /home/ebutler/base_phantoms/{subject}/{session}/dicomDump/* -o /home/ebutler/base_phantoms/output -f convertall -s ${subID} -ss ${ses}  -c none --overwrite;

done 

### Winter Over 2015


### Winter Over 2016




