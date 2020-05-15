### This script creates whole-brain metrics (cortical thickness, gray matter density and volume) for all
### subjects, and then creates a table of means, SEs and Ns to illustrate the relationship between scanner
### and time effects
###
### Ellyn Butler
### December 3, 2018

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
if (type == "cort") {
	nasa_data <- scanningSite_NASAAntartica(nasa_data)
	nasa_vol <- scanningSite_NASAAntartica(nasa_vol)
} else if (type == "gmd") {
	nasa_data <- scanningSite_NASAAntartica(nasa_data)
	nasa_vol <- scanningSite_NASAAntartica(nasa_vol)
} else if (type == "vol") {
	nasa_data <- scanningSite_NASAAntartica(nasa_data)
} 

# Create new time variable (1, 2, 3)
if (type == "cort" | type == "gmd") {
	# nasa_data
	nasa_data$ScanOrder <- NA
	for (row in 1:nrow(nasa_data)) {
		if (nasa_data[row, "Time"] == "t0") {
			nasa_data[row, "ScanOrder"] <- "First"
		} else if (nasa_data[row, "Time"] == "t12") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_data[row, "Time"] == "t18") {
			nasa_data[row, "ScanOrder"] <- "Third"
		} else if (nasa_data[row, "Time"] == "t1") {
			nasa_data[row, "ScanOrder"] <- "First"
		} else if (nasa_data[row, "Time"] == "t2") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_data[row, "Time"] == "t3") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_data[row, "Time"] == "t4") {
			nasa_data[row, "ScanOrder"] <- "Third"
		}
		
	}
	nasa_data$ScanOrder <- as.factor(nasa_data$ScanOrder)
	# nasa_vol
	nasa_vol$ScanOrder <- NA
	for (row in 1:nrow(nasa_vol)) {
		if (nasa_vol[row, "Time"] == "t0") {
			nasa_vol[row, "ScanOrder"] <- "First"
		} else if (nasa_vol[row, "Time"] == "t12") {
			nasa_vol[row, "ScanOrder"] <- "Second"
		} else if (nasa_vol[row, "Time"] == "t18") {
			nasa_vol[row, "ScanOrder"] <- "Third"
		} else if (nasa_vol[row, "Time"] == "t1") {
			nasa_vol[row, "ScanOrder"] <- "First"
		} else if (nasa_vol[row, "Time"] == "t2") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_vol[row, "Time"] == "t3") {
			nasa_vol[row, "ScanOrder"] <- "Second"
		} else if (nasa_vol[row, "Time"] == "t4") {
			nasa_vol[row, "ScanOrder"] <- "Third"
		}
		
	}
	nasa_vol$ScanOrder <- as.factor(nasa_vol$ScanOrder)
} else if (type == "vol") {
	# nasa_data
	nasa_data$ScanOrder <- NA
	for (row in 1:nrow(nasa_data)) {
		if (nasa_data[row, "Time"] == "t0") {
			nasa_data[row, "ScanOrder"] <- "First"
		} else if (nasa_data[row, "Time"] == "t12") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_data[row, "Time"] == "t18") {
			nasa_data[row, "ScanOrder"] <- "Third"
		} else if (nasa_data[row, "Time"] == "t1") {
			nasa_data[row, "ScanOrder"] <- "First"
		} else if (nasa_data[row, "Time"] == "t2") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_data[row, "Time"] == "t3") {
			nasa_data[row, "ScanOrder"] <- "Second"
		} else if (nasa_data[row, "Time"] == "t4") {
			nasa_data[row, "ScanOrder"] <- "Third"
		}
		
	}
	nasa_data$ScanOrder <- as.factor(nasa_data$ScanOrder)
} 

