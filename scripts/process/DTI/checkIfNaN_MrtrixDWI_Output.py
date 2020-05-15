### Script to check for NaNs in fa and md maps (NASA)
### And perform other quality checks
###
### Ellyn Butler
### November 28, 2018

import numpy as np
import os
import nibabel as nib
from nibabel.testing import data_path
import matplotlib.pyplot as plt

fa_csv = open('/home/ebutler/subjlists/nasa/nasa_FA.csv', "r")
fa_contents = fa_csv.readlines()
fa_paths = []
for i in range(len(fa_contents)):
	fa_paths.append(fa_contents[i].strip())


# Dictionary where keys are subj_time and values are number of NaNs in the image (first FA)
NaN_dict = {}

for fa_file in fa_paths:
	# Find the number of NaN voxels
	data = nib.load(fa_file)
	data_array = data.get_fdata()
	subset_array = np.isnan(data_array)
	missing_array = data_array[subset_array]
	num_NaN = len(missing_array)
	# Put in dictionary
	dir_list = fa_file.split("/")
	subj_id = dir_list[9]
	time_id = dir_list[10]
	key = subj_id + "_" + time_id
	NaN_dict[key] = [num_NaN]
	

# (second MD)
md_csv = open('/home/ebutler/subjlists/nasa/nasa_MD.csv', "r")
md_contents = md_csv.readlines()
md_paths = []
for i in range(len(md_contents)):
	md_paths.append(md_contents[i].strip())

for md_file in md_paths:
	# Find the number of NaN voxels
	data = nib.load(md_file)
	data_array = data.get_fdata()
	subset_array = np.isnan(data_array)
	missing_array = data_array[subset_array]
	num_NaN = len(missing_array)
	# Put in dictionary
	dir_list = md_file.split("/")
	subj_id = dir_list[9]
	time_id = dir_list[10]
	key = subj_id + "_" + time_id
	if key in NaN_dict:
		NaN_dict[key].append(num_NaN)
	else:
		NaN_dict[key] = [num_NaN]

# Create histograms for each subject's FA values across time
FA_map_dict = {}

for fa_file in fa_paths:
	# Find the number of NaN voxels
	data = nib.load(fa_file)
	data_array = data.get_fdata()
	greaterThanZero = np.greater(data_array, 0)
	data_array_nozero = data_array[greaterThanZero]
	dir_list = fa_file.split("/")
	key = dir_list[9]
	if key in FA_map_dict:
		FA_map_dict[key].append(data_array_nozero)
	else:
		FA_map_dict[key] = [data_array_nozero]

# Note: Some FA values greater than 1 (impossible)











