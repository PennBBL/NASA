### This script creates symlinks for T1, T2 and diffusion images in the NASA Antartica project
###
### Ellyn Butler
### October 3, 2018

#!/data/joy/BBL/applications/nipy/bin/python

import sys
import os
import os.path as op
import re
import shutil
from glob import glob

root_dir = "/data/jux/BBL/studies/nasa_antartica"
bids_dir = root_dir + "/BIDS"



# list of source and destination pairs.
# T1
file = open('/home/ebutler/subjlists/nasa/subjlist_T1.csv', "r")
contents = file.readlines()
files_T1 = []
for i in range(len(contents)):
	files_T1.append(contents[i].strip())
# T2
file = open('/home/ebutler/subjlists/nasa/subjlist_T2.csv', "r")
contents = file.readlines()
files_T2 = []
for i in range(len(contents)):
	files_T2.append(contents[i].strip())
# DWI
file = open('/home/ebutler/subjlists/nasa/subjlist_DWI_all.csv', "r")
contents = file.readlines()
files_DWI = []
for i in range(len(contents)):
	files_DWI.append(contents[i].strip()) 

# Create list that will store (source, dest)
files_to_link = []

# Get the basename for every file in "files_DWI"... does noto include "/" at end
paths = []
files_bvec = []
files_bval = []
for image in files_DWI:
    paths.append(os.path.split(image)[0])
for directory in paths:
    print(directory)
    print(glob(directory + "/" + "*bvec")[0])
    files_bvec.append(glob(directory + "/" + "*bvec")[0])
    files_bval.append(glob(directory + "/" + "*bval")[0])

# Find the directories with bvecs or bvals
d = {}
for fname in paths:
    dir_list=fname.split("/")
    subj_id=dir_list[8]
    time_id=dir_list[9]
    key = subj_id + "_" + time_id
    d[key] = []
for bvec in files_bvec:
    dir_list=bvec.split("/")
    subj_id=dir_list[8]
    time_id=dir_list[9]
    key = subj_id + "_" + time_id
    d[key].append("bvec")


def process_directory(fname, files_to_link, datatype):
    #ERB: I don't get what data_dir is
    """Looks for data in a directory and adds
    (source, destination) pairs to files_to_link.
    """
    # Pull winter_id, subj_id and time_id from fname
    dir_list=fname.split("/")
    winter_id=dir_list[7]
    subj_id=dir_list[8]
    time_id=dir_list[9]

    # create symlink components
    dir_prefix = winter_id + "/" + subj_id + "/" + time_id
    output_dir = bids_dir + "/" + dir_prefix
    file_prefix = winter_id + "_" + subj_id + "_" + time_id #ERB: what we want to call the symlinked file (I think)

    if datatype == "dwi":
        dwi_output = output_dir + "/dwi/" + file_prefix + "_dwi.nii.gz"
        pair = (fname, dwi_output)
        files_to_link.append(pair)
    elif datatype == "bvec":
        bvec_output = output_dir + "/dwi/" + file_prefix + "_dwi.bvec"
        pair = (fname, bvec_output)
        files_to_link.append(pair)
    elif datatype == "bval":
        bval_output = output_dir + "/dwi/" + file_prefix + "_dwi.bval"
        pair = (fname, bval_output)
        files_to_link.append(pair)
    elif datatype == "T1":
        T1_output = output_dir + "/anat/" + file_prefix + "_T1w.nii.gz"
        pair = (fname, T1_output)
	files_to_link.append(pair)
    elif datatype == "T2":
        T2_output = output_dir + "/anat/" + file_prefix + "_T2w.nii.gz"
        pair = (fname, T2_output)
	files_to_link.append(pair)


def make_links(files_to_link):
    for source, dest in files_to_link:
        dest_dir, dest_f = op.split(dest)

        #If the containing directory doesn't exist
        #create it
        if not op.exists(dest_dir):
            os.makedirs(dest_dir)
        
        #Remove the old file if it exists
        if op.exists(dest):
            os.unlink(dest)
        
        #Create the symlink
        os.symlink(source, dest)

for fname in files_T1:
	process_directory(fname, files_to_link, "T1")
for fname in files_T2:
	process_directory(fname, files_to_link, "T2")
for fname in files_DWI:
	process_directory(fname, files_to_link, "dwi")
for fname in files_bvec:
	process_directory(fname, files_to_link, "bvec")
for fname in files_bval:
	process_directory(fname, files_to_link, "bval")

make_links(files_to_link)



