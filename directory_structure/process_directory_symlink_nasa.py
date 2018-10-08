#!/data/joy/BBL/applications/nipy/bin/python

import sys
import os
import os.path as op
import re
import shutil
from glob import glob

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
