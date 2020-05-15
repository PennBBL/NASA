### This script creates a dictionary of all of the diffusion parameters for NASA Antartica
###
### Ellyn Butler
### October 24, 2018

#!/data/joy/BBL/applications/nipy/bin/python

import sys
import os
import os.path as op
import re
import shutil
from glob import glob
import pandas as pd
import json

file = open('/home/ebutler/subjlists/nasa/nasa_DWI_jsons.csv', "r") #doesn't contain concordia_104 at t12, November 14, 2018
	#discovered out of date on 
contents = file.readlines()
DWI_jsons = []
for i in range(len(contents)):
	DWI_jsons.append(contents[i].strip())

# Parameters from jsons: "ProtocolName", "EchoTime", "RepetitionTime", "TotalReadoutTime", "PhaseEncodingDirection"
# Parameters to calculate from bvecs: "MeanX", "MeanY", "MeanZ"

# Dictionary where the keys are unique parameter combinations (Matt's suggestion)
json_dict = {} 

for json_file in DWI_jsons:
	with open(json_file, "r") as f:
		data = json.load(f)
	dir_list=json_file.split("/")
	subj_id = dir_list[8]
	time_id = dir_list[9]
	scan = subj_id + "_" + time_id
	ProtocolName = data['ProtocolName']
	EchoTime = str(data['EchoTime'])
	RepetitionTime = str(data['RepetitionTime'])
	TotalReadoutTime = str(data['TotalReadoutTime'])
	pedir = data["PhaseEncodingDirection"] if data.get("PhaseEncodingDirection") is not None else data["PhaseEncodingAxis"]
	key = ProtocolName + "_" + EchoTime + "_" + RepetitionTime + "_" + TotalReadoutTime + "_" + pedir
	if key in json_dict:
		json_dict[key].append(scan)
	else:
		json_dict[key] = [scan]

#find the number of scans per key
for key in json_dict:
	print(len(json_dict[key]))

# Dictionary to turn into csv (keys are column names)
file2 = open('/home/ebutler/subjlists/nasa/nasa_DWI_bvecs.csv', "r")
contents2 = file2.readlines()
DWI_bvecs = []
for i in range(len(contents2)):
	DWI_bvecs.append(contents2[i].strip())

parameter_dict = {'winter':[], 'subject_1':[], 'Time':[], 'ProtocolName':[], 'EchoTime':[], 'RepetitionTime':[], 'TotalReadoutTime':[], 'PhaseEncodingDirection':[], 'MeanX':[], 'MeanY':[], 'MeanZ':[]}

for json_file in DWI_jsons:
	with open(json_file, "r") as f:
		data = json.load(f)
	dir_list = json_file.split("/")
	parameter_dict['winter'].append(dir_list[7])
	parameter_dict['subject_1'].append(dir_list[8])
	parameter_dict['Time'].append(dir_list[9])
	parameter_dict['ProtocolName'].append(data['ProtocolName'])
	parameter_dict['EchoTime'].append(data['EchoTime'])
	parameter_dict['RepetitionTime'].append(data['RepetitionTime'])
	parameter_dict['TotalReadoutTime'].append(data['TotalReadoutTime'])
	pedir = data["PhaseEncodingDirection"] if data.get("PhaseEncodingDirection") is not None else data["PhaseEncodingAxis"]
	parameter_dict['PhaseEncodingDirection'].append(pedir)
	

# first row is x directions, second row is y directions, and third is z directions
for bvec_path in DWI_bvecs:
	bvec_file = open(bvec_path)
	bvec_lines = bvec_file.readlines()
	# X
	x_row_string = bvec_lines[0].strip()
	x_row_string_list = x_row_string.split(' ')
	x_row_num_list = []
	for element in x_row_string_list:
		num = float(element)
		x_row_num_list.append(num)
	MeanX = sum(x_row_num_list)/float(len(x_row_num_list))
	parameter_dict['MeanX'].append(MeanX)
	# Y 
	y_row_string = bvec_lines[1].strip()
	y_row_string_list = y_row_string.split(' ')
	y_row_num_list = []
	for element in y_row_string_list:
		num = float(element)
		y_row_num_list.append(num)
	MeanY = sum(y_row_num_list)/float(len(y_row_num_list))
	parameter_dict['MeanY'].append(MeanY)
	# Z
	z_row_string = bvec_lines[2].strip()
	z_row_string_list = z_row_string.split(' ')
	z_row_num_list = []
	for element in z_row_string_list:
		num = float(element)
		z_row_num_list.append(num)
	MeanZ = sum(z_row_num_list)/float(len(z_row_num_list))
	parameter_dict['MeanZ'].append(MeanZ)
	

# create a dataframe from parameter_dict
dataframe = pd.Dataframe.from_dict(parameter_dict)
dataframe.to_csv('/home/ebutler/erb_data/nasa/diffusion_parameters.csv')








# Summary

#40 'DTI_30dir_FoV240_0.09_9.3_0.033443_j-' ... all wo_2015 subjects from t0 or t18, expect PK_t1
#71 'DTI_64dir_FoV240_0.087_12_0.032597_j-' ... all controls, concordia_006_t18, and phantoms t1 & t4 (except PK_t1)

#Problems:
# 1) The phantoms scans from Cologne have 64 directions, while the crew members have only 30
# 2) Protocol within site differed across scans






