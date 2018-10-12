#!/bin/bash

subjlist=/Users/butellyn/Desktop/NASA/subject_lists/subjlist_T1.csv
basedir=/Users/butellyn/Box/T1T2_Hipp #ERB: for local machine

for id in $(cat $subjlist | tr "\r" "\n") ; do 
	winter=`echo $id | cut -d '/' -f 8` ;
	subj=`echo $id | cut -d '/' -f 9` ; 
	time=`echo $id | cut -d '/' -f 10` ;
	
	if [ ! -e $basedir/$winter/ ] ; then
		mkdir $basedir/$winter/ ;
	fi
	if [ ! -e $processed_dir/$winter/$subj/ ] ; then
		mkdir $basedir/$winter/$subj/ ;
	fi
	if [ ! -e $processed_dir/$winter/$subj/$time/ ] ; then
		mkdir $basedir/$winter/$subj/$time/ ;
	fi
	if [ ! -e $basedir/$winter/$subj/$time/images/ ] ; then
		mkdir $basedir/$winter/$subj/$time/images/ ; 
	fi
	if [ ! -e $basedir/$winter/$subj/$time/output/ ] ; then
		mkdir $basedir/$winter/$subj/$time/output/ ;
	fi
done