# Calculate whole-brain metrics
if (type == "cort") {
	# cort
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	nasa_vol <- averageLeftAndRight_Vol(nasa_vol, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(nasa_vol), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists_Vol <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists_Vol <- removeUnderScore(ROI_ListofLists_Vol)
	ROI_ListofLists_Vol$BasGang <- NULL
	ROI_ListofLists_Vol$Limbic <- NULL
	ROI_ListofLists_Vol$Cerebellum <- NULL
	nasa_vol <- lobeVolumes(nasa_vol, ROI_ListofLists_Vol, lastList=TRUE) 
	# create lobular definitions
	nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Vol, ROI_ListofLists, lastList=TRUE, type="cort")
	# create whole brain cort
	nasa_vol$regionalTotalVolume <- nasa_vol$FrontOrb_Vol + nasa_vol$FrontDors_Vol + nasa_vol$Temporal_Vol + nasa_vol$Parietal_Vol + nasa_vol$Occipital_Vol
	lobe_short_colnames <- c("FrontOrb", "FrontDors", "Temporal", "Parietal", "Occipital")
	nasa_data <- lobesToWholeBrain_WeightByVol(nasa_vol, nasa_data, lobe_short_colnames, type)
} else if (type == "gmd") {
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

# Subset nasa_data for the patterns in scanners
cgncgncgn <- c("DLR_004", "DLR_005", "DLR_007", "DLR_008", "DLR_009", "DLR_011", "DLR_013", "DLR_102", "DLR_103", "DLR_105", "DLR_107", "DLR_108", "DLR_111", "DLR_112", "DLR_113")
CGN_CGN_CGN <- nasa_data[nasa_data$subject_1 %in% cgncgncgn, ]

cgnhobcgn <- c("concordia_001", "concordia_002", "concordia_003", "concordia_005", "concordia_008", "concordia_009", "concordia_011", "concordia_012", "concordia_013", "concordia_104", "concordia_111", "BM", "EA", "GR", "PK")
CGN_HOB_CGN <- nasa_data[nasa_data$subject_1 %in% cgnhobcgn, ]
CGN_HOB_CGN <- CGN_HOB_CGN[CGN_HOB_CGN$scanner != "CHR", ]

cgnchrcgn <- c("concordia_004", "concordia_006", "concordia_105", "concordia_108", "concordia_112", "BM", "EA", "GR", "PK")
CGN_CHR_CGN <- nasa_data[nasa_data$subject_1 %in% cgnchrcgn, ]
CGN_CHR_CGN <- CGN_CHR_CGN[CGN_CHR_CGN$scanner != "HOB", ]

chrchrcgn <- c("concordia_007")
CHR_CHR_CGN <- nasa_data[nasa_data$subject_1 %in% chrchrcgn, ]

hobchrcgn <- c("concordia_010")
HOB_CHR_CGN <- nasa_data[nasa_data$subject_1 %in% hobchrcgn, ]


# Subset for whole-brain, winterover
if (type == "cort") {
	# CGN-CGN-CGN
	CGN_CGN_CGN2 <- CGN_CGN_CGN[, c("group", "subject_1", "ScanOrder", "ACT")]
	cgncgncgn_meanSENDF <- createMeanSENDF(CGN_CGN_CGN2, c("T1 - CGN", "T2 - CGN", "T3 - CGN"), metric="ACT")

	# ---------------------------------------------------------------------------- #
	### CGN-HOB-CGN
	# ACT
	ACT_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "ACT")] # Very consistent
	ACTsummary <- summarySE(ACT_CGN_HOB_CGN2, measurevar="ACT", groupvars=c("group", "ScanOrder"))
	ACTsummary$ScanOrder <- factor(ACTsummary$ScanOrder)
	ACTsummary$group <- factor(ACTsummary$group)
	ACT_cgnhobcgn_meanSENDF <- createMeanSENDF(ACT_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="ACT")
	ACT_plot <- ggplot(ACTsummary, aes(x=ScanOrder, y=ACT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("ACT (+/- SE)") +
    		geom_errorbar(aes(ymin=ACT-se, ymax=ACT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Average Cortical Thickness - CGN-HOB-CGN")
	# FrontOrb_CT
	FrontOrb_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "FrontOrb_CT")] # Minor Up-Down-Up present in Crew but not Phantoms
	FrontOrbsummary <- summarySE(FrontOrb_CGN_HOB_CGN2, measurevar="FrontOrb_CT", groupvars=c("group", "ScanOrder"))
	FrontOrbsummary$ScanOrder <- factor(FrontOrbsummary$ScanOrder)
	FrontOrbsummary$group <- factor(FrontOrbsummary$group)
	FrontOrb_cgnhobcgn_meanSENDF <- createMeanSENDF(FrontOrb_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="FrontOrb_CT")
	FrontOrb_plot <- ggplot(FrontOrbsummary, aes(x=ScanOrder, y=FrontOrb_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontOrb (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontOrb_CT-se, ymax=FrontOrb_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontOrb Cortical Thickness - CGN-HOB-CGN")
	# FrontDors_CT
	FrontDors_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "FrontDors_CT")] # HUGE Down-Up-Down in both
	FrontDorssummary <- summarySE(FrontDors_CGN_HOB_CGN2, measurevar="FrontDors_CT", groupvars=c("group", "ScanOrder"))
	FrontDorssummary$ScanOrder <- factor(FrontDorssummary$ScanOrder)
	FrontDorssummary$group <- factor(FrontDorssummary$group)
	FrontDors_cgnhobcgn_meanSENDF <- createMeanSENDF(FrontDors_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="FrontDors_CT")
	FrontDors_plot <- ggplot(FrontDorssummary, aes(x=ScanOrder, y=FrontDors_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontDors (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontDors_CT-se, ymax=FrontDors_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontDors Cortical Thickness - CGN-HOB-CGN")
	# Temporal_CT
	Temporal_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Temporal_CT")] # Large Up-Down-Up present in both
	Temporalsummary <- summarySE(Temporal_CGN_HOB_CGN2, measurevar="Temporal_CT", groupvars=c("group", "ScanOrder"))
	Temporalsummary$ScanOrder <- factor(Temporalsummary$ScanOrder)
	Temporalsummary$group <- factor(Temporalsummary$group)
	Temporal_cgnhobcgn_meanSENDF <- createMeanSENDF(Temporal_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Temporal_CT")
	Temporal_plot <- ggplot(Temporalsummary, aes(x=ScanOrder, y=Temporal_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Temporal (+/- SE)") +
    		geom_errorbar(aes(ymin=Temporal_CT-se, ymax=Temporal_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Temporal Cortical Thickness - CGN-HOB-CGN")
	# Parietal_CT
	Parietal_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Parietal_CT")] # Pretty consistent
	Parietalsummary <- summarySE(Parietal_CGN_HOB_CGN2, measurevar="Parietal_CT", groupvars=c("group", "ScanOrder"))
	Parietalsummary$ScanOrder <- factor(Parietalsummary$ScanOrder)
	Parietalsummary$group <- factor(Parietalsummary$group)
	Parietal_cgnhobcgn_meanSENDF <- createMeanSENDF(Parietal_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Parietal_CT")
	Parietal_plot <- ggplot(Parietalsummary, aes(x=ScanOrder, y=Parietal_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Parietal (+/- SE)") +
    		geom_errorbar(aes(ymin=Parietal_CT-se, ymax=Parietal_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Parietal Cortical Thickness - CGN-HOB-CGN")
	# Occipital_CT
	Occipital_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Occipital_CT")] # Minor Up-Down-Up present in Crew but not Phantoms
	Occipitalsummary <- summarySE(Occipital_CGN_HOB_CGN2, measurevar="Occipital_CT", groupvars=c("group", "ScanOrder"))
	Occipitalsummary$ScanOrder <- factor(Occipitalsummary$ScanOrder)
	Occipitalsummary$group <- factor(Occipitalsummary$group)
	Occipital_cgnhobcgn_meanSENDF <- createMeanSENDF(Occipital_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Occipital_CT")
	Occipital_plot <- ggplot(Occipitalsummary, aes(x=ScanOrder, y=Occipital_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Occipital (+/- SE)") +
    		geom_errorbar(aes(ymin=Occipital_CT-se, ymax=Occipital_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Occipital Cortical Thickness - CGN-HOB-CGN")
	pdf(file = "/home/ebutler/nasa_plots/CGNHOBCGN_cort.pdf")
	print(ACT_plot)
	print(FrontOrb_plot)
	print(FrontDors_plot)
	print(Temporal_plot)
	print(Parietal_plot)
	print(Occipital_plot)
	dev.off()
	### CGN-CHR-CGN
	# ACT
	ACT_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "ACT")] 
	ACTsummary <- summarySE(ACT_CGN_CHR_CGN2, measurevar="ACT", groupvars=c("group", "ScanOrder"))
	ACTsummary$ScanOrder <- factor(ACTsummary$ScanOrder)
	ACTsummary$group <- factor(ACTsummary$group)
	ACT_cgnchrcgn_meanSENDF <- createMeanSENDF(ACT_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="ACT")
	ACT_plot <- ggplot(ACTsummary, aes(x=ScanOrder, y=ACT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("ACT (+/- SE)") +
    		geom_errorbar(aes(ymin=ACT-se, ymax=ACT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Average Cortical Thickness - CGN-CHR-CGN")
	# FrontOrb_CT
	FrontOrb_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "FrontOrb_CT")] 
	FrontOrbsummary <- summarySE(FrontOrb_CGN_CHR_CGN2, measurevar="FrontOrb_CT", groupvars=c("group", "ScanOrder"))
	FrontOrbsummary$ScanOrder <- factor(FrontOrbsummary$ScanOrder)
	FrontOrbsummary$group <- factor(FrontOrbsummary$group)
	FrontOrb_cgnchrcgn_meanSENDF <- createMeanSENDF(FrontOrb_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="FrontOrb_CT")
	FrontOrb_plot <- ggplot(FrontOrbsummary, aes(x=ScanOrder, y=FrontOrb_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontOrb (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontOrb_CT-se, ymax=FrontOrb_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontOrb Cortical Thickness - CGN-CHR-CGN")
	# FrontDors_CT
	FrontDors_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "FrontDors_CT")]
	FrontDorssummary <- summarySE(FrontDors_CGN_CHR_CGN2, measurevar="FrontDors_CT", groupvars=c("group", "ScanOrder"))
	FrontDorssummary$ScanOrder <- factor(FrontDorssummary$ScanOrder)
	FrontDorssummary$group <- factor(FrontDorssummary$group)
	FrontDors_cgnchrcgn_meanSENDF <- createMeanSENDF(FrontDors_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="FrontDors_CT")
	FrontDors_plot <- ggplot(FrontDorssummary, aes(x=ScanOrder, y=FrontDors_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontDors (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontDors_CT-se, ymax=FrontDors_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontDors Cortical Thickness - CGN-CHR-CGN")
	# Temporal_CT
	Temporal_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Temporal_CT")] 
	Temporalsummary <- summarySE(Temporal_CGN_CHR_CGN2, measurevar="Temporal_CT", groupvars=c("group", "ScanOrder"))
	Temporalsummary$ScanOrder <- factor(Temporalsummary$ScanOrder)
	Temporalsummary$group <- factor(Temporalsummary$group)
	Temporal_cgnchrcgn_meanSENDF <- createMeanSENDF(Temporal_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Temporal_CT")
	Temporal_plot <- ggplot(Temporalsummary, aes(x=ScanOrder, y=Temporal_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Temporal (+/- SE)") +
    		geom_errorbar(aes(ymin=Temporal_CT-se, ymax=Temporal_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Temporal Cortical Thickness - CGN-CHR-CGN")
	# Parietal_CT
	Parietal_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Parietal_CT")] 
	Parietalsummary <- summarySE(Parietal_CGN_CHR_CGN2, measurevar="Parietal_CT", groupvars=c("group", "ScanOrder"))
	Parietalsummary$ScanOrder <- factor(Parietalsummary$ScanOrder)
	Parietalsummary$group <- factor(Parietalsummary$group)
	Parietal_cgnchrcgn_meanSENDF <- createMeanSENDF(Parietal_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Parietal_CT")
	Parietal_plot <- ggplot(Parietalsummary, aes(x=ScanOrder, y=Parietal_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Parietal (+/- SE)") +
    		geom_errorbar(aes(ymin=Parietal_CT-se, ymax=Parietal_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Parietal Cortical Thickness - CGN-CHR-CGN")
	# Occipital_CT
	Occipital_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Occipital_CT")]
	Occipitalsummary <- summarySE(Occipital_CGN_CHR_CGN2, measurevar="Occipital_CT", groupvars=c("group", "ScanOrder"))
	Occipitalsummary$ScanOrder <- factor(Occipitalsummary$ScanOrder)
	Occipitalsummary$group <- factor(Occipitalsummary$group)
	Occipital_cgnchrcgn_meanSENDF <- createMeanSENDF(Occipital_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Occipital_CT")
	Occipital_plot <- ggplot(Occipitalsummary, aes(x=ScanOrder, y=Occipital_CT, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Occipital (+/- SE)") +
    		geom_errorbar(aes(ymin=Occipital_CT-se, ymax=Occipital_CT+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Occipital Cortical Thickness - CGN-CHR-CGN")
	pdf(file = "/home/ebutler/nasa_plots/CGNCHRCGN_cort.pdf")
	print(ACT_plot)
	print(FrontOrb_plot)
	print(FrontDors_plot)
	print(Temporal_plot)
	print(Parietal_plot)
	print(Occipital_plot)
	dev.off()

	# ---------------------------------------------------------------------------- #


	# CHR-CHR-CGN
	CHR_CHR_CGN2 <- CHR_CHR_CGN[, c("group", "subject_1", "ScanOrder", "ACT")]
	chrchrcgn_meanSENDF <- createMeanSENDF(CHR_CHR_CGN2, c("T1 - CHR", "T2 - CHR", "T3 - CGN"), metric="ACT")

	# HOB-CHR-CGN
	HOB_CHR_CGN2 <- HOB_CHR_CGN[, c("group", "subject_1", "ScanOrder", "ACT")]
	hobchrcgn_meanSENDF <- createMeanSENDF(HOB_CHR_CGN2, c("T1 - HOB", "T2 - CHR", "T3 - CGN"), metric="ACT")
} else if (type == "gmd") {
	# CGN-CGN-CGN
	CGN_CGN_CGN2 <- CGN_CGN_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	cgncgncgn_meanSENDF <- createMeanSENDF(CGN_CGN_CGN2, c("T1 - CGN", "T2 - CGN", "T3 - CGN"), metric="AGMD")

	# CGN-HOB-CGN
	CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	cgnhobcgn_meanSENDF <- createMeanSENDF(CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="AGMD")

	# CGN-CHR-CGN
	CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	cgnchrcgn_meanSENDF <- createMeanSENDF(CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="AGMD")

	# ---------------------------------------------------------------------------- #
	### CGN-HOB-CGN
	# AGMD
	AGMD_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")] 
	AGMDsummary <- summarySE(AGMD_CGN_HOB_CGN2, measurevar="AGMD", groupvars=c("group", "ScanOrder"))
	AGMDsummary$ScanOrder <- factor(AGMDsummary$ScanOrder)
	AGMDsummary$group <- factor(AGMDsummary$group)
	AGMD_cgnhobcgn_meanSENDF <- createMeanSENDF(AGMD_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="AGMD")
	AGMD_plot <- ggplot(AGMDsummary, aes(x=ScanOrder, y=AGMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("AGMD (+/- SE)") +
    		geom_errorbar(aes(ymin=AGMD-se, ymax=AGMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Average Gray Matter Density - CGN-HOB-CGN")
	# BasGang_GMD
	BasGang_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "BasGang_GMD")]
	BasGangsummary <- summarySE(BasGang_CGN_HOB_CGN2, measurevar="BasGang_GMD", groupvars=c("group", "ScanOrder"))
	BasGangsummary$ScanOrder <- factor(BasGangsummary$ScanOrder)
	BasGangsummary$group <- factor(BasGangsummary$group)
	BasGang_cgnhobcgn_meanSENDF <- createMeanSENDF(BasGang_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="BasGang_GMD")
	BasGang_plot <- ggplot(BasGangsummary, aes(x=ScanOrder, y=BasGang_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("BasGang (+/- SE)") +
    		geom_errorbar(aes(ymin=BasGang_GMD-se, ymax=BasGang_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Basal Ganglia Gray Matter Density - CGN-HOB-CGN")
	# Limbic_GMD
	Limbic_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Limbic_GMD")]
	Limbicsummary <- summarySE(Limbic_CGN_HOB_CGN2, measurevar="Limbic_GMD", groupvars=c("group", "ScanOrder"))
	Limbicsummary$ScanOrder <- factor(Limbicsummary$ScanOrder)
	Limbicsummary$group <- factor(Limbicsummary$group)
	Limbic_cgnhobcgn_meanSENDF <- createMeanSENDF(Limbic_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Limbic_GMD")
	Limbic_plot <- ggplot(Limbicsummary, aes(x=ScanOrder, y=Limbic_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Limbic (+/- SE)") +
    		geom_errorbar(aes(ymin=Limbic_GMD-se, ymax=Limbic_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Limbic Gray Matter Density - CGN-HOB-CGN")
	# FrontOrb_GMD
	FrontOrb_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "FrontOrb_GMD")] 
	FrontOrbsummary <- summarySE(FrontOrb_CGN_HOB_CGN2, measurevar="FrontOrb_GMD", groupvars=c("group", "ScanOrder"))
	FrontOrbsummary$ScanOrder <- factor(FrontOrbsummary$ScanOrder)
	FrontOrbsummary$group <- factor(FrontOrbsummary$group)
	FrontOrb_cgnhobcgn_meanSENDF <- createMeanSENDF(FrontOrb_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="FrontOrb_GMD")
	FrontOrb_plot <- ggplot(FrontOrbsummary, aes(x=ScanOrder, y=FrontOrb_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontOrb (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontOrb_GMD-se, ymax=FrontOrb_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontOrb Gray Matter Density - CGN-HOB-CGN")
	# FrontDors_GMD
	FrontDors_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "FrontDors_GMD")] 
	FrontDorssummary <- summarySE(FrontDors_CGN_HOB_CGN2, measurevar="FrontDors_GMD", groupvars=c("group", "ScanOrder"))
	FrontDorssummary$ScanOrder <- factor(FrontDorssummary$ScanOrder)
	FrontDorssummary$group <- factor(FrontDorssummary$group)
	FrontDors_cgnhobcgn_meanSENDF <- createMeanSENDF(FrontDors_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="FrontDors_GMD")
	FrontDors_plot <- ggplot(FrontDorssummary, aes(x=ScanOrder, y=FrontDors_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontDors (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontDors_GMD-se, ymax=FrontDors_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontDors Gray Matter Density - CGN-HOB-CGN")
	# Temporal_GMD
	Temporal_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Temporal_GMD")] 
	Temporalsummary <- summarySE(Temporal_CGN_HOB_CGN2, measurevar="Temporal_GMD", groupvars=c("group", "ScanOrder"))
	Temporalsummary$ScanOrder <- factor(Temporalsummary$ScanOrder)
	Temporalsummary$group <- factor(Temporalsummary$group)
	Temporal_cgnhobcgn_meanSENDF <- createMeanSENDF(Temporal_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Temporal_GMD")
	Temporal_plot <- ggplot(Temporalsummary, aes(x=ScanOrder, y=Temporal_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Temporal (+/- SE)") +
    		geom_errorbar(aes(ymin=Temporal_GMD-se, ymax=Temporal_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Temporal Gray Matter Density - CGN-HOB-CGN")
	# Parietal_GMD
	Parietal_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Parietal_GMD")] 
	Parietalsummary <- summarySE(Parietal_CGN_HOB_CGN2, measurevar="Parietal_GMD", groupvars=c("group", "ScanOrder"))
	Parietalsummary$ScanOrder <- factor(Parietalsummary$ScanOrder)
	Parietalsummary$group <- factor(Parietalsummary$group)
	Parietal_cgnhobcgn_meanSENDF <- createMeanSENDF(Parietal_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Parietal_GMD")
	Parietal_plot <- ggplot(Parietalsummary, aes(x=ScanOrder, y=Parietal_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Parietal (+/- SE)") +
    		geom_errorbar(aes(ymin=Parietal_GMD-se, ymax=Parietal_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Parietal Gray Matter Density - CGN-HOB-CGN")
	# Occipital_GMD
	Occipital_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Occipital_GMD")]
	Occipitalsummary <- summarySE(Occipital_CGN_HOB_CGN2, measurevar="Occipital_GMD", groupvars=c("group", "ScanOrder"))
	Occipitalsummary$ScanOrder <- factor(Occipitalsummary$ScanOrder)
	Occipitalsummary$group <- factor(Occipitalsummary$group)
	Occipital_cgnhobcgn_meanSENDF <- createMeanSENDF(Occipital_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Occipital_GMD")
	Occipital_plot <- ggplot(Occipitalsummary, aes(x=ScanOrder, y=Occipital_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Occipital (+/- SE)") +
    		geom_errorbar(aes(ymin=Occipital_GMD-se, ymax=Occipital_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Occipital Gray Matter Density - CGN-HOB-CGN")
	pdf(file = "/home/ebutler/nasa_plots/CGNHOBCGN_gmd.pdf")
	print(AGMD_plot)
	print(BasGang_plot)
	print(Limbic_plot)
	print(FrontOrb_plot)
	print(FrontDors_plot)
	print(Temporal_plot)
	print(Parietal_plot)
	print(Occipital_plot)
	dev.off()
	### CGN-CHR-CGN
	# AGMD
	AGMD_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")] 
	AGMDsummary <- summarySE(AGMD_CGN_CHR_CGN2, measurevar="AGMD", groupvars=c("group", "ScanOrder"))
	AGMDsummary$ScanOrder <- factor(AGMDsummary$ScanOrder)
	AGMDsummary$group <- factor(AGMDsummary$group)
	AGMD_cgnchrcgn_meanSENDF <- createMeanSENDF(AGMD_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="AGMD")
	AGMD_plot <- ggplot(AGMDsummary, aes(x=ScanOrder, y=AGMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("AGMD (+/- SE)") +
    		geom_errorbar(aes(ymin=AGMD-se, ymax=AGMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Average Gray Matter Density - CGN-CHR-CGN")
	# BasGang_GMD
	BasGang_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "BasGang_GMD")] # Minor Up-Down-Up present in Crew but not Phantoms
	BasGangsummary <- summarySE(BasGang_CGN_CHR_CGN2, measurevar="BasGang_GMD", groupvars=c("group", "ScanOrder"))
	BasGangsummary$ScanOrder <- factor(BasGangsummary$ScanOrder)
	BasGangsummary$group <- factor(BasGangsummary$group)
	BasGang_cgnchrcgn_meanSENDF <- createMeanSENDF(BasGang_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="BasGang_GMD")
	BasGang_plot <- ggplot(BasGangsummary, aes(x=ScanOrder, y=BasGang_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("BasGang (+/- SE)") +
    		geom_errorbar(aes(ymin=BasGang_GMD-se, ymax=BasGang_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("BasGang Gray Matter Density - CGN-CHR-CGN")
	# Limbic_GMD
	Limbic_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Limbic_GMD")] # Minor Up-Down-Up present in Crew but not Phantoms
	Limbicsummary <- summarySE(Limbic_CGN_CHR_CGN2, measurevar="Limbic_GMD", groupvars=c("group", "ScanOrder"))
	Limbicsummary$ScanOrder <- factor(Limbicsummary$ScanOrder)
	Limbicsummary$group <- factor(Limbicsummary$group)
	Limbic_cgnchrcgn_meanSENDF <- createMeanSENDF(Limbic_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Limbic_GMD")
	Limbic_plot <- ggplot(Limbicsummary, aes(x=ScanOrder, y=Limbic_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Limbic (+/- SE)") +
    		geom_errorbar(aes(ymin=Limbic_GMD-se, ymax=Limbic_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Limbic Gray Matter Density - CGN-CHR-CGN")
	# FrontOrb_GMD
	FrontOrb_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "FrontOrb_GMD")] 
	FrontOrbsummary <- summarySE(FrontOrb_CGN_CHR_CGN2, measurevar="FrontOrb_GMD", groupvars=c("group", "ScanOrder"))
	FrontOrbsummary$ScanOrder <- factor(FrontOrbsummary$ScanOrder)
	FrontOrbsummary$group <- factor(FrontOrbsummary$group)
	FrontOrb_cgnchrcgn_meanSENDF <- createMeanSENDF(FrontOrb_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="FrontOrb_GMD")
	FrontOrb_plot <- ggplot(FrontOrbsummary, aes(x=ScanOrder, y=FrontOrb_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontOrb (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontOrb_GMD-se, ymax=FrontOrb_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontOrb Gray Matter Density - CGN-CHR-CGN")
	# FrontDors_GMD
	FrontDors_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "FrontDors_GMD")]
	FrontDorssummary <- summarySE(FrontDors_CGN_CHR_CGN2, measurevar="FrontDors_GMD", groupvars=c("group", "ScanOrder"))
	FrontDorssummary$ScanOrder <- factor(FrontDorssummary$ScanOrder)
	FrontDorssummary$group <- factor(FrontDorssummary$group)
	FrontDors_cgnchrcgn_meanSENDF <- createMeanSENDF(FrontDors_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="FrontDors_GMD")
	FrontDors_plot <- ggplot(FrontDorssummary, aes(x=ScanOrder, y=FrontDors_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontDors (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontDors_GMD-se, ymax=FrontDors_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontDors Gray Matter Density - CGN-CHR-CGN")
	# Temporal_GMD
	Temporal_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Temporal_GMD")] 
	Temporalsummary <- summarySE(Temporal_CGN_CHR_CGN2, measurevar="Temporal_GMD", groupvars=c("group", "ScanOrder"))
	Temporalsummary$ScanOrder <- factor(Temporalsummary$ScanOrder)
	Temporalsummary$group <- factor(Temporalsummary$group)
	Temporal_cgnchrcgn_meanSENDF <- createMeanSENDF(Temporal_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Temporal_GMD")
	Temporal_plot <- ggplot(Temporalsummary, aes(x=ScanOrder, y=Temporal_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Temporal (+/- SE)") +
    		geom_errorbar(aes(ymin=Temporal_GMD-se, ymax=Temporal_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Temporal Gray Matter Density - CGN-CHR-CGN")
	# Parietal_GMD
	Parietal_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Parietal_GMD")] 
	Parietalsummary <- summarySE(Parietal_CGN_CHR_CGN2, measurevar="Parietal_GMD", groupvars=c("group", "ScanOrder"))
	Parietalsummary$ScanOrder <- factor(Parietalsummary$ScanOrder)
	Parietalsummary$group <- factor(Parietalsummary$group)
	Parietal_cgnchrcgn_meanSENDF <- createMeanSENDF(Parietal_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Parietal_GMD")
	Parietal_plot <- ggplot(Parietalsummary, aes(x=ScanOrder, y=Parietal_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Parietal (+/- SE)") +
    		geom_errorbar(aes(ymin=Parietal_GMD-se, ymax=Parietal_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Parietal Gray Matter Density - CGN-CHR-CGN")
	# Occipital_GMD
	Occipital_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Occipital_GMD")]
	Occipitalsummary <- summarySE(Occipital_CGN_CHR_CGN2, measurevar="Occipital_GMD", groupvars=c("group", "ScanOrder"))
	Occipitalsummary$ScanOrder <- factor(Occipitalsummary$ScanOrder)
	Occipitalsummary$group <- factor(Occipitalsummary$group)
	Occipital_cgnchrcgn_meanSENDF <- createMeanSENDF(Occipital_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Occipital_GMD")
	Occipital_plot <- ggplot(Occipitalsummary, aes(x=ScanOrder, y=Occipital_GMD, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Occipital (+/- SE)") +
    		geom_errorbar(aes(ymin=Occipital_GMD-se, ymax=Occipital_GMD+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Occipital Gray Matter Density - CGN-CHR-CGN")
	pdf(file = "/home/ebutler/nasa_plots/CGNCHRCGN_gmd.pdf")
	print(AGMD_plot)
	print(BasGang_plot)
	print(Limbic_plot)
	print(FrontOrb_plot)
	print(FrontDors_plot)
	print(Temporal_plot)
	print(Parietal_plot)
	print(Occipital_plot)
	dev.off()

	# ---------------------------------------------------------------------------- #


	# CHR-CHR-CGN
	CHR_CHR_CGN2 <- CHR_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	chrchrcgn_meanSENDF <- createMeanSENDF(CHR_CHR_CGN2, c("T1 - CHR", "T2 - CHR", "T3 - CGN"), metric="AGMD")

	# HOB-CHR-CGN
	HOB_CHR_CGN2 <- HOB_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	hobchrcgn_meanSENDF <- createMeanSENDF(HOB_CHR_CGN2, c("T1 - HOB", "T2 - CHR", "T3 - CGN"), metric="AGMD")
} else if (type == "vol") {
	### CGN-CGN-CGN
	# AHGMV
	CGN_CGN_CGN2 <- CGN_CGN_CGN[, c("group", "subject_1", "ScanOrder", "AHGMV", "AHCGMV")]
	cgncgncgn_meanSENDF <- createMeanSENDF(CGN_CGN_CGN2, c("T1 - CGN", "T2 - CGN", "T3 - CGN"))
	# AHCGMV
	
	# ---------------------------------------------------------------------------- #
	### CGN-HOB-CGN
	# AHGMV (Average Hemisphere Total Gray Matter Volume)
	AHGMV_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "AHGMV")] # Very consistent
	AHGMVsummary <- summarySE(AHGMV_CGN_HOB_CGN2, measurevar="AHGMV", groupvars=c("group", "ScanOrder"))
	AHGMVsummary$ScanOrder <- factor(AHGMVsummary$ScanOrder)
	AHGMVsummary$group <- factor(AHGMVsummary$group)
	AHGMV_cgnhobcgn_meanSENDF <- createMeanSENDF(AHGMV_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"))
	AHGMV_plot <- ggplot(AHGMVsummary, aes(x=ScanOrder, y=AHGMV, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("AHGMV (+/- SE)") +
    		geom_errorbar(aes(ymin=AHGMV-se, ymax=AHGMV+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Total Gray Matter Volume - CGN-HOB-CGN")
	# AHCGMV
	AHCGMV_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "AHCGMV")] # Very consistent
	AHCGMVsummary <- summarySE(AHCGMV_CGN_HOB_CGN2, measurevar="AHCGMV", groupvars=c("group", "ScanOrder"))
	AHCGMVsummary$ScanOrder <- factor(AHCGMVsummary$ScanOrder)
	AHCGMVsummary$group <- factor(AHCGMVsummary$group)
	AHCGMV_cgnhobcgn_meanSENDF <- createMeanSENDF(AHCGMV_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="AHCGMV")
	AHCGMV_plot <- ggplot(AHCGMVsummary, aes(x=ScanOrder, y=AHCGMV, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("AHCGMV (+/- SE)") +
    		geom_errorbar(aes(ymin=AHCGMV-se, ymax=AHCGMV+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Cortical Gray Matter Volume - CGN-HOB-CGN")
	# BasGang_Vol
	BasGang_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "BasGang_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	BasGangsummary <- summarySE(BasGang_CGN_HOB_CGN2, measurevar="BasGang_Vol", groupvars=c("group", "ScanOrder"))
	BasGangsummary$ScanOrder <- factor(BasGangsummary$ScanOrder)
	BasGangsummary$group <- factor(BasGangsummary$group)
	BasGang_cgnhobcgn_meanSENDF <- createMeanSENDF(BasGang_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="BasGang_Vol")
	BasGang_plot <- ggplot(BasGangsummary, aes(x=ScanOrder, y=BasGang_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("BasGang (+/- SE)") +
    		geom_errorbar(aes(ymin=BasGang_Vol-se, ymax=BasGang_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Basal Ganglia Gray Matter Volume - CGN-HOB-CGN")
	# Limbic_Vol
	Limbic_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Limbic_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	Limbicsummary <- summarySE(Limbic_CGN_HOB_CGN2, measurevar="Limbic_Vol", groupvars=c("group", "ScanOrder"))
	Limbicsummary$ScanOrder <- factor(Limbicsummary$ScanOrder)
	Limbicsummary$group <- factor(Limbicsummary$group)
	Limbic_cgnhobcgn_meanSENDF <- createMeanSENDF(Limbic_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Limbic_Vol")
	Limbic_plot <- ggplot(Limbicsummary, aes(x=ScanOrder, y=Limbic_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Limbic (+/- SE)") +
    		geom_errorbar(aes(ymin=Limbic_Vol-se, ymax=Limbic_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Limbic Gray Matter Volume - CGN-HOB-CGN")
	# FrontOrb_Vol
	FrontOrb_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "FrontOrb_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	FrontOrbsummary <- summarySE(FrontOrb_CGN_HOB_CGN2, measurevar="FrontOrb_Vol", groupvars=c("group", "ScanOrder"))
	FrontOrbsummary$ScanOrder <- factor(FrontOrbsummary$ScanOrder)
	FrontOrbsummary$group <- factor(FrontOrbsummary$group)
	FrontOrb_cgnhobcgn_meanSENDF <- createMeanSENDF(FrontOrb_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="FrontOrb_Vol")
	FrontOrb_plot <- ggplot(FrontOrbsummary, aes(x=ScanOrder, y=FrontOrb_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontOrb (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontOrb_Vol-se, ymax=FrontOrb_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontOrb Gray Matter Volume - CGN-HOB-CGN")
	# FrontDors_Vol
	FrontDors_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "FrontDors_Vol")] # HUGE Down-Up-Down in both
	FrontDorssummary <- summarySE(FrontDors_CGN_HOB_CGN2, measurevar="FrontDors_Vol", groupvars=c("group", "ScanOrder"))
	FrontDorssummary$ScanOrder <- factor(FrontDorssummary$ScanOrder)
	FrontDorssummary$group <- factor(FrontDorssummary$group)
	FrontDors_cgnhobcgn_meanSENDF <- createMeanSENDF(FrontDors_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="FrontDors_Vol")
	FrontDors_plot <- ggplot(FrontDorssummary, aes(x=ScanOrder, y=FrontDors_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontDors (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontDors_Vol-se, ymax=FrontDors_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontDors Gray Matter Volume - CGN-HOB-CGN")
	# Temporal_Vol
	Temporal_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Temporal_Vol")] # Large Up-Down-Up present in both
	Temporalsummary <- summarySE(Temporal_CGN_HOB_CGN2, measurevar="Temporal_Vol", groupvars=c("group", "ScanOrder"))
	Temporalsummary$ScanOrder <- factor(Temporalsummary$ScanOrder)
	Temporalsummary$group <- factor(Temporalsummary$group)
	Temporal_cgnhobcgn_meanSENDF <- createMeanSENDF(Temporal_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Temporal_Vol")
	Temporal_plot <- ggplot(Temporalsummary, aes(x=ScanOrder, y=Temporal_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Temporal (+/- SE)") +
    		geom_errorbar(aes(ymin=Temporal_Vol-se, ymax=Temporal_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Temporal Gray Matter Volume - CGN-HOB-CGN")
	# Parietal_Vol
	Parietal_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Parietal_Vol")] # Pretty consistent
	Parietalsummary <- summarySE(Parietal_CGN_HOB_CGN2, measurevar="Parietal_Vol", groupvars=c("group", "ScanOrder"))
	Parietalsummary$ScanOrder <- factor(Parietalsummary$ScanOrder)
	Parietalsummary$group <- factor(Parietalsummary$group)
	Parietal_cgnhobcgn_meanSENDF <- createMeanSENDF(Parietal_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Parietal_Vol")
	Parietal_plot <- ggplot(Parietalsummary, aes(x=ScanOrder, y=Parietal_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Parietal (+/- SE)") +
    		geom_errorbar(aes(ymin=Parietal_Vol-se, ymax=Parietal_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Parietal Gray Matter Volume - CGN-HOB-CGN")
	# Occipital_Vol
	Occipital_CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "Occipital_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	Occipitalsummary <- summarySE(Occipital_CGN_HOB_CGN2, measurevar="Occipital_Vol", groupvars=c("group", "ScanOrder"))
	Occipitalsummary$ScanOrder <- factor(Occipitalsummary$ScanOrder)
	Occipitalsummary$group <- factor(Occipitalsummary$group)
	Occipital_cgnhobcgn_meanSENDF <- createMeanSENDF(Occipital_CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="Occipital_Vol")
	Occipital_plot <- ggplot(Occipitalsummary, aes(x=ScanOrder, y=Occipital_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Occipital (+/- SE)") +
    		geom_errorbar(aes(ymin=Occipital_Vol-se, ymax=Occipital_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Occipital Gray Matter Volume - CGN-HOB-CGN")
	pdf(file = "/home/ebutler/nasa_plots/CGNHOBCGN_vol.pdf")
	print(AHGMV_plot)
	print(AHCGMV_plot)
	print(BasGang_plot)
	print(Limbic_plot)
	print(FrontOrb_plot)
	print(FrontDors_plot)
	print(Temporal_plot)
	print(Parietal_plot)
	print(Occipital_plot)
	dev.off()
	### CGN-CHR-CGN
	# AHGMV
	AHGMV_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AHGMV")] # Very consistent
	AHGMVsummary <- summarySE(AHGMV_CGN_CHR_CGN2, measurevar="AHGMV", groupvars=c("group", "ScanOrder"))
	AHGMVsummary$ScanOrder <- factor(AHGMVsummary$ScanOrder)
	AHGMVsummary$group <- factor(AHGMVsummary$group)
	AHGMV_cgnchrcgn_meanSENDF <- createMeanSENDF(AHGMV_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"))
	AHGMV_plot <- ggplot(AHGMVsummary, aes(x=ScanOrder, y=AHGMV, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("AHGMV (+/- SE)") +
    		geom_errorbar(aes(ymin=AHGMV-se, ymax=AHGMV+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Total Gray Matter Volume - CGN-CHR-CGN")
	# AHCGMV
	AHCGMV_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AHCGMV")] # Very consistent
	AHCGMVsummary <- summarySE(AHCGMV_CGN_CHR_CGN2, measurevar="AHCGMV", groupvars=c("group", "ScanOrder"))
	AHCGMVsummary$ScanOrder <- factor(AHCGMVsummary$ScanOrder)
	AHCGMVsummary$group <- factor(AHCGMVsummary$group)
	AHCGMV_cgnchrcgn_meanSENDF <- createMeanSENDF(AHCGMV_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="AHCGMV")
	AHCGMV_plot <- ggplot(AHCGMVsummary, aes(x=ScanOrder, y=AHCGMV, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("AHCGMV (+/- SE)") +
    		geom_errorbar(aes(ymin=AHCGMV-se, ymax=AHCGMV+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Cortical Gray Matter Volume - CGN-CHR-CGN")
	# BasGang_Vol
	BasGang_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "BasGang_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	BasGangsummary <- summarySE(BasGang_CGN_CHR_CGN2, measurevar="BasGang_Vol", groupvars=c("group", "ScanOrder"))
	BasGangsummary$ScanOrder <- factor(BasGangsummary$ScanOrder)
	BasGangsummary$group <- factor(BasGangsummary$group)
	BasGang_cgnchrcgn_meanSENDF <- createMeanSENDF(BasGang_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="BasGang_Vol")
	BasGang_plot <- ggplot(BasGangsummary, aes(x=ScanOrder, y=BasGang_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("BasGang (+/- SE)") +
    		geom_errorbar(aes(ymin=BasGang_Vol-se, ymax=BasGang_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Basal Ganglia Gray Matter Volume - CGN-CHR-CGN")
	# Limbic_Vol
	Limbic_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Limbic_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	Limbicsummary <- summarySE(Limbic_CGN_CHR_CGN2, measurevar="Limbic_Vol", groupvars=c("group", "ScanOrder"))
	Limbicsummary$ScanOrder <- factor(Limbicsummary$ScanOrder)
	Limbicsummary$group <- factor(Limbicsummary$group)
	Limbic_cgnchrcgn_meanSENDF <- createMeanSENDF(Limbic_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Limbic_Vol")
	Limbic_plot <- ggplot(Limbicsummary, aes(x=ScanOrder, y=Limbic_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Limbic (+/- SE)") +
    		geom_errorbar(aes(ymin=Limbic_Vol-se, ymax=Limbic_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Limbic Gray Matter Volume - CGN-CHR-CGN")
	# FrontOrb_Vol
	FrontOrb_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "FrontOrb_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	FrontOrbsummary <- summarySE(FrontOrb_CGN_CHR_CGN2, measurevar="FrontOrb_Vol", groupvars=c("group", "ScanOrder"))
	FrontOrbsummary$ScanOrder <- factor(FrontOrbsummary$ScanOrder)
	FrontOrbsummary$group <- factor(FrontOrbsummary$group)
	FrontOrb_cgnchrcgn_meanSENDF <- createMeanSENDF(FrontOrb_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="FrontOrb_Vol")
	FrontOrb_plot <- ggplot(FrontOrbsummary, aes(x=ScanOrder, y=FrontOrb_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontOrb (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontOrb_Vol-se, ymax=FrontOrb_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontOrb Gray Matter Volume - CGN-CHR-CGN")
	# FrontDors_Vol
	FrontDors_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "FrontDors_Vol")] # HUGE Down-Up-Down in both
	FrontDorssummary <- summarySE(FrontDors_CGN_CHR_CGN2, measurevar="FrontDors_Vol", groupvars=c("group", "ScanOrder"))
	FrontDorssummary$ScanOrder <- factor(FrontDorssummary$ScanOrder)
	FrontDorssummary$group <- factor(FrontDorssummary$group)
	FrontDors_cgnchrcgn_meanSENDF <- createMeanSENDF(FrontDors_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="FrontDors_Vol")
	FrontDors_plot <- ggplot(FrontDorssummary, aes(x=ScanOrder, y=FrontDors_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("FrontDors (+/- SE)") +
    		geom_errorbar(aes(ymin=FrontDors_Vol-se, ymax=FrontDors_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("FrontDors Gray Matter Volume - CGN-CHR-CGN")
	# Temporal_Vol
	Temporal_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Temporal_Vol")] # Large Up-Down-Up present in both
	Temporalsummary <- summarySE(Temporal_CGN_CHR_CGN2, measurevar="Temporal_Vol", groupvars=c("group", "ScanOrder"))
	Temporalsummary$ScanOrder <- factor(Temporalsummary$ScanOrder)
	Temporalsummary$group <- factor(Temporalsummary$group)
	Temporal_cgnchrcgn_meanSENDF <- createMeanSENDF(Temporal_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Temporal_Vol")
	Temporal_plot <- ggplot(Temporalsummary, aes(x=ScanOrder, y=Temporal_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Temporal (+/- SE)") +
    		geom_errorbar(aes(ymin=Temporal_Vol-se, ymax=Temporal_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Temporal Gray Matter Volume - CGN-CHR-CGN")
	# Parietal_Vol
	Parietal_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Parietal_Vol")] # Pretty consistent
	Parietalsummary <- summarySE(Parietal_CGN_CHR_CGN2, measurevar="Parietal_Vol", groupvars=c("group", "ScanOrder"))
	Parietalsummary$ScanOrder <- factor(Parietalsummary$ScanOrder)
	Parietalsummary$group <- factor(Parietalsummary$group)
	Parietal_cgnchrcgn_meanSENDF <- createMeanSENDF(Parietal_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Parietal_Vol")
	Parietal_plot <- ggplot(Parietalsummary, aes(x=ScanOrder, y=Parietal_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Parietal (+/- SE)") +
    		geom_errorbar(aes(ymin=Parietal_Vol-se, ymax=Parietal_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Parietal Gray Matter Volume - CGN-CHR-CGN")
	# Occipital_Vol
	Occipital_CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "Occipital_Vol")] # Minor Up-Down-Up present in Crew but not Phantoms
	Occipitalsummary <- summarySE(Occipital_CGN_CHR_CGN2, measurevar="Occipital_Vol", groupvars=c("group", "ScanOrder"))
	Occipitalsummary$ScanOrder <- factor(Occipitalsummary$ScanOrder)
	Occipitalsummary$group <- factor(Occipitalsummary$group)
	Occipital_cgnchrcgn_meanSENDF <- createMeanSENDF(Occipital_CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="Occipital_Vol")
	Occipital_plot <- ggplot(Occipitalsummary, aes(x=ScanOrder, y=Occipital_Vol, colour=group, group=group)) + 
		xlab("Time Point") +
		ylab("Occipital (+/- SE)") +
    		geom_errorbar(aes(ymin=Occipital_Vol-se, ymax=Occipital_Vol+se), width=.1) +
    		geom_line() +
    		geom_point() +
		ggtitle("Occipital Gray Matter Volume - CGN-CHR-CGN")
	pdf(file = "/home/ebutler/nasa_plots/CGNCHRCGN_vol.pdf")
	print(AHGMV_plot)
	print(AHCGMV_plot)
	print(BasGang_plot)
	print(Limbic_plot)
	print(FrontOrb_plot)
	print(FrontDors_plot)
	print(Temporal_plot)
	print(Parietal_plot)
	print(Occipital_plot)
	dev.off()

	# ---------------------------------------------------------------------------- #

	# CHR-CHR-CGN
	CHR_CHR_CGN2 <- CHR_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AHGMV", "AHCGMV")]
	chrchrcgn_meanSENDF <- createMeanSENDF(CHR_CHR_CGN2, c("T1 - CHR", "T2 - CHR", "T3 - CGN"))

	# HOB-CHR-CGN
	HOB_CHR_CGN2 <- HOB_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AHGMV", "AHCGMV")]
	hobchrcgn_meanSENDF <- createMeanSENDF(HOB_CHR_CGN2, c("T1 - HOB", "T2 - CHR", "T3 - CGN"))
}








