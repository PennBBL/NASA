### This script checks if 
###
### Ellyn Butler
### April 11-12, 2019

# obtain scan and session labels
sc=/data/jux/BBL/studies/nasa_antartica/forfMRIPrep/Nifti/sub-2002/ses-1

ses=$(echo $sc | cut -d '/' -f 10 | cut -d '-' -f 2); 
subID=$(echo $sc | cut -d '/' -f 9 | cut -d '-' -f 2);

# USE SINGULARITY HERE TO RUN HEUDICONV FOR BIDS FORMATTING

#/share/apps/singularity/2.5.1/bin/singularity run -B /data/jux/BBL/studies/nasa_antartica/forfMRIPrep:/home/ebutler/base /data/joy/BBL/applications/heudiconv/heudiconv-latest.simg -d /home/ebutler/base/Dicom/sub-{subject}/ses-{session}/*.dcm -o /home/ebutler/base/output -f convertall -s ${subID} -ss ${ses}  -c none --overwrite

/share/apps/singularity/2.5.1/bin/singularity run -B /data/jux/BBL/studies/nasa_antartica:/home/ebutler/base /data/joy/BBL/applications/heudiconv/heudiconv-latest.simg -d /home/ebutler/base/forfMRIPrep/Dicom/sub-{subject}/ses-{session}/*.dcm -o /home/ebutler/base/heudiconv_Trial -f /home/ebutler/base/nasa_heuristic.py -s ${subID} -ss ${ses}  -c dcm2niix -b --overwrite;





#/data/jux/BBL/studies/nasa_antartica/heudiconv_Trial #(output dir)
