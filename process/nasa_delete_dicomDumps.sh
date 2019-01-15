# Dicom dumps (bash)
dicom_dumps=`find /data/jux/BBL/studies/nasa_antartica/rawData/*/*/*/ -maxdepth 1 -type d -name "dicomDump" -print`

for dicom_dump in `echo $dicom_dumps`; do
	rm -R $dicom_dump
done

#ERB: New dir structure '/data/jux/BBL/studies/nasa_antartica/rawData/wo_2015/DLR_001/t0/20150703_PAC_01_1.xxx/S0002_MPRAGE_TI1100_p2'
