#!/bin/bash

### This script creates a csv of the diffusion parameters for each NASA Antartica subject
###
### Ellyn Butler
### October 23, 2018

subjects=/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv

# Parameters to get: echo time, repetition time, number of directions, average x y and z from bvec, total readout time, phase encoding direction

#echo "winter,subject_1,Time,echo_time,repetition_time,num_directions,mean_x,mean_y,mean_z,readout_time,phase_encoding_direction" > /home/ebutler/erb_data/nasa/nasa_DTI_parameters.csv

# 1) Find the subjects who do not have json files (now adapted to create a csv of json files)
cat $subjects | while read line ; do
	base_dir="$(echo $line | cut -d '/' -f 1-11)"
	subject_1="$(echo $line | cut -d '/' -f 9)"
	Time="$(echo $line | cut -d '/' -f 10)"
	json_file=`find $base_dir/* -name "*.json"`
	echo $json_file >> /home/ebutler/subjlists/nasa/nasa_DWI_jsons.csv
done

# 2) Find the bvecs
cat $subjects | while read line ; do
	base_dir="$(echo $line | cut -d '/' -f 1-12)"
	bvec=`find $base_dir/* -name "*.bvec"`
	#Check if missing... none were
	#if [ -z "$bvec" ] ; then echo "missing" ; fi
	#Create csv of bvecs
	echo $bvec >> /home/ebutler/subjlists/nasa/nasa_DWI_bvecs.csv
done

###Originally Missing 
#(fixed with /home/ebutler/scripts/NASA/process/get_json_diffusion.sh): #concordia_001_t0,concordia_001_t18,concordia_002_t0,concordia_002_t18,concordia_003_t0,concordia_003_t18,concordia_004_t0,concordia_004_t18,
#concordia_005_t0,concordia_005_t18,concordia_006_t0,concordia_006_t18,concordia_007_t0,concordia_007_t18,concordia_008_t0,concordia_008_t18,concordia_009_t0,
#concordia_009_t18,concordia_010_t0,concordia_010_t18,concordia_011_t0,concordia_011_t18,concordia_012_t0,concordia_012_t18,concordia_013_t0,concordia_013_t18

#(fixed with /home/ebutler/scripts/NASA/process/get_json_diffusion2.sh):
#concordia_101_t0,concordia_102_t0,concordia_103_t0,concordia_104_t0,concordia_104_t18,concordia_105_t0,concordia_105_t18, #concordia_106_t0,concordia_108_t0,concordia_108_t18,concordia_109_t18,concordia_110_t0, #concordia_111_t0,concordia_111_t18,concordia_112_t0,concordia_112_t18

#(did these individually)
#concordia_102_t12,concordia_105_t12,concordia_107_t0,concordia_107_t12,concordia_108_t12,concordia_109_t12,concordia_110_t12,concordia_111_t12,concordia_112_t12

#(these jsons existed... but directories didn't, so moved into nifti dir)
#DLR_001_t0,DLR_002_t0,DLR_003_t0,DLR_004_t0,DLR_005_t0,DLR_006_t0,DLR_007_t0,DLR_008_t0,DLR_009_t0,DLR_010_t0,DLR_011_t0,DLR_012_t0,DLR_013_t0




# 2) Pull parameters from jsons
#winter="$(echo $line | cut -d '/' -f 8)"
#subject_1="$(echo $line | cut -d '/' -f 9)"
#Time="$(echo $line | cut -d '/' -f 10)"



