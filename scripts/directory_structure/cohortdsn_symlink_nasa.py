### This script creates symlinks for the cohort and design files for NASA miccai
###
### Ellyn Butler
### October 10, 2018

#!/data/joy/BBL/applications/nipy/bin/python

import sys
import os
import os.path as op
import re
import shutil
from glob import glob

exec(open("/home/ebutler/scripts/NASA/directory_structure/process_directory_symlink_nasa.py"))
exec(open("/home/ebutler/scripts/NASA/directory_structure/make_links_symlink_nasa.py"))

files_to_link = [('/data/jux/BBL/projects/nasa_antartica/xcpdocker/design/miccaidocker.dsn','/home/ebutler/scripts/NASA/struc/miccaidocker.dsn'),('/data/jux/BBL/projects/nasa_antartica/xcpdocker/cohort/cohort.csv','/home/ebutler/subjlists/nasa/miccaidocker_cohort.csv')]

make_links(files_to_link)
