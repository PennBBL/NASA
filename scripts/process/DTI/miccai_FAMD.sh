#!/bin/bash

### This script finds the MICCAI parcellation of a MD and an FA nifti
###
### Ellyn Butler
### November 28, 2018

# Trial: concordia_001 at t0
bzero=/data/joy/BBL/studies/nasa_antartica/processedData/diffusion/wo_2015/concordia_001/t0/concordia_001_t0_meanb0.nii.gz
T1miccai=/data/joy/BBL/studies/nasa_antartica/processedData/structural_containerized/xcpAccel_longJLF/wo_2015/concordia_001/t0/roiquant/miccai/wo_2015_concordia_001_t0_miccai.nii.gz
outputdir=/home/ebutler/concordia_001_miccai_FAMD


name="concordia_001_t0"

# Obtain affines and warps
antsRegistrationSyN.sh -t a -d 3 -f ${T1miccai} -m ${bzero} -o ${outputdir}/${name}

## Warps output to the template
antsApplyTransforms -d 3 -i ${bzero} \
                         -r ${T1miccai} -o ${outputdir}/${name}_SubjToTemp.nii.gz \
             -t ${outputdir}/${name}_transformWarped.nii.gz \
                         -t ${outputdir}/${name}_transform0GenericAffine.mat \
             -n Gaussian #ERB: what are we assuming is normally distributed? and why?


## Warp the miccai labels into template space using the same steps as above
antsApplyTransforms -d 3 -i ${parcMask} \ #ERB: where does this come from?
                         -r ${templateImg} -o ${antsDirectory}${parcDir}_subjectToTemplate.nii.gz \
                         -t ${antsDirectory}SubjectToTemplate1Warp.nii.gz \
                         -t ${antsDirectory}SubjectToTemplate0GenericAffine.mat \
             -n MultiLabel
