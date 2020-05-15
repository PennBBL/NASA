### This script combines all of the data the Kosha asked for
### 
### Ellyn Butler
### December 17, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
source("/home/ebutler/scripts/nasa_PHI/makeREDCapFriendly_NASAAntartica.R")
library('plyr')


### ---------- Ellyn's GMD ---------- ###
# Read in the data
data1 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_brain_gmd.csv', header=T)

# Put in REDCap indicators
data1 <- makeREDCapFriendly_NASAAntartica(data1)

### ---------- Ellyn's Volume ---------- ###
# Read in the data
data2 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_brain_vol.csv', header=T)

# Put in REDCap indicators
data2 <- makeREDCapFriendly_NASAAntartica(data2)

### ---------- Ellyn's CSF Ventricles ---------- ### # Bad Values January 15, 2019
# Read in the data
data3 <- read.csv('/home/ebutler/erb_data/nasa/nasa_csfVentricles.csv', header=T)

# Put in REDCap indicators
data3 <- makeREDCapFriendly_NASAAntartica(data3)

### ---------- JLF GMD ---------- ###
# Read in the data
data4 <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv', header=T)

# Rename ID columns
names(data4)[names(data4) == 'id0'] <- 'winterover'
names(data4)[names(data4) == 'id1'] <- 'subject_1'
names(data4)[names(data4) == 'id2'] <- 'Time'

# Put in REDCap indicators
data4 <- makeREDCapFriendly_NASAAntartica(data4)

### ---------- JLF Vol ---------- ###
# Read in the data
data5 <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv', header=T)

# Rename ID columns
names(data5)[names(data5) == 'id0'] <- 'winterover'
names(data5)[names(data5) == 'id1'] <- 'subject_1'
names(data5)[names(data5) == 'id2'] <- 'Time'

# Put in REDCap indicators
data5 <- makeREDCapFriendly_NASAAntartica(data5)

### ---------- Hippo ---------- ###
# Read in the data
data6 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_hippo_vol.csv', header=T)

# Put in REDCap indicators
data6 <- makeREDCapFriendly_NASAAntartica(data6)

### ---------- Demographics ---------- ###
# Read in the data
data7 <- read.csv('/home/ebutler/erb_data/nasa/nasa_antartica_demographics.csv', header=T)

# Put in REDCap indicators
data7 <- makeREDCapFriendly_NASAAntartica(data7)

### ---------- Total Brain metrics ---------- ###
# Read in the data
data8 <- read.csv('/home/ebutler/erb_data/nasa/nasa_WhiteMatterVolume.csv', header=T)

# Put in REDCap indicators
data8 <- makeREDCapFriendly_NASAAntartica(data8)
data8$AHWMV <- (data8$R_Cerebral_White_Matter + data8$L_Cerebral_White_Matter)/2


##################### Merge the data #####################

final_data <- merge(data1, data2) #ventricles left out January 15, 2019
final_data <- merge(final_data, data4) 
final_data <- merge(final_data, data5)
final_data <- merge(final_data, data6) 
final_data <- merge(final_data, data7) 
final_data <- merge(final_data, data8) 

# Reorder columns
final_data <- final_data[,c(4,6,1,2,3,5,395:400,7:394,401:403)]

# Write csv
write.csv(final_data, file='/home/ebutler/erb_data/nasa/nasa_structural_allraw.csv', row.names=F)

##### Get rid of ROIs for Kosha and Taki
KoshaTaki <- final_data[,c("subid", "group","winterover","subject_1","Time","scanner","PatientSex","PatientSize","PatientWeight", "PatientBirthDate","AcquisitionDate","PatientAgeYears","AGMD","AHWMV","AHGMV","BasGang_GMD","Limbic_GMD","FrontOrb_GMD","FrontDors_GMD","Temporal_GMD","Parietal_GMD", "Occipital_GMD","BasGang_Vol","Limbic_Vol","FrontOrb_Vol","FrontDors_Vol","Temporal_Vol","Parietal_Vol","Occipital_Vol","vol_princeton_ave_CA1", "vol_princeton_ave_CA23","vol_princeton_ave_DG","vol_princeton_ave_ERC","vol_princeton_ave_PHC","vol_princeton_ave_PRC","vol_princeton_ave_SUB",
"vol_princeton_ave_hippo")]



write.csv(KoshaTaki, file='/home/ebutler/erb_data/nasa/nasa_structural_KoshaTaki.csv', row.names=F)

