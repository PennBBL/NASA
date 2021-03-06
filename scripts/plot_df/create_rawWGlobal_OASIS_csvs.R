### This script creates csvs of raw data, but with global values (lobes and whole brain)
### 
### Ellyn Butler
### March 22, 2019

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Read in the data
if (type == "gmd") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_OASIS_gmd.csv", header=TRUE)
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_OASIS_vol.csv", header=TRUE)
} else if (type == "vol") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_OASIS_vol.csv", header=TRUE)
} 

# Correct IDs
colnames(nasa_data)[colnames(nasa_data)=="id0"] <- "winterover"
colnames(nasa_data)[colnames(nasa_data)=="id1"] <- "subject_1"
colnames(nasa_data)[colnames(nasa_data)=="id2"] <- "Time"
if (type != "vol") {
	colnames(nasa_vol)[colnames(nasa_vol)=="id0"] <- "winterover"
	colnames(nasa_vol)[colnames(nasa_vol)=="id1"] <- "subject_1"
	colnames(nasa_vol)[colnames(nasa_vol)=="id2"] <- "Time"
}

# Put in scanner
if (type == "gmd") {
	nasa_data <- scanningSite_NASAAntartica(nasa_data)
	nasa_vol <- scanningSite_NASAAntartica(nasa_vol)
} else if (type == "vol") {
	nasa_data <- scanningSite_NASAAntartica(nasa_data)
} 

