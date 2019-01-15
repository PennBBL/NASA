#!/bin/bash

### This scripts links all of the dicoms (and other files) for every timepoint into a directory 
### in the timepoint subdirectory called "dicomDump"
###
### Ellyn Butler
### October 31, 2018

timepoints=/data/jux/BBL/studies/nasa_antartica/rawData/*/*/*/

for time in $timepoints ; do
	mkdir ${time}dicomDump/ ;
	for i in `find ${time} -type f` ; do 
		ln ${i} ${time}dicomDump/ 
	done
done
