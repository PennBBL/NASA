#!/bin/bash

### This script pulls all of the miccai parcellations csvs 
###
### Ellyn Butler
### October 10, 2018

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel/*/*/*/roiquant/miccai/*corticalThickness.csv > /home/ebutler/erb_data/nasa/nasa_quickjlf_CT.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel/*/*/*/roiquant/miccai/*gmd.csv > /home/ebutler/erb_data/nasa/nasa_quickjlf_gmd.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel/*/*/*/roiquant/miccai/*vol.csv > /home/ebutler/erb_data/nasa/nasa_quickjlf_vol.csv

# from local computer
scp ebutler@chead:/home/ebutler/erb_data/nasa/nasa_quickjlf_CT.csv /Users/butellyn/Desktop/nasa_antartica/miccai_data/
scp ebutler@chead:/home/ebutler/erb_data/nasa/nasa_quickjlf_gmd.csv /Users/butellyn/Desktop/nasa_antartica/miccai_data/
scp ebutler@chead:/home/ebutler/erb_data/nasa/nasa_quickjlf_vol.csv /Users/butellyn/Desktop/nasa_antartica/miccai_data/
