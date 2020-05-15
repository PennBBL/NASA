paths=/home/ebutler/subjlists/nasa/nasa_diffExtract_dirs.csv

echo "" > /home/ebutler/subjlists/nasa/check_complete_03172019.csv

for subjdir in $(cat $paths | tr "\r" "\n") ; do
	subj=`echo $subjdir | cut -d '/' -f 11-12`
	if [ -f ${subjdir}/roiquant/miccai/*_miccai_vol.csv ] ; then echo "$subj has volume" >> /home/ebutler/subjlists/nasa/check_complete_03172019.csv ;
	elif [ -d ${subjdir}/jlf ] ; then echo "$subj has started jlf" >> /home/ebutler/subjlists/nasa/check_complete_03172019.csv ; 
	else echo "$subj NOT FAR.........." >> /home/ebutler/subjlists/nasa/check_complete_03172019.csv ; fi
done
