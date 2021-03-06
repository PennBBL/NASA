### This script combines all of the data the Kosha asked for
### 
### Ellyn Butler
### March 22, 2019

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
source("/home/ebutler/scripts/nasa_PHI/makeREDCapFriendly_NASAAntartica.R")
library('plyr')


### ---------- Ellyn's GMD ---------- ###
# Read in the data
data1 <- read.csv('/home/ebutler/erb_data/nasa/nasa_OASISLobeGlobal_gmd.csv', header=T)

# Put in REDCap indicators
data1 <- makeREDCapFriendly_NASAAntartica(data1)

### ---------- Ellyn's Volume ---------- ###
# Read in the data
data2 <- read.csv('/home/ebutler/erb_data/nasa/nasa_OASISLobeGlobal_vol.csv', header=T)

# Put in REDCap indicators
data2 <- makeREDCapFriendly_NASAAntartica(data2)

### ---------- Ellyn's CSF Ventricles ---------- ### # Bad Values January 15, 2019
# Read in the data
data3 <- read.csv('/home/ebutler/erb_data/nasa/nasa_OASIScsfVentricles.csv', header=T)

# Put in REDCap indicators
data3 <- makeREDCapFriendly_NASAAntartica(data3)

### ---------- JLF GMD ---------- ###
# Read in the data
#data4 <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv', header=T)

# Rename ID columns
#names(data4)[names(data4) == 'id0'] <- 'winterover'
#names(data4)[names(data4) == 'id1'] <- 'subject_1'
#names(data4)[names(data4) == 'id2'] <- 'Time'

# Put in REDCap indicators
#data4 <- makeREDCapFriendly_NASAAntartica(data4)

### ---------- JLF Vol ---------- ###
# Read in the data
#data5 <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv', header=T)

# Rename ID columns
#names(data5)[names(data5) == 'id0'] <- 'winterover'
#names(data5)[names(data5) == 'id1'] <- 'subject_1'
#names(data5)[names(data5) == 'id2'] <- 'Time'

# Put in REDCap indicators
#data5 <- makeREDCapFriendly_NASAAntartica(data5)

### ---------- Hippo ---------- ###
# Read in the data
data4 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_hippo_vol.csv', header=T)

# Put in REDCap indicators
data4 <- makeREDCapFriendly_NASAAntartica(data4)

### ---------- Demographics ---------- ###
# Read in the data
data5 <- read.csv('/home/ebutler/erb_data/nasa/nasa_antartica_demographics.csv', header=T)

# Put in REDCap indicators
data5 <- makeREDCapFriendly_NASAAntartica(data5)

### ---------- Total Brain metrics ---------- ###
# Read in the data
data6 <- read.csv('/home/ebutler/erb_data/nasa/nasa_WhiteMatterVolume.csv', header=T)

# Put in REDCap indicators
data6 <- makeREDCapFriendly_NASAAntartica(data6)
data6$WMV <- data6$R_Cerebral_White_Matter + data6$L_Cerebral_White_Matter


##################### Merge the data #####################

final_data <- merge(data1, data2) 
final_data <- merge(final_data, data3) 
final_data <- merge(final_data, data4) 
final_data <- merge(final_data, data5)
final_data <- merge(final_data, data6) 

# Reorder columns
final_data <- final_data[,c(4,6,1,2,3,5,395:400,7:394,401:403)] #March 22, 2019: THIS WILL NEED TO BE REDONE

# Write csv
write.csv(final_data, file='/home/ebutler/erb_data/nasa/nasa_structuralOASIS_allraw.csv', row.names=F)

##### Get rid of ROIs for Kosha and Taki
KoshaTaki <- final_data[,c("subid", "group","winterover","subject_1","Time","scanner","PatientSex","PatientSize","PatientWeight", "PatientBirthDate","AcquisitionDate","PatientAgeYears","AGMD","WMV","GMV","BasGang_GMD","Limbic_GMD","FrontOrb_GMD","FrontDors_GMD","Temporal_GMD","Parietal_GMD", "Occipital_GMD","BasGang_Vol","Limbic_Vol","FrontOrb_Vol","FrontDors_Vol","Temporal_Vol","Parietal_Vol","Occipital_Vol","vol_princeton_tot_CA1", "vol_princeton_tot_CA23","vol_princeton_tot_DG","vol_princeton_tot_ERC","vol_princeton_tot_PHC","vol_princeton_tot_PRC","vol_princeton_tot_SUB",
"vol_princeton_tot_hippo")]



write.csv(KoshaTaki, file='/home/ebutler/erb_data/nasa/nasa_structuralOASIS_KoshaTaki.csv', row.names=F)

