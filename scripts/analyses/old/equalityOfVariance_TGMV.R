### Tests equality of variance in TGMV across phantoms and crew members, across sites
### 
### Ellyn Butler
### December 5, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

type="vol"

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
	nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Vol, ROI_ListofLists, lastList=TRUE, type="cort")
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
	nasa_data$TGMV <- nasa_data$BasGang_Vol + nasa_data$Limbic_Vol + nasa_data$FrontOrb_Vol + nasa_data$FrontDors_Vol + nasa_data$Temporal_Vol + nasa_data$Parietal_Vol + nasa_data$Occipital_Vol
	nasa_data$CGMV <- nasa_data$FrontOrb_Vol + nasa_data$FrontDors_Vol + nasa_data$Temporal_Vol + nasa_data$Parietal_Vol + nasa_data$Occipital_Vol
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

	# CGN-HOB-CGN
	CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "ACT")]
	cgnhobcgn_meanSENDF <- createMeanSENDF(CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"), metric="ACT")

	# CGN-CHR-CGN
	CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "ACT")]
	cgnchrcgn_meanSENDF <- createMeanSENDF(CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"), metric="ACT")

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

	# CHR-CHR-CGN
	CHR_CHR_CGN2 <- CHR_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	chrchrcgn_meanSENDF <- createMeanSENDF(CHR_CHR_CGN2, c("T1 - CHR", "T2 - CHR", "T3 - CGN"), metric="AGMD")

	# HOB-CHR-CGN
	HOB_CHR_CGN2 <- HOB_CHR_CGN[, c("group", "subject_1", "ScanOrder", "AGMD")]
	hobchrcgn_meanSENDF <- createMeanSENDF(HOB_CHR_CGN2, c("T1 - HOB", "T2 - CHR", "T3 - CGN"), metric="AGMD")
} else if (type == "vol") {
	# CGN-CGN-CGN
	CGN_CGN_CGN2 <- CGN_CGN_CGN[, c("group", "subject_1", "ScanOrder", "TGMV", "CGMV")]
	cgncgncgn_meanSENDF <- createMeanSENDF(CGN_CGN_CGN2, c("T1 - CGN", "T2 - CGN", "T3 - CGN"))

	# CGN-HOB-CGN
	CGN_HOB_CGN2 <- CGN_HOB_CGN[, c("group", "subject_1", "ScanOrder", "TGMV", "CGMV")]
	cgnhobcgn_meanSENDF <- createMeanSENDF(CGN_HOB_CGN2, c("T1 - CGN", "T2 - HOB", "T3 - CGN"))

	# CGN-CHR-CGN
	CGN_CHR_CGN2 <- CGN_CHR_CGN[, c("group", "subject_1", "ScanOrder", "TGMV", "CGMV")]
	cgnchrcgn_meanSENDF <- createMeanSENDF(CGN_CHR_CGN2, c("T1 - CGN", "T2 - CHR", "T3 - CGN"))

	# CHR-CHR-CGN
	CHR_CHR_CGN2 <- CHR_CHR_CGN[, c("group", "subject_1", "ScanOrder", "TGMV", "CGMV")]
	chrchrcgn_meanSENDF <- createMeanSENDF(CHR_CHR_CGN2, c("T1 - CHR", "T2 - CHR", "T3 - CGN"))

	# HOB-CHR-CGN
	HOB_CHR_CGN2 <- HOB_CHR_CGN[, c("group", "subject_1", "ScanOrder", "TGMV", "CGMV")]
	hobchrcgn_meanSENDF <- createMeanSENDF(HOB_CHR_CGN2, c("T1 - HOB", "T2 - CHR", "T3 - CGN"))
}




# --------------------------- Phantoms --------------------------- #


library(onewaytests)

phantomids <- c("BM", "EA", "GR", "PK")
phantom_data <- nasa_data[nasa_data$subject_1 %in% phantomids, ]


if (type == "cort") {
	phantom_data <- phantom_data[, c("group", "subject_1", "Time", "ScanOrder", "scanner", "ACT")]
	
} else if (type == "gmd") {
	phantom_data <- phantom_data[, c("group", "subject_1", "Time", "ScanOrder", "scanner", "AGMD")]
	
} else if (type == "vol") {
	phantom_data <- phantom_data[, c("group", "subject_1", "Time", "ScanOrder", "scanner", "TGMV")]
	# CGN 2014 vs. CHR
	cgn2014chr <- phantom_data[phantom_data$scanner == "CGN" && phantom_data$Time == "t1" | phantom_data$scanner == "CHR", ]
	

	# CGN 2014 vs. HOB
	cgn2014hob <- phantom_data[phantom_data$scanner == "CGN" && phantom_data$Time == "t1" | phantom_data$scanner == "HOB", ]


	# CGN 2014 vs. CGN 2017
	cgn2014cgn2017 <- phantom_data[phantom_data$scanner == "CGN", ]


	# CGN 2017 vs. CHR
	cgn2014hob <- phantom_data[phantom_data$scanner == "CGN" && phantom_data$Time == "t4" | phantom_data$scanner == "CHR", ]


	# CGN 2017 vs. HOB
	cgn2014hob <- phantom_data[phantom_data$scanner == "CGN" && phantom_data$Time == "t4" | phantom_data$scanner == "HOB", ]
	

}



















