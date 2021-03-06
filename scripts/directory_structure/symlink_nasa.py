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

exec(open("/home/ebutler/scripts/NASA/directory_structure/process_directory_symlink_nasa.py"))
exec(open("/home/ebutler/scripts/NASA/directory_structure/make_links_symlink_nasa.py"))

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

# Get the basename for every file in "files_DWI"... does not include "/" at end
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



