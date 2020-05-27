### This script finds the reho and alff values for all of the NASA Antarctica subjects 
###
### Ellyn Butler
### May 16, 2019 - May 20, 2019


awk 'FNR==1 && NR!=1{next;}{print}' /data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine/*/*/roiquant/miccai/*_mean_alff.csv > /home/ebutler/erb_data/nasa/nasa_alff.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine/*/*/roiquant/miccai/*_mean_reho.csv > /home/ebutler/erb_data/nasa/nasa_reho.csv


# Add global metrics
awk 'FNR==1 && NR!=1{next;}{print}' /data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine/*/*/roiquant/segmentation/*_mean_alff.csv > /home/ebutler/erb_data/nasa/nasa_seg_alff.csv

awk 'FNR==1 && NR!=1{next;}{print}' /data/jux/BBL/studies/nasa_antartica/processedData/rest_containerized/xcpEngine/*/*/roiquant/segmentation/*_mean_reho.csv > /home/ebutler/erb_data/nasa/nasa_seg_reho.csv




