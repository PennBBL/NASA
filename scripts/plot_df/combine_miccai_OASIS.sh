#!/bin/bash

### This script pulls all of the miccai parcellations csvs 
###
### Ellyn Butler
### March 22, 2019

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/*/*/*/roiquant/miccai/*corticalThickness.csv > /home/ebutler/erb_data/nasa/nasa_OASIS_CT.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/*/*/*/roiquant/miccai/*gmd.csv > /home/ebutler/erb_data/nasa/nasa_OASIS_gmd.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_ANTs3_diffExtract/*/*/*/roiquant/miccai/*vol.csv > /home/ebutler/erb_data/nasa/nasa_OASIS_vol.csv
