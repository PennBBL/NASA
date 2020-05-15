#!/data/joy/BBL/applications/nipy/bin/python

import sys
import os
import os.path as op
import re
import shutil
from glob import glob

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
