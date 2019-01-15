### This script creates csvs of transformed variables 
### 
### Ellyn Butler
### December 10, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Read in the data
if (type == "cort") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_CT.csv", header=TRUE)
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=TRUE)
} else if (type == "gmd") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv", header=TRUE)
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=TRUE)
} else if (type == "vol") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=TRUE)
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
	nasa_data$AHGMV <- nasa_data$BasGang_Vol + nasa_data$Limbic_Vol + nasa_data$FrontOrb_Vol + nasa_data$FrontDors_Vol + nasa_data$Temporal_Vol + nasa_data$Parietal_Vol + nasa_data$Occipital_Vol
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

##### Create dataframe of phantom means and sds
phantom_data <- nasa_data[nasa_data$group == "Phantom", ]
phantom_data <- phantom_data[phantom_data$subject_1 != "BJ", ]
phantom_data$subject_1 <- factor(phantom_data$subject_1)
# get the columns that are ROIs
col_names <- colnames(phantom_data)
nonroicols <- c("winterover", "subject_1", "Time", "scanner", "group")
TF_vec <- c()
for (i in 1:length(col_names)) {
	if (col_names[[i]] %in% nonroicols) {
		TF_vec <- c(TF_vec, FALSE)
	} else {
		TF_vec <- c(TF_vec, TRUE)
	}
}
roicols <- subset(col_names, TF_vec)

# phantom summary
phantom_summary <- data.frame(matrix(NA, nrow=length(roicols), ncol=9))
colnames(phantom_summary) <- c("ROI", "Mean_CGN2014", "SD_CGN2014", "Mean_CHR", "SD_CHR", "Mean_HOB", "SD_HOB", "Mean_CGN2017", "SD_CGN2017")
phantom_summary$ROI <- roicols
for (i in 1:length(roicols)) {
	roi <- roicols[[i]]
	# CGN 2014
	phantom_summary[i, "Mean_CGN2014"] <- mean(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t1", roi])
	phantom_summary[i, "SD_CGN2014"] <- sd(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t1", roi])
	# CHR
	phantom_summary[i, "Mean_CHR"] <- mean(phantom_data[phantom_data$scanner == "CHR", roi])
	phantom_summary[i, "SD_CHR"] <- sd(phantom_data[phantom_data$scanner == "CHR", roi])
	# HOB
	phantom_summary[i, "Mean_HOB"] <- mean(phantom_data[phantom_data$scanner == "HOB", roi])
	phantom_summary[i, "SD_HOB"] <- sd(phantom_data[phantom_data$scanner == "HOB", roi])
	# CGN 2017
	phantom_summary[i, "Mean_CGN2017"] <- mean(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t4", roi])
	phantom_summary[i, "SD_CGN2017"] <- sd(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t4", roi])
}

##### Create a dataframe of just crew and controls
crewcontrol_data <- nasa_data[nasa_data$group != "Phantom", ]
crewcontrol_data$subject_1 <- factor(crewcontrol_data$subject_1)
crewcontrol_data$group <- factor(crewcontrol_data$group)
crewcontrol_data$winterover <- factor(crewcontrol_data$winterover)

normed_data <- crewcontrol_data
# loop through the subjects
for (i in 1:nrow(normed_data)) {
	# loop through each roi for a subject
	for (j in 1:ncol(normed_data)) {
		# identify the roi
		roi <- colnames(normed_data[j])
		if (roi %in% roicols) {
			if (normed_data[i, "winterover"] == "wo_2015") {
				if (normed_data[i, "scanner"] == "CGN") {
					if (normed_data[i, "group"] == "Crew") {
						normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2014"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2014"] 
					} else { # Controls
						if (normed_data[i, "Time"] == "t0") { # Use Phantoms CGN 2014
							normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2014"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2014"]
						} else { # t18, Use Phantoms CGN 2017
							normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2017"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2017"]
						}
					}
				} else if (normed_data[i, "scanner"] == "CHR") {
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CHR"])/phantom_summary[phantom_summary$ROI == roi, "SD_CHR"]
				} else { # HOB
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_HOB"])/phantom_summary[phantom_summary$ROI == roi, "SD_HOB"]				
				}
			} else { # wo_2016
				if (normed_data[i, "scanner"] == "CGN") {
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2017"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2017"]
				} else if (normed_data[i, "scanner"] == "CHR") {
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CHR"])/phantom_summary[phantom_summary$ROI == roi, "SD_CHR"]
				} else { # HOB
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_HOB"])/phantom_summary[phantom_summary$ROI == roi, "SD_HOB"]				
				}			
			}	
		}
	}
}

if (type == "gmd") {
	write.csv(normed_data, file= "/home/ebutler/erb_data/nasa/nasa_normedMeanSD_brain_gmd.csv", row.names=FALSE)
} else if (type == "vol") {
	write.csv(normed_data, file= "/home/ebutler/erb_data/nasa/nasa_normedMeanSD_brain_vol.csv", row.names=FALSE)
}

