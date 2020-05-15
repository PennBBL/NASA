### This script renames all of the dicoms by prepending 
###
### Ellyn Butler
### October 31, 2018

#!/data/joy/BBL/applications/nipy/bin/python

from glob import glob
import fnmatch
import os


for root, dirs, files in os.walk('/data/jux/BBL/studies/nasa_antartica/rawData/', topdown=False):
	for name in files:
		full_path = os.path.join(root, name)
		if ' ' in full_path:
			full_path_no_space = full_path.replace(" ", "")
			full_path_clean = full_path_no_space.replace("#", "")
			os.rename(full_path, full_path_clean)
