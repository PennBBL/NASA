#!/bin/bash

### This script pulls all of the miccai parcellations csvs 
###
### Ellyn Butler
### November 7, 2018

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF/*/*/*/roiquant/miccai/*corticalThickness.csv > /home/ebutler/erb_data/nasa/nasa_slowjlf_CT.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF/*/*/*/roiquant/miccai/*gmd.csv > /home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF/*/*/*/roiquant/miccai/*vol.csv > /home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv

# from local computer
scp ebutler@chead:/home/ebutler/erb_data/nasa/nasa_slowjlf_CT.csv /Users/butellyn/Desktop/nasa_antartica/miccai_data/
scp ebutler@chead:/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv /Users/butellyn/Desktop/nasa_antartica/miccai_data/
scp ebutler@chead:/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv /Users/butellyn/Desktop/nasa_antartica/miccai_data/
