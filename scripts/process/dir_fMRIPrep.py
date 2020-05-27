### This script finds the dicoms for resting BOLD scans that match certain parameters, and then copies them into a common
### directory, along with the corresponding dicoms for the T1-weighted image.... NEVER COMPLETED
### 
### Ellyn Butler
### April 9, 2019

#!/data/joy/BBL/applications/nipy/bin/python

import sys
import os
import os.path as op
import re
import shutil
from glob import glob
import pandas as pd
import json

file = open('/home/ebutler/subjlists/nasa/nasa_restbold_jsons.csv', "r")
contents = file.readlines()
Rest_jsons = []
for i in range(len(contents)):
	Rest_jsons.append(contents[i].strip())

#file2 = open('/home/ebutler/subjlists/nasa/nasa_restbold_128.csv', "r")
#contents = file2.readlines()
#for i in range(len(contents)):
#	Rest_jsons.append(contents[i].strip())

# Dictionary where the keys are unique parameter combinations (Matt's suggestion)
json_dict = {} 

for json_file in Rest_jsons:
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
		json_dict[key].append(json_file) #was scan
	else:
		json_dict[key] = [json_file] #was scan


