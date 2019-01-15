### This script produces phantom plots for all whole-brain volume metrics (averaged across hemispheres)
###
### Ellyn Butler
### November 15, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Load the data 
if (type == "cort") {
	nasa_cort <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_CT.csv", header=T)
	nasa_data <- nasa_cort
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=T)

	# Rename id columns
	colnames(nasa_data)[colnames(nasa_data)=="id0"] <- "winterover"
	colnames(nasa_data)[colnames(nasa_data)=="id1"] <- "subject_1"
	colnames(nasa_data)[colnames(nasa_data)=="id2"] <- "Time"
	colnames(nasa_vol)[colnames(nasa_vol)=="id0"] <- "winterover"
	colnames(nasa_vol)[colnames(nasa_vol)=="id1"] <- "subject_1"
	colnames(nasa_vol)[colnames(nasa_vol)=="id2"] <- "Time"

	# Turn appropriate columns into factors
	nasa_data$winterover <- as.factor(nasa_data$winterover)
	nasa_data$subject_1 <- as.factor(nasa_data$subject_1)
	nasa_data$Time <- as.factor(nasa_data$Time)
	nasa_vol$winterover <- as.factor(nasa_vol$winterover)
	nasa_vol$subject_1 <- as.factor(nasa_vol$subject_1)
	nasa_vol$Time <- as.factor(nasa_vol$Time)

	# Filter for just phantoms
	phantom_data <- nasa_data[nasa_data$winterover == "phantoms", ]
	phantom_vol <- nasa_vol[nasa_vol$winterover == "phantoms", ]

	# Put in Scan column
	phantom_data$Scan <- NA
	for (i in 1:nrow(phantom_data)) {
		if (phantom_data[i, "Time"] == "t1") {
			phantom_data[i, "Scan"] <- "t1 - CGN 2014"
		} else if (phantom_data[i, "Time"] == "t2") {
			phantom_data[i, "Scan"] <- "t2 - CHR"
		} else if (phantom_data[i, "Time"] == "t3") {
			phantom_data[i, "Scan"] <- "t3 - HOB"
		} else if (phantom_data[i, "Time"] == "t4") {
			phantom_data[i, "Scan"] <- "t4 - CGN 2017"
		}
	}

} else if (type == "gmd") {
	nasa_gmd <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv", header=T) 
	nasa_data <- nasa_gmd
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=T)

	# Rename id columns
	colnames(nasa_data)[colnames(nasa_data)=="id0"] <- "winterover"
	colnames(nasa_data)[colnames(nasa_data)=="id1"] <- "subject_1"
	colnames(nasa_data)[colnames(nasa_data)=="id2"] <- "Time"
	colnames(nasa_vol)[colnames(nasa_vol)=="id0"] <- "winterover"
	colnames(nasa_vol)[colnames(nasa_vol)=="id1"] <- "subject_1"
	colnames(nasa_vol)[colnames(nasa_vol)=="id2"] <- "Time"

	# Turn appropriate columns into factors
	nasa_data$winterover <- as.factor(nasa_data$winterover)
	nasa_data$subject_1 <- as.factor(nasa_data$subject_1)
	nasa_data$Time <- as.factor(nasa_data$Time)
	nasa_vol$winterover <- as.factor(nasa_vol$winterover)
	nasa_vol$subject_1 <- as.factor(nasa_vol$subject_1)
	nasa_vol$Time <- as.factor(nasa_vol$Time)

	# Filter for just phantoms
	phantom_data <- nasa_data[nasa_data$winterover == "phantoms", ]
	phantom_vol <- nasa_vol[nasa_vol$winterover == "phantoms", ]

	# Put in Scan column
	phantom_data$Scan <- NA
	for (i in 1:nrow(phantom_data)) {
		if (phantom_data[i, "Time"] == "t1") {
			phantom_data[i, "Scan"] <- "t1 - CGN 2014"
		} else if (phantom_data[i, "Time"] == "t2") {
			phantom_data[i, "Scan"] <- "t2 - CHR"
		} else if (phantom_data[i, "Time"] == "t3") {
			phantom_data[i, "Scan"] <- "t3 - HOB"
		} else if (phantom_data[i, "Time"] == "t4") {
			phantom_data[i, "Scan"] <- "t4 - CGN 2017"
		}
	}
} else if (type == "vol") {
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=T)
	nasa_data <- nasa_vol

	# Rename id columns
	colnames(nasa_data)[colnames(nasa_data)=="id0"] <- "winterover"
	colnames(nasa_data)[colnames(nasa_data)=="id1"] <- "subject_1"
	colnames(nasa_data)[colnames(nasa_data)=="id2"] <- "Time"

	# Turn appropriate columns into factors
	nasa_data$winterover <- as.factor(nasa_data$winterover)
	nasa_data$subject_1 <- as.factor(nasa_data$subject_1)
	nasa_data$Time <- as.factor(nasa_data$Time)

	# Filter for just phantoms
	phantom_data <- nasa_data[nasa_data$winterover == "phantoms", ]

	# Put in Scan column
	phantom_data$Scan <- NA
	for (i in 1:nrow(phantom_data)) {
		if (phantom_data[i, "Time"] == "t1") {
			phantom_data[i, "Scan"] <- "t1 - CGN 2014"
		} else if (phantom_data[i, "Time"] == "t2") {
			phantom_data[i, "Scan"] <- "t2 - CHR"
		} else if (phantom_data[i, "Time"] == "t3") {
			phantom_data[i, "Scan"] <- "t3 - HOB"
		} else if (phantom_data[i, "Time"] == "t4") {
			phantom_data[i, "Scan"] <- "t4 - CGN 2017"
		}
	}
}

######## ------------------------ ROI Plots ------------------------ ########


