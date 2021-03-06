#!/bin/bash

### This script downloads the T1 and T2 images onto my local machine
### 
### Ellyn Butler
### October 1, 2018

#T1_subjects=/home/ebutler/subjlists/nasa/subjlist_T1.csv
#T2_subjects=/home/ebutler/subjlists/nasa/subjlist_T2.csv
T1_subjects=/Users/butellyn/Desktop/NASA/subject_lists/subjlist_T1.csv
T2_subjects=/Users/butellyn/Desktop/NASA/subject_lists/subjlist_T2.csv
basedir=/Users/butellyn/Box/T1T2_Hipp #ERB: for local machine


rsync -R --copy-links ebutler@chead:/data/jux/BBL/studies/nasa_antartica/BIDS/*/*/*/anat/* /Users/butellyn/Box/T1T2_Hipp/ #wo_2016 concordias didn't have the right permissions

#for T1_id in $(cat $T1_subjects | tr "\r" "\n") ; do 
#	winter=`echo $T1_id | cut -d '/' -f 8` ;
#	subj=`echo $T1_id | cut -d '/' -f 9` ; 
#	time=`echo $T1_id | cut -d '/' -f 10` ;
#	rsync ebutler@chead:$T1_id $basedir/$winter/$subj/$time/images ;
#done


#for T2_id in $(cat $T2_subjects | tr "\r" "\n") ; do 
#	winter=`echo $T2_id | cut -d '/' -f 8` ;
#	subj=`echo $T2_id | cut -d '/' -f 9` ; 
#	time=`echo $T2_id | cut -d '/' -f 10` ;
#	rsync ebutler@chead:$T2_id $basedir/$winter/$subj/$time/images ;
#done
