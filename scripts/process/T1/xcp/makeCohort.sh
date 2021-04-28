#!/bin/bash
# AFGR March 2018
# This script will be used to make a cohort file for all of the anatomical processing
# which will be run through the XCP Accelerator 
# The issue is that we have mprage images and another GE image.
# I am going to have to make sure I have at least three images from every subject

# First declare any static variables
inputDir="/data/jux/BBL/studies/nasa/rawData/"
inputDir2=( "wo_2015/" "wo_2016/" )
outputFile="/data/jux/BBL/projects/NASA/data/anatCohort.csv"
tpVals=( "t0" "t12" "t18" )

# First find all tp0 mprage images
for x in `find /data/jux/BBL/studies/nasa/rawData/wo_2015/ -name "t0" -type d` ; do 
  outImage=`ls ${x}/*MPRAGE*/nifti/*nii.gz`
  nID=`echo ${x} | rev | cut -f 2 -d / | rev`
  tpID="t0"
  echo "${nID},${tpID},${outImage}" >> ${outputFile} ;
done
for x in `find /data/jux/BBL/studies/nasa/rawData/wo_2015/ -name "t12" -type d` ; do 
  outImage=`ls ${x}/*3DBRAV*/nifti/*nii.gz`
  nID=`echo ${x} | rev | cut -f 2 -d / | rev`
  tpID="t12" 
  echo "${nID},${tpID},${outImage}" >> ${outputFile} ;
done
for x in `find /data/jux/BBL/studies/nasa/rawData/wo_2015/ -name "t18" -type d` ; do 
  outImage=`ls ${x}/*MPRAGE*/*nii.gz`
  nID=`echo ${x} | rev | cut -f 2 -d / | rev`
  tpID="t8"
  echo "${nID},${tpID},${outImage}" >> ${outputFile} ;
done
# Now onto 2016 cohort
for x in `find /data/jux/BBL/studies/nasa/rawData/wo_2016/ -name "t0" -type d` ; do 
  outImage=`ls ${x}/*MPRAGE*/*nii.gz`
  nID=`echo ${x} | rev | cut -f 2 -d / | rev`
  tpID="t0"
  echo "${nID},${tpID},${outImage}" >> ${outputFile} ;
done
for x in `find /data/jux/BBL/studies/nasa/rawData/wo_2016/ -name "t12" -type d` ; do 
  outImage=`ls ${x}/*3DBRAV*/*nii.gz`
  nID=`echo ${x} | rev | cut -f 2 -d / | rev`
  tpID="t12" 
  echo "${nID},${tpID},${outImage}" >> ${outputFile} ;
done
for x in `find /data/jux/BBL/studies/nasa/rawData/wo_2016/ -name "t18" -type d` ; do 
  outImage=`ls ${x}/*MPRAGE*/*nii.gz`
  nID=`echo ${x} | rev | cut -f 2 -d / | rev`
  tpID="t18"
  echo "${nID},${tpID},${outImage}" >> ${outputFile} ;
done
