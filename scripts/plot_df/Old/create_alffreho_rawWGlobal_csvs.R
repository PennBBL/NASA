### This script creates csvs of raw data with global values (lobes and whole brain) for reho and alff
### 
### Ellyn Butler
### May 17, 2019

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Read in the data
if (type == "reho") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_reho.csv", header=TRUE)
	nasa_global <- read.csv("/home/ebutler/erb_data/nasa/nasa_seg_reho.csv", header=TRUE)
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=TRUE)
} else if (type == "alff") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_alff.csv", header=TRUE)
	nasa_global <- read.csv("/home/ebutler/erb_data/nasa/nasa_seg_alff.csv", header=TRUE)
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=TRUE)
} 

# Remove sub-1013 (concordia_013) from all dataframes... shitty data (see fmriprep output)
nasa_data <- nasa_data[nasa_data$id0 != "sub-1013",]
nasa_global <- nasa_global[nasa_global$id0 != "sub-1013",]
nasa_vol <- nasa_vol[nasa_vol$id1 != "concordia_013",]

# Correct IDs
colnames(nasa_vol)[colnames(nasa_vol)=="id0"] <- "winterover"
colnames(nasa_vol)[colnames(nasa_vol)=="id1"] <- "subject_1"
colnames(nasa_vol)[colnames(nasa_vol)=="id2"] <- "Time"

id_df <- read.csv("/home/ebutler/erb_data/nasa/nasa_origTofMRIPrep_key.csv", header=TRUE)
colnames(nasa_data)[colnames(nasa_data)=="id0"] <- "sub_id"
colnames(nasa_data)[colnames(nasa_data)=="id1"] <- "ses_id"
colnames(nasa_global)[colnames(nasa_global)=="id0"] <- "sub_id"
colnames(nasa_global)[colnames(nasa_global)=="id1"] <- "ses_id"

nasa_data <- merge(nasa_data, id_df)
nasa_global <- merge(nasa_global, id_df)
nasa_vol <- merge(nasa_vol, id_df)

# Remove concordia_010 at t0 from nasa_vol (no Rest BOLD)
nasa_vol <- nasa_vol[-c(34),]

# Remove sub-2104 ses-1 from nasa_vol (moved too much)
nasa_vol <- nasa_vol[-c(108),]

# Remove the winterover column from nasa_vol
nasa_vol$winterover <- NULL

# Calculate whole-brain metrics
otherString <- paste0(type, "_mean_miccai")
nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, volString="vol_miccai", otherString=otherString)
ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
ROIlist <- addUnderScore(ROIlist)
ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
ROI_ListofLists$Cerebellum <- NULL
# vol
nasa_vol <- averageLeftAndRight_Vol(nasa_vol, "_R_", "_L_", "_ave_")
ROIlist <- grep("_ave_", colnames(nasa_vol), value=TRUE)
ROIlist <- addUnderScore(ROIlist)
ROI_ListofLists_Vol <- roiLobes(ROIlist, lobeDef=FALSE)
ROI_ListofLists_Vol <- removeUnderScore(ROI_ListofLists_Vol)
ROI_ListofLists_Vol$Cerebellum <- NULL
nasa_vol <- lobeVolumes(nasa_vol, ROI_ListofLists_Vol, lastList=TRUE) 
# create lobular definitions
nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Vol, ROI_ListofLists, lastList=TRUE, type=type)

# Reorder columns so identifiers are at the beginning
nasa_data <- nasa_data[,c(1, 2, 120, 121, 3:119, 122:185)]

# Merge in global metrics
nasa_data <- merge(nasa_data, nasa_global)

# Add back in subjets without data, and put NAs in place (For ease of merging with other metrics)
# concordia_010 at t0, and concordia_013 at t0, t12 and t18
NA_vec <- rep(NA, 188)

nasa_data <- rbind(nasa_data, NA_vec)
nasa_data <- rbind(nasa_data, NA_vec)
nasa_data <- rbind(nasa_data, NA_vec)
nasa_data <- rbind(nasa_data, NA_vec)
nasa_data <- rbind(nasa_data, NA_vec)

nasa_data$sub_id <- as.character(nasa_data$sub_id)
nasa_data$ses_id <- as.character(nasa_data$ses_id)
nasa_data$subject_1 <- as.character(nasa_data$subject_1)
nasa_data$Time <- as.character(nasa_data$Time)

nasa_data[142, 1:4] <- c("sub-1010", "ses-1", "concordia_010", "t0")
nasa_data[143, 1:4] <- c("sub-1013", "ses-1", "concordia_013", "t0")
nasa_data[144, 1:4] <- c("sub-1013", "ses-2", "concordia_013", "t12")
nasa_data[145, 1:4] <- c("sub-1013", "ses-3", "concordia_013", "t18")
nasa_data[146, 1:4] <- c("sub-2104", "ses-1", "DLR_104", "t0")

nasa_data$sub_id <- factor(nasa_data$sub_id)
nasa_data$ses_id <- factor(nasa_data$ses_id)
nasa_data$subject_1 <- factor(nasa_data$subject_1)
nasa_data$Time <- factor(nasa_data$Time)

# Write out csvs
if (type == "reho") {
	write.csv(nasa_data, file= "/home/ebutler/erb_data/nasa/nasa_rawLobesGlobal_reho.csv", row.names=FALSE)
} else if (type == "alff") {
	write.csv(nasa_data, file= "/home/ebutler/erb_data/nasa/nasa_rawLobesGlobal_alff.csv", row.names=FALSE)
}