# Calculate whole-brain metrics
if (type == "gmd") {
	# !!!! temporarily get rid of pallidum
	#nasa_data$anatomical_gmd_mean_miccai_R_Pallidum <- NULL
	#nasa_data$anatomical_gmd_mean_miccai_L_Pallidum <- NULL
	#nasa_vol$vol_miccai_R_Pallidum <- NULL
	#nasa_vol$vol_miccai_L_Pallidum <- NULL 
	# gmd
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="anatomical_gmd_mean_")
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
	nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Vol, ROI_ListofLists, lastList=TRUE, type="gmd")
	# create whole brain gmd
	nasa_vol$regionalTotalVolume <- nasa_vol$BasGang_Vol + nasa_vol$Limbic_Vol + nasa_vol$FrontOrb_Vol + nasa_vol$FrontDors_Vol + nasa_vol$Temporal_Vol + nasa_vol$Parietal_Vol + nasa_vol$Occipital_Vol
	lobe_short_colnames <- c("BasGang", "Limbic", "FrontOrb", "FrontDors", "Temporal", "Parietal", "Occipital")
	nasa_data <- lobesToWholeBrain_WeightByVol(nasa_vol, nasa_data, lobe_short_colnames, type)
} else if (type == "vol") {
	nasa_data <- averageLeftAndRight_Vol(nasa_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	# create lobular and whole brain metrics
	nasa_data <- lobeVolumes(nasa_data, ROI_ListofLists)
	nasa_data$BasGang_Vol <- nasa_data$BasGang_Vol*2
	nasa_data$Limbic_Vol <- nasa_data$Limbic_Vol*2
	nasa_data$FrontOrb_Vol <- nasa_data$FrontOrb_Vol*2
	nasa_data$FrontDors_Vol <- nasa_data$FrontDors_Vol*2
	nasa_data$Temporal_Vol <- nasa_data$Temporal_Vol*2
	nasa_data$Parietal_Vol <- nasa_data$Parietal_Vol*2
	nasa_data$Occipital_Vol <- nasa_data$Occipital_Vol*2
	nasa_data$GMV <- nasa_data$BasGang_Vol + nasa_data$Limbic_Vol + nasa_data$FrontOrb_Vol + nasa_data$FrontDors_Vol + nasa_data$Temporal_Vol + nasa_data$Parietal_Vol + nasa_data$Occipital_Vol
}

# Create group variable
crew_vec <- grep("concordia", nasa_data[,"subject_1"])
control_vec <- grep("DLR", nasa_data[,"subject_1"])
nasa_data$group <- NA
num_rows = nrow(nasa_data)
for (i in 1:num_rows) {
	if (i %in% crew_vec) {
		nasa_data[i, "group"] <- "Crew"
	} else if (i %in% control_vec) {
		nasa_data[i, "group"] <- "Control"
	} else {
		nasa_data[i, "group"] <- "Phantom"
	}
}

##### Create a dataframe of just crew and controls
#crewcontrol_data <- nasa_data[nasa_data$group != "Phantom", ]
#crewcontrol_data$subject_1 <- factor(crewcontrol_data$subject_1)
#crewcontrol_data$group <- factor(crewcontrol_data$group)
#crewcontrol_data$winterover <- factor(crewcontrol_data$winterover)


if (type == "gmd") {
	write.csv(nasa_data, file= "/home/ebutler/erb_data/nasa/nasa_OASISLobeGlobal_gmd.csv", row.names=FALSE)
} else if (type == "vol") {
	write.csv(nasa_data, file= "/home/ebutler/erb_data/nasa/nasa_OASISLobeGlobal_vol.csv", row.names=FALSE)
}


############################ Hippocampus ############################

nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_hippo_jlfcllite.csv", header=TRUE)
nasa_data$winterover <- as.factor(nasa_data$winterover)
nasa_data$subject_1 <- as.factor(nasa_data$subject_1)
nasa_data$Time <- as.factor(nasa_data$Time)

volcol <- c("winterover", "subject_1", "Time", "vol_princeton_L_CA1", "vol_princeton_L_CA23", "vol_princeton_L_DG", "vol_princeton_L_ERC", "vol_princeton_L_PHC", "vol_princeton_L_PRC", "vol_princeton_L_SUB", "vol_princeton_R_CA1", "vol_princeton_R_CA23", "vol_princeton_R_DG", "vol_princeton_R_ERC", "vol_princeton_R_PHC", "vol_princeton_R_PRC", "vol_princeton_R_SUB")

nasa_pixdim <- read.csv("/home/ebutler/erb_data/nasa/nasa_pixdim_hippo.csv", header=T)

nasa_data <- nasa_data[, volcol]
nasa_data_mm3 <- nasa_data
for (i in 1:nrow(nasa_data_mm3)) {
	winterover <- as.character(nasa_data_mm3[i, "winterover"])
	subject_1 <- as.character(nasa_data_mm3[i, "subject_1"])
	Time <- as.character(nasa_data_mm3[i, "Time"])
	# pixel product
	subj_rownum <- as.numeric(rownames(nasa_pixdim[nasa_pixdim$winterover == winterover & nasa_pixdim$subject_1 == subject_1 & nasa_pixdim$Time == Time,])) 
	pixvolmm3 <- nasa_pixdim[subj_rownum, "pixdim1"] * nasa_pixdim[subj_rownum, "pixdim2"] * nasa_pixdim[subj_rownum, "pixdim3"]
	for (j in 4:ncol(nasa_data_mm3)) {
		nasa_data_mm3[i, j] <- nasa_data_mm3[i, j] * pixvolmm3
	}
}

nasa_data_mm3$vol_princeton_L_hippo <- nasa_data_mm3$vol_princeton_L_CA1 + nasa_data_mm3$vol_princeton_L_CA23 + nasa_data_mm3$vol_princeton_L_DG + nasa_data_mm3$vol_princeton_L_ERC + nasa_data_mm3$vol_princeton_L_PHC + nasa_data_mm3$vol_princeton_L_PRC + nasa_data_mm3$vol_princeton_L_SUB
nasa_data_mm3$vol_princeton_R_hippo <- nasa_data_mm3$vol_princeton_R_CA1 + nasa_data_mm3$vol_princeton_R_CA23 + nasa_data_mm3$vol_princeton_R_DG + nasa_data_mm3$vol_princeton_R_ERC + nasa_data_mm3$vol_princeton_R_PHC + nasa_data_mm3$vol_princeton_R_PRC + nasa_data_mm3$vol_princeton_R_SUB
nasa_data_mm3 <- averageLeftAndRight_Vol(nasa_data_mm3, "_R_", "_L_", "_ave_")

# Put in scanner
nasa_data_mm3 <- scanningSite_NASAAntartica(nasa_data_mm3)

# Create group variable
crew_vec <- grep("concordia", nasa_data_mm3[,"subject_1"])
control_vec <- grep("DLR", nasa_data_mm3[,"subject_1"])
nasa_data_mm3$group <- NA
num_rows = nrow(nasa_data_mm3)
for (i in 1:num_rows) {
	if (i %in% crew_vec) {
		nasa_data_mm3[i, "group"] <- "Crew"
	} else if (i %in% control_vec) {
		nasa_data_mm3[i, "group"] <- "Control"
	} else {
		nasa_data_mm3[i, "group"] <- "Phantom"
	}
}

nasa_data_mm3$vol_princeton_tot_hippo <- nasa_data_mm3$vol_princeton_R_hippo + nasa_data_mm3$vol_princeton_L_hippo
nasa_data_mm3$vol_princeton_tot_CA1 <- nasa_data_mm3$vol_princeton_R_CA1 + nasa_data_mm3$vol_princeton_L_CA1
nasa_data_mm3$vol_princeton_tot_CA23 <- nasa_data_mm3$vol_princeton_R_CA23 + nasa_data_mm3$vol_princeton_L_CA23
nasa_data_mm3$vol_princeton_tot_DG <- nasa_data_mm3$vol_princeton_R_DG + nasa_data_mm3$vol_princeton_L_DG
nasa_data_mm3$vol_princeton_tot_ERC <- nasa_data_mm3$vol_princeton_R_ERC + nasa_data_mm3$vol_princeton_L_ERC
nasa_data_mm3$vol_princeton_tot_PHC <- nasa_data_mm3$vol_princeton_R_PHC + nasa_data_mm3$vol_princeton_L_PHC
nasa_data_mm3$vol_princeton_tot_PRC <- nasa_data_mm3$vol_princeton_R_PRC + nasa_data_mm3$vol_princeton_L_PRC
nasa_data_mm3$vol_princeton_tot_SUB <- nasa_data_mm3$vol_princeton_R_SUB + nasa_data_mm3$vol_princeton_L_SUB


write.csv(nasa_data_mm3, file="/home/ebutler/erb_data/nasa/nasa_raw_hippo_vol.csv", row.names=FALSE)






