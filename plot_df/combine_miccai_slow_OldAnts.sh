#!/bin/bash

### This script pulls all of the miccai parcellations csvs 
###
### Ellyn Butler
### January 14, 2019

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF_OldAnts/*/*/*/roiquant/miccai/*corticalThickness.csv > /home/ebutler/erb_data/nasa/nasa_slowjlf_OldAnts_CT.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF_OldAnts/*/*/*/roiquant/miccai/*gmd.csv > /home/ebutler/erb_data/nasa/nasa_slowjlf_OldAnts_gmd.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF_OldAnts/*/*/*/roiquant/miccai/*vol.csv > /home/ebutler/erb_data/nasa/nasa_slowjlf_OldAnts_vol.csv
