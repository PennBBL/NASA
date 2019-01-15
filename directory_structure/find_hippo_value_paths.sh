#!/bin/bash

### This script finds the paths to the subfield values for the hippocampi
###
### Ellyn Butler
### October 29, 2018

find /data/joy/BBL/studies/nasa_antartica/processedData/hippocampus/*/*/*/ -name "subfield_values_jlfcllite.csv" > /home/ebutler/subjlists/nasa/nasa_hippo_jlfcllite.csv

find /data/joy/BBL/studies/nasa_antartica/processedData/hippocampus/*/*/*/ -name "subfield_values_jlfcl.csv" > /home/ebutler/subjlists/nasa/nasa_hippo_jlfcl.csv