# find number of 0s in nasa_data, and the columns to which they belong
numzeros <- 0
colzeros <- c()
for (i in 1:nrow(nasa_data)) {
	for (j in 1:ncol(nasa_data)) {
		if (nasa_data[i, j] == 0) {
			numzeros = numzeros + 1
			col_name <- colnames(nasa_data)[j]
			if (!(col_name %in% colzeros)) {
				colzeros <- c(colzeros, col_name)
			}
		}
	}
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


##### Create dataframe of phantom means and sds
phantom_data_mm3 <- nasa_data_mm3[nasa_data_mm3$group == "Phantom", ]
phantom_data_mm3 <- phantom_data_mm3[phantom_data_mm3$subject_1 != "BJ", ]
phantom_data_mm3$subject_1 <- factor(phantom_data_mm3$subject_1)
# get the columns that are ROIs
col_names <- colnames(phantom_data_mm3)
nonroicols <- c("winterover", "subject_1", "Time", "scanner", "group")
TF_vec <- c()
for (i in 1:length(col_names)) {
	if (col_names[[i]] %in% nonroicols) {
		TF_vec <- c(TF_vec, FALSE)
	} else {
		TF_vec <- c(TF_vec, TRUE)
	}
}
roicols <- subset(col_names, TF_vec)

# phantom summary
phantom_summary <- data.frame(matrix(NA, nrow=length(roicols), ncol=9))
colnames(phantom_summary) <- c("ROI", "Mean_CGN2014", "SD_CGN2014", "Mean_CHR", "SD_CHR", "Mean_HOB", "SD_HOB", "Mean_CGN2017", "SD_CGN2017")
phantom_summary$ROI <- roicols
for (i in 1:length(roicols)) {
	roi <- roicols[[i]]
	# CGN 2014
	phantom_summary[i, "Mean_CGN2014"] <- mean(phantom_data_mm3[phantom_data_mm3$scanner == "CGN" & phantom_data_mm3$Time == "t1", roi])
	phantom_summary[i, "SD_CGN2014"] <- sd(phantom_data_mm3[phantom_data_mm3$scanner == "CGN" & phantom_data_mm3$Time == "t1", roi])
	# CHR
	phantom_summary[i, "Mean_CHR"] <- mean(phantom_data_mm3[phantom_data_mm3$scanner == "CHR", roi])
	phantom_summary[i, "SD_CHR"] <- sd(phantom_data_mm3[phantom_data_mm3$scanner == "CHR", roi])
	# HOB
	phantom_summary[i, "Mean_HOB"] <- mean(phantom_data_mm3[phantom_data_mm3$scanner == "HOB", roi])
	phantom_summary[i, "SD_HOB"] <- sd(phantom_data_mm3[phantom_data_mm3$scanner == "HOB", roi])
	# CGN 2017
	phantom_summary[i, "Mean_CGN2017"] <- mean(phantom_data_mm3[phantom_data_mm3$scanner == "CGN" & phantom_data_mm3$Time == "t4", roi])
	phantom_summary[i, "SD_CGN2017"] <- sd(phantom_data_mm3[phantom_data_mm3$scanner == "CGN" & phantom_data_mm3$Time == "t4", roi])
}

##### Create a dataframe of just crew and controls
crewcontrol_data_mm3 <- nasa_data_mm3[nasa_data_mm3$group != "Phantom", ]
crewcontrol_data_mm3$subject_1 <- factor(crewcontrol_data_mm3$subject_1)
crewcontrol_data_mm3$group <- factor(crewcontrol_data_mm3$group)
crewcontrol_data_mm3$winterover <- factor(crewcontrol_data_mm3$winterover)

normed_data <- crewcontrol_data_mm3
# loop through the subjects
for (i in 1:nrow(normed_data)) {
	# loop through each roi for a subject
	for (j in 1:ncol(normed_data)) {
		# identify the roi
		roi <- colnames(normed_data[j])
		if (roi %in% roicols) {
			if (normed_data[i, "winterover"] == "wo_2015") {
				if (normed_data[i, "scanner"] == "CGN") {
					if (normed_data[i, "group"] == "Crew") {
						normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2014"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2014"] 
					} else { # Controls
						if (normed_data[i, "Time"] == "t0") { # Use Phantoms CGN 2014
							normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2014"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2014"]
						} else { # t18, Use Phantoms CGN 2017
							normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2017"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2017"]
						}
					}
				} else if (normed_data[i, "scanner"] == "CHR") {
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CHR"])/phantom_summary[phantom_summary$ROI == roi, "SD_CHR"]
				} else { # HOB
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_HOB"])/phantom_summary[phantom_summary$ROI == roi, "SD_HOB"]				
				}
			} else { # wo_2016
				if (normed_data[i, "scanner"] == "CGN") {
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN2017"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN2017"]
				} else if (normed_data[i, "scanner"] == "CHR") {
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CHR"])/phantom_summary[phantom_summary$ROI == roi, "SD_CHR"]
				} else { # HOB
					normed_data[i, roi] <- (normed_data[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_HOB"])/phantom_summary[phantom_summary$ROI == roi, "SD_HOB"]				
				}			
			}	
		}
	}
}


write.csv(normed_data, file="/home/ebutler/erb_data/nasa/nasa_normedMeanSD_hippo_vol.csv", row.names=FALSE)
write.csv(phantom_summary, file= "/home/ebutler/erb_data/nasa/nasa_phantomsummary_hippo.csv", row.names=FALSE)