# ------------------------ Filter for GR ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	GR_data <- phantom_data[phantom_data$subject_1 == "GR", ]
	GR_vol <- phantom_vol[phantom_vol$subject_1 == "GR", ]
	# Refactor data
	GR_data$winterover <- factor(GR_data$winterover)
	GR_data$subject_1 <- factor(GR_data$subject_1)
	GR_data$Time <- factor(GR_data$Time)

	# cort
	GR_data <- averageLeftAndRight_WeightByVol(GR_vol, GR_data, otherString="anatomical_corticalThickness_mean_")
	colnums <- grep("_ave_", colnames(GR_data))
	GR_data <- phantomBetas(GR_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(GR_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	# vol (I don't think this section is relevant... November 30, 2018)
	#GR_vol <- averageLeftAndRight_Vol(GR_vol, "_R_", "_L_", "_ave_")
	#colnums <- grep("_ave_", colnames(GR_vol))
	#GR_vol <- phantomBetas(GR_vol, colnums)
	#ROIlist_vol <- grep("_tNdivtt1", colnames(GR_vol), value=TRUE)
	#ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "gmd") {
	GR_data <- phantom_data[phantom_data$subject_1 == "GR", ]
	GR_vol <- phantom_vol[phantom_vol$subject_1 == "GR", ]
	# Refactor data
	GR_data$winterover <- factor(GR_data$winterover)
	GR_data$subject_1 <- factor(GR_data$subject_1)
	GR_data$Time <- factor(GR_data$Time)

	# gmd
	GR_data <- averageLeftAndRight_WeightByVol(GR_vol, GR_data, otherString="anatomical_gmd_mean_")
	colnums <- grep("_ave_", colnames(GR_data))
	GR_data <- phantomBetas(GR_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(GR_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	# vol
	#GR_vol <- averageLeftAndRight_Vol(GR_vol, "_R_", "_L_", "_ave_")
	#colnums <- grep("_ave_", colnames(GR_vol))
	#GR_vol <- phantomBetas(GR_vol, colnums)
	#ROIlist_vol <- grep("_tNdivtt1", colnames(GR_vol), value=TRUE)
	#ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "vol") {
	GR_data <- phantom_data[phantom_data$subject_1 == "GR", ]
	GR_vol <- phantom_vol[phantom_vol$subject_1 == "GR", ]
	# Refactor data
	GR_data$winterover <- factor(GR_data$winterover)
	GR_data$subject_1 <- factor(GR_data$subject_1)
	GR_data$Time <- factor(GR_data$Time)

	GR_data <- averageLeftAndRight_Vol(GR_data, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(GR_data))
	GR_data <- phantomBetas(GR_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(GR_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}

# create summaryDF
factorsList <- c("Scan")
if (type == "cort") {
	GR_summaryDF <- createSummaryDF(GR_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_", pattern2="_tNdivtt1") # se in the way
} else if (type == "gmd") {
	GR_summaryDF <- createSummaryDF(GR_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="_tNdivtt1") 
} else if (type == "vol") {
	GR_summaryDF <- createSummaryDF(GR_data, factorsList, ROI_ListofLists, pattern2="_tNdivtt1") 
}

# create plot
if (type == "cort") {
	GR_cort_plot <- createPhantomGGPlotImage(GR_summaryDF, "Scan", "GR - Cortical thickness")
} else if (type == "gmd") {
	GR_gmd_plot <- createPhantomGGPlotImage(GR_summaryDF, "Scan", "GR - Gray Matter Density", upper_order=1.9)
} else if (type == "vol") {
	GR_vol_plot <- createPhantomGGPlotImage(GR_summaryDF, "Scan", "GR - Volume")
}


# ------------------------ Filter for BJ ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	BJ_data <- phantom_data[phantom_data$subject_1 == "BJ", ]
	BJ_vol <- phantom_vol[phantom_vol$subject_1 == "BJ", ]
	# Refactor data
	BJ_data$winterover <- factor(BJ_data$winterover)
	BJ_data$subject_1 <- factor(BJ_data$subject_1)
	BJ_data$Time <- factor(BJ_data$Time)

	# cort
	BJ_data <- averageLeftAndRight_WeightByVol(BJ_vol, BJ_data, otherString="anatomical_corticalThickness_mean_")
	colnums <- grep("_ave_", colnames(BJ_data))
	BJ_data <- phantomBetas(BJ_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(BJ_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	# vol
	BJ_vol <- averageLeftAndRight_Vol(BJ_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(BJ_vol))
	BJ_vol <- phantomBetas(BJ_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(BJ_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "gmd") {
	BJ_data <- phantom_data[phantom_data$subject_1 == "BJ", ]
	BJ_vol <- phantom_vol[phantom_vol$subject_1 == "BJ", ]
	# Refactor data
	BJ_data$winterover <- factor(BJ_data$winterover)
	BJ_data$subject_1 <- factor(BJ_data$subject_1)
	BJ_data$Time <- factor(BJ_data$Time)

	# gmd
	BJ_data <- averageLeftAndRight_WeightByVol(BJ_vol, BJ_data, otherString="anatomical_gmd_mean_")
	colnums <- grep("_ave_", colnames(BJ_data))
	BJ_data <- phantomBetas(BJ_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(BJ_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	# vol
	BJ_vol <- averageLeftAndRight_Vol(BJ_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(BJ_vol))
	BJ_vol <- phantomBetas(BJ_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(BJ_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "vol") {
	BJ_data <- phantom_data[phantom_data$subject_1 == "BJ", ]
	BJ_vol <- phantom_vol[phantom_vol$subject_1 == "BJ", ]
	# Refactor data
	BJ_data$winterover <- factor(BJ_data$winterover)
	BJ_data$subject_1 <- factor(BJ_data$subject_1)
	BJ_data$Time <- factor(BJ_data$Time)

	BJ_data <- averageLeftAndRight_Vol(BJ_data, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(BJ_data))
	BJ_data <- phantomBetas(BJ_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(BJ_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}

# create summaryDF
factorsList <- c("Scan")
if (type == "cort") {
	BJ_summaryDF <- createSummaryDF(BJ_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_", pattern2="_tNdivtt1") # se in the way
} else if (type == "gmd") {
	BJ_summaryDF <- createSummaryDF(BJ_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="_tNdivtt1") 
} else if (type == "vol") {
	BJ_summaryDF <- createSummaryDF(BJ_data, factorsList, ROI_ListofLists, pattern2="_tNdivtt1") 
}

# create plot
if (type == "cort") {
	BJ_cort_plot <- createPhantomGGPlotImage(BJ_summaryDF, "Scan", "BJ - Cortical thickness", color_vec=c("brown1", "goldenrod3"))
} else if (type == "gmd") {
	BJ_gmd_plot <- createPhantomGGPlotImage(BJ_summaryDF, "Scan", "BJ - Gray Matter Density", upper_order=1.9, color_vec=c("brown1", "goldenrod3"))
} else if (type == "vol") {
	BJ_vol_plot <- createPhantomGGPlotImage(BJ_summaryDF, "Scan", "BJ - Volume", color_vec=c("brown1", "goldenrod3"))
}


# ------------------------ Filter for BM ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	BM_data <- phantom_data[phantom_data$subject_1 == "BM", ]
	BM_vol <- phantom_vol[phantom_vol$subject_1 == "BM", ]
	# Refactor data
	BM_data$winterover <- factor(BM_data$winterover)
	BM_data$subject_1 <- factor(BM_data$subject_1)
	BM_data$Time <- factor(BM_data$Time)

	# cort
	BM_data <- averageLeftAndRight_WeightByVol(BM_vol, BM_data, otherString="anatomical_corticalThickness_mean_")
	colnums <- grep("_ave_", colnames(BM_data))
	BM_data <- phantomBetas(BM_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(BM_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	# vol
	BM_vol <- averageLeftAndRight_Vol(BM_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(BM_vol))
	BM_vol <- phantomBetas(BM_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(BM_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "gmd") {
	BM_data <- phantom_data[phantom_data$subject_1 == "BM", ]
	BM_vol <- phantom_vol[phantom_vol$subject_1 == "BM", ]
	# Refactor data
	BM_data$winterover <- factor(BM_data$winterover)
	BM_data$subject_1 <- factor(BM_data$subject_1)
	BM_data$Time <- factor(BM_data$Time)

	# gmd
	BM_data <- averageLeftAndRight_WeightByVol(BM_vol, BM_data, otherString="anatomical_gmd_mean_")
	colnums <- grep("_ave_", colnames(BM_data))
	BM_data <- phantomBetas(BM_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(BM_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	# vol
	BM_vol <- averageLeftAndRight_Vol(BM_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(BM_vol))
	BM_vol <- phantomBetas(BM_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(BM_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "vol") {
	BM_data <- phantom_data[phantom_data$subject_1 == "BM", ]
	BM_vol <- phantom_vol[phantom_vol$subject_1 == "BM", ]
	# Refactor data
	BM_data$winterover <- factor(BM_data$winterover)
	BM_data$subject_1 <- factor(BM_data$subject_1)
	BM_data$Time <- factor(BM_data$Time)

	BM_data <- averageLeftAndRight_Vol(BM_data, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(BM_data))
	BM_data <- phantomBetas(BM_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(BM_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}

# create summaryDF
factorsList <- c("Scan")
if (type == "cort") {
	BM_summaryDF <- createSummaryDF(BM_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_", pattern2="_tNdivtt1") # se in the way
} else if (type == "gmd") {
	BM_summaryDF <- createSummaryDF(BM_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="_tNdivtt1") 
} else if (type == "vol") {
	BM_summaryDF <- createSummaryDF(BM_data, factorsList, ROI_ListofLists, pattern2="_tNdivtt1") 
}

# create plot
if (type == "cort") {
	BM_cort_plot <- createPhantomGGPlotImage(BM_summaryDF, "Scan", "BM - Cortical thickness")
} else if (type == "gmd") {
	BM_gmd_plot <- createPhantomGGPlotImage(BM_summaryDF, "Scan", "BM - Gray Matter Density", upper_order=1.9)
} else if (type == "vol") {
	BM_vol_plot <- createPhantomGGPlotImage(BM_summaryDF, "Scan", "BM - Volume")
}


# ------------------------ Filter for EA ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	EA_data <- phantom_data[phantom_data$subject_1 == "EA", ]
	EA_vol <- phantom_vol[phantom_vol$subject_1 == "EA", ]
	# Refactor data
	EA_data$winterover <- factor(EA_data$winterover)
	EA_data$subject_1 <- factor(EA_data$subject_1)
	EA_data$Time <- factor(EA_data$Time)

	# cort
	EA_data <- averageLeftAndRight_WeightByVol(EA_vol, EA_data, otherString="anatomical_corticalThickness_mean_")
	colnums <- grep("_ave_", colnames(EA_data))
	EA_data <- phantomBetas(EA_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(EA_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	# vol
	EA_vol <- averageLeftAndRight_Vol(EA_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(EA_vol))
	EA_vol <- phantomBetas(EA_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(EA_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "gmd") {
	EA_data <- phantom_data[phantom_data$subject_1 == "EA", ]
	EA_vol <- phantom_vol[phantom_vol$subject_1 == "EA", ]
	# Refactor data
	EA_data$winterover <- factor(EA_data$winterover)
	EA_data$subject_1 <- factor(EA_data$subject_1)
	EA_data$Time <- factor(EA_data$Time)

	# gmd
	EA_data <- averageLeftAndRight_WeightByVol(EA_vol, EA_data, otherString="anatomical_gmd_mean_")
	colnums <- grep("_ave_", colnames(EA_data))
	EA_data <- phantomBetas(EA_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(EA_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	# vol
	EA_vol <- averageLeftAndRight_Vol(EA_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(EA_vol))
	EA_vol <- phantomBetas(EA_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(EA_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "vol") {
	EA_data <- phantom_data[phantom_data$subject_1 == "EA", ]
	EA_vol <- phantom_vol[phantom_vol$subject_1 == "EA", ]
	# Refactor data
	EA_data$winterover <- factor(EA_data$winterover)
	EA_data$subject_1 <- factor(EA_data$subject_1)
	EA_data$Time <- factor(EA_data$Time)

	EA_data <- averageLeftAndRight_Vol(EA_data, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(EA_data))
	EA_data <- phantomBetas(EA_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(EA_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}

# create summaryDF
factorsList <- c("Scan")
if (type == "cort") {
	EA_summaryDF <- createSummaryDF(EA_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_", pattern2="_tNdivtt1") # se in the way
} else if (type == "gmd") {
	EA_summaryDF <- createSummaryDF(EA_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="_tNdivtt1") 
} else if (type == "vol") {
	EA_summaryDF <- createSummaryDF(EA_data, factorsList, ROI_ListofLists, pattern2="_tNdivtt1") 
}

# create plot
if (type == "cort") {
	EA_cort_plot <- createPhantomGGPlotImage(EA_summaryDF, "Scan", "EA - Cortical thickness")
} else if (type == "gmd") {
	EA_gmd_plot <- createPhantomGGPlotImage(EA_summaryDF, "Scan", "EA - Gray Matter Density", upper_order=1.9)
} else if (type == "vol") {
	EA_vol_plot <- createPhantomGGPlotImage(EA_summaryDF, "Scan", "EA - Volume")
}


# ------------------------ Filter for PK ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	PK_data <- phantom_data[phantom_data$subject_1 == "PK", ]
	PK_vol <- phantom_vol[phantom_vol$subject_1 == "PK", ]
	# Refactor data
	PK_data$winterover <- factor(PK_data$winterover)
	PK_data$subject_1 <- factor(PK_data$subject_1)
	PK_data$Time <- factor(PK_data$Time)

	# cort
	PK_data <- averageLeftAndRight_WeightByVol(PK_vol, PK_data, otherString="anatomical_corticalThickness_mean_")
	colnums <- grep("_ave_", colnames(PK_data))
	PK_data <- phantomBetas(PK_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(PK_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	# vol
	PK_vol <- averageLeftAndRight_Vol(PK_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(PK_vol))
	PK_vol <- phantomBetas(PK_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(PK_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "gmd") {
	PK_data <- phantom_data[phantom_data$subject_1 == "PK", ]
	PK_vol <- phantom_vol[phantom_vol$subject_1 == "PK", ]
	# Refactor data
	PK_data$winterover <- factor(PK_data$winterover)
	PK_data$subject_1 <- factor(PK_data$subject_1)
	PK_data$Time <- factor(PK_data$Time)

	# gmd
	PK_data <- averageLeftAndRight_WeightByVol(PK_vol, PK_data, otherString="anatomical_gmd_mean_")
	colnums <- grep("_ave_", colnames(PK_data))
	PK_data <- phantomBetas(PK_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(PK_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	# vol
	PK_vol <- averageLeftAndRight_Vol(PK_vol, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(PK_vol))
	PK_vol <- phantomBetas(PK_vol, colnums)
	ROIlist_vol <- grep("_tNdivtt1", colnames(PK_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "vol") {
	PK_data <- phantom_data[phantom_data$subject_1 == "PK", ]
	PK_vol <- phantom_vol[phantom_vol$subject_1 == "PK", ]
	# Refactor data
	PK_data$winterover <- factor(PK_data$winterover)
	PK_data$subject_1 <- factor(PK_data$subject_1)
	PK_data$Time <- factor(PK_data$Time)

	PK_data <- averageLeftAndRight_Vol(PK_data, "_R_", "_L_", "_ave_")
	colnums <- grep("_ave_", colnames(PK_data))
	PK_data <- phantomBetas(PK_data, colnums)
	ROIlist <- grep("_tNdivtt1", colnames(PK_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}

# create summaryDF
factorsList <- c("Scan")
if (type == "cort") {
	PK_summaryDF <- createSummaryDF(PK_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_", pattern2="_tNdivtt1") # se in the way
} else if (type == "gmd") {
	PK_summaryDF <- createSummaryDF(PK_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="_tNdivtt1") 
} else if (type == "vol") {
	PK_summaryDF <- createSummaryDF(PK_data, factorsList, ROI_ListofLists, pattern2="_tNdivtt1") 
}

# create plot
if (type == "cort") {
	PK_cort_plot <- createPhantomGGPlotImage(PK_summaryDF, "Scan", "PK - Cortical thickness", color_vec=c("brown1", "dodgerblue", "goldenrod3"))
} else if (type == "gmd") {
	PK_gmd_plot <- createPhantomGGPlotImage(PK_summaryDF, "Scan", "PK - Gray Matter Density", upper_order=1.9, color_vec=c("brown1", "dodgerblue", "goldenrod3"))
} else if (type == "vol") {
	PK_vol_plot <- createPhantomGGPlotImage(PK_summaryDF, "Scan", "PK - Volume", color_vec=c("brown1", "dodgerblue", "goldenrod3"))
}



# ------------------------------------------------------------------------------------------------------------------ #

if (type == "cort") {
	pdf(file = "/home/ebutler/nasa_plots/phantoms_brainROI_cort.pdf", width=12, height=8)
	print(GR_cort_plot)
	print(BJ_cort_plot)
	print(BM_cort_plot)
	print(EA_cort_plot)
	print(PK_cort_plot)
	dev.off()
} else if (type == "gmd") {
	pdf(file = "/home/ebutler/nasa_plots/phantoms_brainROI_gmd.pdf", width=12, height=8)
	print(GR_gmd_plot)
	print(BJ_gmd_plot)
	print(BM_gmd_plot)
	print(EA_gmd_plot)
	print(PK_gmd_plot)
	dev.off()
} else if (type == "vol") {
	pdf(file = "/home/ebutler/nasa_plots/phantoms_brainROI_vol.pdf", width=12, height=8)
	print(GR_vol_plot)
	print(BJ_vol_plot)
	print(BM_vol_plot)
	print(EA_vol_plot)
	print(PK_vol_plot)
	dev.off()
}

######## ------------------------ Lobe Plots ------------------------ ########



# ------------------------ Filter for GR ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	GR_data <- phantom_data[phantom_data$subject_1 == "GR", ]
	GR_vol <- phantom_vol[phantom_vol$subject_1 == "GR", ]
	# Refactor data
	GR_data$winterover <- factor(GR_data$winterover)
	GR_data$subject_1 <- factor(GR_data$subject_1)
	GR_data$Time <- factor(GR_data$Time)

	# cort
	GR_data <- averageLeftAndRight_WeightByVol(GR_vol, GR_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(GR_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	GR_vol <- averageLeftAndRight_Vol(GR_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(GR_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$BasGang <- NULL
	ROI_ListofLists_vol$Limbic <- NULL
	ROI_ListofLists_vol$Cerebellum <- NULL
	GR_vol <- lobeVolumes(GR_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	GR_data <- averageROIsInLobes_WeightByVol(GR_vol, GR_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="cort")
	colnums <- c(grep("FrontOrb", colnames(GR_data)), grep("FrontDors", colnames(GR_data)), grep("Temporal", colnames(GR_data)), grep("Parietal", colnames(GR_data)), grep("Occipital", colnames(GR_data)))
	GR_data <- phantomBetas(GR_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(GR_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	GR_summaryDF <- createSummaryDF(GR_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	GR_cort_plot <- createPhantomGGPlotImage(GR_summaryDF, "Scan", "GR - Lobular Cortical Thickness", lower_order=.7, upper_order=1.3, rois=FALSE)
} else if (type == "gmd") {
	GR_data <- phantom_data[phantom_data$subject_1 == "GR", ]
	GR_vol <- phantom_vol[phantom_vol$subject_1 == "GR", ]
	# Refactor data
	GR_data$winterover <- factor(GR_data$winterover)
	GR_data$subject_1 <- factor(GR_data$subject_1)
	GR_data$Time <- factor(GR_data$Time)
	# gmd
	GR_data <- averageLeftAndRight_WeightByVol(GR_vol, GR_data, otherString="anatomical_gmd_mean_")
	ROIlist <- grep("_ave_", colnames(GR_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	GR_vol <- averageLeftAndRight_Vol(GR_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(GR_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$Cerebellum <- NULL
	GR_vol <- lobeVolumes(GR_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	GR_data <- averageROIsInLobes_WeightByVol(GR_vol, GR_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="gmd")
	colnums <- c(grep("BasGang", colnames(GR_data)), grep("Limbic", colnames(GR_data)), grep("FrontOrb", colnames(GR_data)), grep("FrontDors", colnames(GR_data)), grep("Temporal", colnames(GR_data)), grep("Parietal", colnames(GR_data)), grep("Occipital", colnames(GR_data)))
	GR_data <- phantomBetas(GR_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(GR_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	GR_summaryDF <- createSummaryDF(GR_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_GMD_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	GR_gmd_plot <- createPhantomGGPlotImage(GR_summaryDF, "Scan", "GR - Lobular Grey Matter Density", lower_order=.7, upper_order=1.3, rois=FALSE)
} else if (type == "vol") {
	GR_data <- phantom_data[phantom_data$subject_1 == "GR", ]
	# Refactor data
	GR_data$winterover <- factor(GR_data$winterover)
	GR_data$subject_1 <- factor(GR_data$subject_1)
	GR_data$Time <- factor(GR_data$Time)
	GR_data <- averageLeftAndRight_Vol(GR_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(GR_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	GR_data <- lobeVolumes(GR_data, ROI_ListofLists, lastList=TRUE) 
	colnums <- c(grep("BasGang", colnames(GR_data)), grep("Limbic", colnames(GR_data)), grep("FrontOrb", colnames(GR_data)), grep("FrontDors", colnames(GR_data)), grep("Temporal", colnames(GR_data)), grep("Parietal", colnames(GR_data)), grep("Occipital", colnames(GR_data)))
	GR_data <- phantomBetas(GR_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(GR_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	GR_summaryDF <- createSummaryDF(GR_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_Vol_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	GR_vol_plot <- createPhantomGGPlotImage(GR_summaryDF, "Scan", "GR - Lobular Volume", lower_order=.7, upper_order=1.3, rois=FALSE)
}




# ------------------------ Filter for BJ ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	BJ_data <- phantom_data[phantom_data$subject_1 == "BJ", ]
	BJ_vol <- phantom_vol[phantom_vol$subject_1 == "BJ", ]
	# Refactor data
	BJ_data$winterover <- factor(BJ_data$winterover)
	BJ_data$subject_1 <- factor(BJ_data$subject_1)
	BJ_data$Time <- factor(BJ_data$Time)

	# cort
	BJ_data <- averageLeftAndRight_WeightByVol(BJ_vol, BJ_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(BJ_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	BJ_vol <- averageLeftAndRight_Vol(BJ_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(BJ_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$BasGang <- NULL
	ROI_ListofLists_vol$Limbic <- NULL
	ROI_ListofLists_vol$Cerebellum <- NULL
	BJ_vol <- lobeVolumes(BJ_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	BJ_data <- averageROIsInLobes_WeightByVol(BJ_vol, BJ_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="cort")
	colnums <- c(grep("FrontOrb", colnames(BJ_data)), grep("FrontDors", colnames(BJ_data)), grep("Temporal", colnames(BJ_data)), grep("Parietal", colnames(BJ_data)), grep("Occipital", colnames(BJ_data)))
	BJ_data <- phantomBetas(BJ_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(BJ_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	BJ_summaryDF <- createSummaryDF(BJ_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	BJ_cort_plot <- createPhantomGGPlotImage(BJ_summaryDF, "Scan", "BJ - Lobular Cortical Thickness", lower_order=.7, upper_order=1.3, rois=FALSE, color_vec=c("brown1", "goldenrod3"))
} else if (type == "gmd") {
	BJ_data <- phantom_data[phantom_data$subject_1 == "BJ", ]
	BJ_vol <- phantom_vol[phantom_vol$subject_1 == "BJ", ]
	# Refactor data
	BJ_data$winterover <- factor(BJ_data$winterover)
	BJ_data$subject_1 <- factor(BJ_data$subject_1)
	BJ_data$Time <- factor(BJ_data$Time)
	# gmd
	BJ_data <- averageLeftAndRight_WeightByVol(BJ_vol, BJ_data, otherString="anatomical_gmd_mean_")
	ROIlist <- grep("_ave_", colnames(BJ_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	BJ_vol <- averageLeftAndRight_Vol(BJ_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(BJ_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$Cerebellum <- NULL
	BJ_vol <- lobeVolumes(BJ_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	BJ_data <- averageROIsInLobes_WeightByVol(BJ_vol, BJ_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="gmd")
	colnums <- c(grep("BasGang", colnames(BJ_data)), grep("Limbic", colnames(BJ_data)), grep("FrontOrb", colnames(BJ_data)), grep("FrontDors", colnames(BJ_data)), grep("Temporal", colnames(BJ_data)), grep("Parietal", colnames(BJ_data)), grep("Occipital", colnames(BJ_data)))
	BJ_data <- phantomBetas(BJ_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(BJ_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	BJ_summaryDF <- createSummaryDF(BJ_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_GMD_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	BJ_gmd_plot <- createPhantomGGPlotImage(BJ_summaryDF, "Scan", "BJ - Lobular Grey Matter Density", lower_order=.7, upper_order=1.3, rois=FALSE, color_vec=c("brown1", "goldenrod3"))
} else if (type == "vol") {
	BJ_data <- phantom_data[phantom_data$subject_1 == "BJ", ]
	# Refactor data
	BJ_data$winterover <- factor(BJ_data$winterover)
	BJ_data$subject_1 <- factor(BJ_data$subject_1)
	BJ_data$Time <- factor(BJ_data$Time)
	BJ_data <- averageLeftAndRight_Vol(BJ_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(BJ_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	BJ_data <- lobeVolumes(BJ_data, ROI_ListofLists, lastList=TRUE) 
	colnums <- c(grep("BasGang", colnames(BJ_data)), grep("Limbic", colnames(BJ_data)), grep("FrontOrb", colnames(BJ_data)), grep("FrontDors", colnames(BJ_data)), grep("Temporal", colnames(BJ_data)), grep("Parietal", colnames(BJ_data)), grep("Occipital", colnames(BJ_data)))
	BJ_data <- phantomBetas(BJ_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(BJ_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	BJ_summaryDF <- createSummaryDF(BJ_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_Vol_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	BJ_vol_plot <- createPhantomGGPlotImage(BJ_summaryDF, "Scan", "BJ - Lobular Volume", lower_order=.7, upper_order=1.3, rois=FALSE, color_vec=c("brown1", "goldenrod3"))
}




# ------------------------ Filter for BM ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	BM_data <- phantom_data[phantom_data$subject_1 == "BM", ]
	BM_vol <- phantom_vol[phantom_vol$subject_1 == "BM", ]
	# Refactor data
	BM_data$winterover <- factor(BM_data$winterover)
	BM_data$subject_1 <- factor(BM_data$subject_1)
	BM_data$Time <- factor(BM_data$Time)

	# cort
	BM_data <- averageLeftAndRight_WeightByVol(BM_vol, BM_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(BM_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	BM_vol <- averageLeftAndRight_Vol(BM_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(BM_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$BasGang <- NULL
	ROI_ListofLists_vol$Limbic <- NULL
	ROI_ListofLists_vol$Cerebellum <- NULL
	BM_vol <- lobeVolumes(BM_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	BM_data <- averageROIsInLobes_WeightByVol(BM_vol, BM_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="cort")
	colnums <- c(grep("FrontOrb", colnames(BM_data)), grep("FrontDors", colnames(BM_data)), grep("Temporal", colnames(BM_data)), grep("Parietal", colnames(BM_data)), grep("Occipital", colnames(BM_data)))
	BM_data <- phantomBetas(BM_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(BM_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	BM_summaryDF <- createSummaryDF(BM_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	BM_cort_plot <- createPhantomGGPlotImage(BM_summaryDF, "Scan", "BM - Lobular Cortical Thickness", lower_order=.7, upper_order=1.3, rois=FALSE)
} else if (type == "gmd") {
	BM_data <- phantom_data[phantom_data$subject_1 == "BM", ]
	BM_vol <- phantom_vol[phantom_vol$subject_1 == "BM", ]
	# Refactor data
	BM_data$winterover <- factor(BM_data$winterover)
	BM_data$subject_1 <- factor(BM_data$subject_1)
	BM_data$Time <- factor(BM_data$Time)
	# gmd
	BM_data <- averageLeftAndRight_WeightByVol(BM_vol, BM_data, otherString="anatomical_gmd_mean_")
	ROIlist <- grep("_ave_", colnames(BM_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	BM_vol <- averageLeftAndRight_Vol(BM_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(BM_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$Cerebellum <- NULL
	BM_vol <- lobeVolumes(BM_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	BM_data <- averageROIsInLobes_WeightByVol(BM_vol, BM_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="gmd")
	colnums <- c(grep("BasGang", colnames(BM_data)), grep("Limbic", colnames(BM_data)), grep("FrontOrb", colnames(BM_data)), grep("FrontDors", colnames(BM_data)), grep("Temporal", colnames(BM_data)), grep("Parietal", colnames(BM_data)), grep("Occipital", colnames(BM_data)))
	BM_data <- phantomBetas(BM_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(BM_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	BM_summaryDF <- createSummaryDF(BM_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_GMD_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	BM_gmd_plot <- createPhantomGGPlotImage(BM_summaryDF, "Scan", "BM - Lobular Grey Matter Density", lower_order=.7, upper_order=1.3, rois=FALSE)
} else if (type == "vol") {
	BM_data <- phantom_data[phantom_data$subject_1 == "BM", ]
	# Refactor data
	BM_data$winterover <- factor(BM_data$winterover)
	BM_data$subject_1 <- factor(BM_data$subject_1)
	BM_data$Time <- factor(BM_data$Time)
	BM_data <- averageLeftAndRight_Vol(BM_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(BM_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	BM_data <- lobeVolumes(BM_data, ROI_ListofLists, lastList=TRUE) 
	colnums <- c(grep("BasGang", colnames(BM_data)), grep("Limbic", colnames(BM_data)), grep("FrontOrb", colnames(BM_data)), grep("FrontDors", colnames(BM_data)), grep("Temporal", colnames(BM_data)), grep("Parietal", colnames(BM_data)), grep("Occipital", colnames(BM_data)))
	BM_data <- phantomBetas(BM_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(BM_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	BM_summaryDF <- createSummaryDF(BM_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_Vol_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	BM_vol_plot <- createPhantomGGPlotImage(BM_summaryDF, "Scan", "BM - Lobular Volume", lower_order=.7, upper_order=1.3, rois=FALSE)
}



# ------------------------ Filter for EA ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	EA_data <- phantom_data[phantom_data$subject_1 == "EA", ]
	EA_vol <- phantom_vol[phantom_vol$subject_1 == "EA", ]
	# Refactor data
	EA_data$winterover <- factor(EA_data$winterover)
	EA_data$subject_1 <- factor(EA_data$subject_1)
	EA_data$Time <- factor(EA_data$Time)

	# cort
	EA_data <- averageLeftAndRight_WeightByVol(EA_vol, EA_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(EA_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	EA_vol <- averageLeftAndRight_Vol(EA_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(EA_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$BasGang <- NULL
	ROI_ListofLists_vol$Limbic <- NULL
	ROI_ListofLists_vol$Cerebellum <- NULL
	EA_vol <- lobeVolumes(EA_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	EA_data <- averageROIsInLobes_WeightByVol(EA_vol, EA_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="cort")
	colnums <- c(grep("BasGang", colnames(EA_data)), grep("Limbic", colnames(EA_data)), grep("FrontOrb", colnames(EA_data)), grep("FrontDors", colnames(EA_data)), grep("Temporal", colnames(EA_data)), grep("Parietal", colnames(EA_data)), grep("Occipital", colnames(EA_data)))
	EA_data <- phantomBetas(EA_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(EA_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	EA_summaryDF <- createSummaryDF(EA_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	EA_cort_plot <- createPhantomGGPlotImage(EA_summaryDF, "Scan", "EA - Lobular Cortical Thickness", lower_order=.7, upper_order=1.3, rois=FALSE)
} else if (type == "gmd") {
	EA_data <- phantom_data[phantom_data$subject_1 == "EA", ]
	EA_vol <- phantom_vol[phantom_vol$subject_1 == "EA", ]
	# Refactor data
	EA_data$winterover <- factor(EA_data$winterover)
	EA_data$subject_1 <- factor(EA_data$subject_1)
	EA_data$Time <- factor(EA_data$Time)
	# gmd
	EA_data <- averageLeftAndRight_WeightByVol(EA_vol, EA_data, otherString="anatomical_gmd_mean_")
	ROIlist <- grep("_ave_", colnames(EA_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	EA_vol <- averageLeftAndRight_Vol(EA_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(EA_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$Cerebellum <- NULL
	EA_vol <- lobeVolumes(EA_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	EA_data <- averageROIsInLobes_WeightByVol(EA_vol, EA_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="gmd")
	colnums <- c(grep("FrontOrb", colnames(EA_data)), grep("FrontDors", colnames(EA_data)), grep("Temporal", colnames(EA_data)), grep("Parietal", colnames(EA_data)), grep("Occipital", colnames(EA_data)))
	EA_data <- phantomBetas(EA_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(EA_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	EA_summaryDF <- createSummaryDF(EA_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_GMD_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	EA_gmd_plot <- createPhantomGGPlotImage(EA_summaryDF, "Scan", "EA - Lobular Grey Matter Density", lower_order=.7, upper_order=1.3, rois=FALSE)
} else if (type == "vol") {
	EA_data <- phantom_data[phantom_data$subject_1 == "EA", ]
	# Refactor data
	EA_data$winterover <- factor(EA_data$winterover)
	EA_data$subject_1 <- factor(EA_data$subject_1)
	EA_data$Time <- factor(EA_data$Time)
	EA_data <- averageLeftAndRight_Vol(EA_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(EA_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	EA_data <- lobeVolumes(EA_data, ROI_ListofLists, lastList=TRUE) 
	colnums <- c(grep("BasGang", colnames(EA_data)), grep("Limbic", colnames(EA_data)), grep("FrontOrb", colnames(EA_data)), grep("FrontDors", colnames(EA_data)), grep("Temporal", colnames(EA_data)), grep("Parietal", colnames(EA_data)), grep("Occipital", colnames(EA_data)))
	EA_data <- phantomBetas(EA_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(EA_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	EA_summaryDF <- createSummaryDF(EA_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_Vol_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	EA_vol_plot <- createPhantomGGPlotImage(EA_summaryDF, "Scan", "EA - Lobular Volume", lower_order=.7, upper_order=1.3, rois=FALSE)
}



# ------------------------ Filter for PK ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	PK_data <- phantom_data[phantom_data$subject_1 == "PK", ]
	PK_vol <- phantom_vol[phantom_vol$subject_1 == "PK", ]
	# Refactor data
	PK_data$winterover <- factor(PK_data$winterover)
	PK_data$subject_1 <- factor(PK_data$subject_1)
	PK_data$Time <- factor(PK_data$Time)

	# cort
	PK_data <- averageLeftAndRight_WeightByVol(PK_vol, PK_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(PK_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	PK_vol <- averageLeftAndRight_Vol(PK_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(PK_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$BasGang <- NULL
	ROI_ListofLists_vol$Limbic <- NULL
	ROI_ListofLists_vol$Cerebellum <- NULL
	PK_vol <- lobeVolumes(PK_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	PK_data <- averageROIsInLobes_WeightByVol(PK_vol, PK_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="cort")
	colnums <- c(grep("FrontOrb", colnames(PK_data)), grep("FrontDors", colnames(PK_data)), grep("Temporal", colnames(PK_data)), grep("Parietal", colnames(PK_data)), grep("Occipital", colnames(PK_data)))
	PK_data <- phantomBetas(PK_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(PK_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	PK_summaryDF <- createSummaryDF(PK_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	PK_cort_plot <- createPhantomGGPlotImage(PK_summaryDF, "Scan", "PK - Lobular Cortical Thickness", lower_order=.7, upper_order=1.3, rois=FALSE, color_vec=c("brown1", "dodgerblue", "goldenrod3"))
} else if (type == "gmd") {
	PK_data <- phantom_data[phantom_data$subject_1 == "PK", ]
	PK_vol <- phantom_vol[phantom_vol$subject_1 == "PK", ]
	# Refactor data
	PK_data$winterover <- factor(PK_data$winterover)
	PK_data$subject_1 <- factor(PK_data$subject_1)
	PK_data$Time <- factor(PK_data$Time)
	# gmd
	PK_data <- averageLeftAndRight_WeightByVol(PK_vol, PK_data, otherString="anatomical_gmd_mean_")
	ROIlist <- grep("_ave_", colnames(PK_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	PK_vol <- averageLeftAndRight_Vol(PK_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(PK_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$Cerebellum <- NULL
	PK_vol <- lobeVolumes(PK_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	PK_data <- averageROIsInLobes_WeightByVol(PK_vol, PK_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="gmd")
	colnums <- c(grep("BasGang", colnames(PK_data)), grep("Limbic", colnames(PK_data)), grep("FrontOrb", colnames(PK_data)), grep("FrontDors", colnames(PK_data)), grep("Temporal", colnames(PK_data)), grep("Parietal", colnames(PK_data)), grep("Occipital", colnames(PK_data)))
	PK_data <- phantomBetas(PK_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(PK_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	PK_summaryDF <- createSummaryDF(PK_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_GMD_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	PK_gmd_plot <- createPhantomGGPlotImage(PK_summaryDF, "Scan", "PK - Lobular Grey Matter Density", lower_order=.7, upper_order=1.3, rois=FALSE, color_vec=c("brown1", "dodgerblue", "goldenrod3"))
} else if (type == "vol") {
	PK_data <- phantom_data[phantom_data$subject_1 == "PK", ]
	# Refactor data
	PK_data$winterover <- factor(PK_data$winterover)
	PK_data$subject_1 <- factor(PK_data$subject_1)
	PK_data$Time <- factor(PK_data$Time)
	PK_data <- averageLeftAndRight_Vol(PK_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(PK_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$Cerebellum <- NULL
	PK_data <- lobeVolumes(PK_data, ROI_ListofLists, lastList=TRUE) 
	colnums <- c(grep("BasGang", colnames(PK_data)), grep("Limbic", colnames(PK_data)), grep("FrontOrb", colnames(PK_data)), grep("FrontDors", colnames(PK_data)), grep("Temporal", colnames(PK_data)), grep("Parietal", colnames(PK_data)), grep("Occipital", colnames(PK_data)))
	PK_data <- phantomBetas(PK_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(PK_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	PK_summaryDF <- createSummaryDF(PK_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_Vol_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	# plot
	PK_vol_plot <- createPhantomGGPlotImage(PK_summaryDF, "Scan", "PK - Lobular Volume", lower_order=.7, upper_order=1.3, rois=FALSE, color_vec=c("brown1", "dodgerblue", "goldenrod3"))
}


# ------------------------ Combined Plot ------------------------ #



# call plotFuncs.R functions
if (type == "cort") {
	# Refactor data
	phantom_data$winterover <- factor(phantom_data$winterover)
	phantom_data$subject_1 <- factor(phantom_data$subject_1)
	phantom_data$Time <- factor(phantom_data$Time)
	# cort
	phantom_data <- averageLeftAndRight_WeightByVol(phantom_vol, phantom_data, otherString="anatomical_corticalThickness_mean_")
	ROIlist <- grep("_ave_", colnames(phantom_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	ROI_ListofLists$Cerebellum <- NULL
	# vol
	phantom_vol <- averageLeftAndRight_Vol(phantom_vol, "_R_", "_L_", "_ave_")
	ROIlist_vol <- grep("_ave_", colnames(phantom_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)
	ROI_ListofLists_vol$BasGang <- NULL
	ROI_ListofLists_vol$Limbic <- NULL
	ROI_ListofLists_vol$Cerebellum <- NULL
	phantom_vol <- lobeVolumes(phantom_vol, ROI_ListofLists_vol, lastList=TRUE) 
	# create lobular definitions
	phantom_data <- averageROIsInLobes_WeightByVol(phantom_vol, phantom_data, ROI_ListofLists_vol, ROI_ListofLists, lastList=TRUE, type="cort")
	colnums <- c(grep("FrontOrb", colnames(phantom_data)), grep("FrontDors", colnames(phantom_data)), grep("Temporal", colnames(phantom_data)), grep("Parietal", colnames(phantom_data)), grep("Occipital", colnames(phantom_data)))
	###### NOT similar to individual plots
	# create summaryDF
	factorsList <- c("Scan")
	ROIlist_Lobe <- c(grep("FrontOrb", colnames(phantom_data), value=TRUE), grep("FrontDors", colnames(phantom_data), value=TRUE), grep("Temporal", colnames(phantom_data), value=TRUE), grep("Parietal", colnames(phantom_data), value=TRUE), grep("Occipital", colnames(phantom_data), value=TRUE))
	phantom_summaryDF <- createSummaryDF(phantom_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT", replacement="", ROIlist=ROIlist_Lobe)
	phantom_cort_plot <- createPhantomGGPlotImage(phantom_summaryDF, "Scan", "Phantom - Lobular Cortical Thickness", lower_order=2.5, upper_order=4.5, rois=FALSE, multiplePhantoms=TRUE)
	###### Similar to individual plots
	phantom_data <- phantomBetas(phantom_data, colnums)
	ROIlist_Lobe <- grep("_tNdivtt1", colnames(phantom_data), value=TRUE)
	# create summaryDF
	factorsList <- c("Scan")
	phantom_summaryDF <- createSummaryDF(phantom_data, factorsList, ROI_ListofLists=c(), stats=TRUE, simpleNames=TRUE, pattern1="", pattern2="_CT_tNdivtt1", replacement="", ROIlist=ROIlist_Lobe)
	phantom_cort_plot <- createPhantomGGPlotImage(phantom_summaryDF, "Scan", "Phantom - Lobular Cortical Thickness", lower_order=.7, upper_order=1.3, rois=FALSE, multiplePhantoms=TRUE)


} else if (type == "gmd") {

} else if (type == "vol") {

}

# ------------------------------------------------------------------------------------------------------------------ #

if (type == "cort") {
	pdf(file = "/home/ebutler/nasa_plots/phantoms_brainLobe_cort.pdf", width=12, height=8)
	print(GR_cort_plot)
	print(BJ_cort_plot)
	print(BM_cort_plot)
	print(EA_cort_plot)
	print(PK_cort_plot)
	dev.off()
} else if (type == "gmd") {
	pdf(file = "/home/ebutler/nasa_plots/phantoms_brainLobe_gmd.pdf", width=12, height=8)
	print(GR_gmd_plot)
	print(BJ_gmd_plot)
	print(BM_gmd_plot)
	print(EA_gmd_plot)
	print(PK_gmd_plot)
	dev.off()
} else if (type == "vol") {
	pdf(file = "/home/ebutler/nasa_plots/phantoms_brainLobe_vol.pdf", width=12, height=8)
	print(GR_vol_plot)
	print(BJ_vol_plot)
	print(BM_vol_plot)
	print(EA_vol_plot)
	print(PK_vol_plot)
	dev.off()
}




