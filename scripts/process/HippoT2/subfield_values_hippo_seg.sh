#!/bin/bash

### This scripts pulls all of the subfields values from layer_002 and layer_002
### after all of the hippocampi have been processed
###
### October 22, 2018
### Ellyn Butler

T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv
processed_dir=/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus


for i in `seq 1 146`; do

# ---identify the T1 image---
T1_image=`sed "${i}q;d" $T1_subjects`

# ---identify the T2 image---
T2_image=`sed "${i}q;d" $T2_subjects`

# ---make the output directory---
winter=`echo $T1_image | cut -d '/' -f 8`
subj=`echo $T1_image | cut -d '/' -f 9`
time=`echo $T1_image | cut -d '/' -f 10`

output_dir=$processed_dir/$winter/$subj/$time ; 

# --- create subfield_values file --- #ERB: Find way/time to replace space with commas
values_layer_three=`LabelGeometryMeasures 3 ${output_dir}/layer_003*`

# replace ', ' with ','
# put quotes around []
# add an '_' between 'Axes' and 'Length', and 'Bounding' and 'Box'
# replace ' ' with ','
echo $values_layer_three | sed 's/, /,/g' | sed -e 's/\[\([^]]*\)\]/\"[\1]"/g' | sed 's/(mm^2)//g' | sed 's/Axes /Axes_/g' | sed 's/Bounding /Bounding_/g' | sed 's/ /,/g' > ${output_dir}/subfield_values_jlfcllite.csv
# gives one line of comma separated values... set dimensions of matrix in R (should have 9 columns and 14 rows, with header)

values_layer_two=`LabelGeometryMeasures 3 ${output_dir}/layer_002*`

echo $values_layer_two | sed 's/, /,/g' | sed -e 's/\[\([^]]*\)\]/\"[\1]"/g' | sed 's/(mm^2)//g' | sed 's/Axes /Axes_/g' | sed 's/Bounding /Bounding_/g' | sed 's/ /,/g' > ${output_dir}/subfield_values_jlfcl.csv

done
