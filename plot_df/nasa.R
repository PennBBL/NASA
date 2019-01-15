# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# --- Select which type of dataset you are using ---
#type <- as.string(args[1]) # "cort", "gmd", "vol"
#year <- as.string(args[2]) # "2015", "2016", "combined"

# Load the data (Adon's version)
if (type == "cort") {
	nasa_cort <- read.csv("/data/jux/BBL/studies/nasa_antartica/processedData/structural/xcpAccel/nasa_cort.csv", header=T)
	nasa_data <- nasa_cort
	nasa_vol <- read.csv("/data/jux/BBL/studies/nasa_antartica/processedData/structural/xcpAccel/nasa_vol.csv", header=T)
} else if (type == "gmd") {
	nasa_gmd <- read.csv("/data/jux/BBL/studies/nasa_antartica/processedData/structural/xcpAccel/nasa_gmd.csv", header=T) 
	nasa_data <- nasa_gmd
	nasa_vol <- read.csv("/data/jux/BBL/studies/nasa_antartica/processedData/structural/xcpAccel/nasa_vol.csv", header=T)
} else if (type == "vol") {
	nasa_vol <- read.csv("/data/jux/BBL/studies/nasa_antartica/processedData/structural/xcpAccel/nasa_vol.csv", header=T)
	nasa_data <- nasa_vol
}

# Load the data (Ellyn's version - slowjlf)
if (type == "cort") {
	nasa_cort <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_CT.csv", header=T)
	nasa_data <- nasa_cort
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=T)
} else if (type == "gmd") {
	nasa_gmd <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv", header=T) 
	nasa_data <- nasa_gmd
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=T)
} else if (type == "vol") {
	nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=T)
	nasa_data <- nasa_vol
}

# Switch "id0" to "winterover" (Ellyn's version)
colnames(nasa_data)[colnames(nasa_data)=="id0"] <- "winterover"
if (type != "vol") {
	colnames(nasa_vol)[colnames(nasa_vol)=="id0"] <- "winterover"
}

# Switch "id1" to "subject_1" (Ellyn's version)
colnames(nasa_data)[colnames(nasa_data)=="id1"] <- "subject_1"
if (type != "vol") {
	colnames(nasa_vol)[colnames(nasa_vol)=="id1"] <- "subject_1"
}

# Switch "id2" to "Time" (Ellyn's version)
colnames(nasa_data)[colnames(nasa_data)=="id2"] <- "Time"
if (type != "vol") {
	colnames(nasa_vol)[colnames(nasa_vol)=="id2"] <- "Time"
}


# Filter for crew and controls --- Containerized pipeline (Ellyn's version)
nasa_data <- nasa_data[nasa_data$winterover != "phantoms", ]
if (type != "vol") {
	nasa_vol <- nasa_vol[nasa_vol$winterover != "phantoms", ]
}

# Create a column that specifies Crew or Control... MAKE SURE NO PHANTOMS
crew_vec <- grep("concordia", nasa_data[,"subject_1"])
nasa_data$CrewStatus <- NA
num_rows = nrow(nasa_data)
for (i in 1:num_rows) {
	if (i %in% crew_vec) {
		nasa_data[i, "CrewStatus"] <- "Crew"
	} else {
		nasa_data[i, "CrewStatus"] <- "Control"
	}
}
if (type != "vol") {
	nasa_vol$CrewStatus <- NA
	num_rows = nrow(nasa_vol)
	for (i in 1:num_rows) {
		if (i %in% crew_vec) {
			nasa_vol[i, "CrewStatus"] <- "Crew"
		} else {
			nasa_vol[i, "CrewStatus"] <- "Control"
		}
	}
}


# Filter for subjects who have all three time points
nasa_data <- filterAllTimepoints(nasa_data, "subject_1", "Time", 3)
if (type != "vol") {
	nasa_vol <- filterAllTimepoints(nasa_vol, "subject_1", "Time", 3)
}

# Re-factor data
nasa_data$Time <- factor(nasa_data$Time)
if (type != "vol") {
	nasa_vol$Time <- factor(nasa_vol$Time)
}
nasa_data$subject_1 <- factor(nasa_data$subject_1)
if (type != "vol") {
	nasa_vol$subject_1 <- factor(nasa_vol$subject_1)
}
nasa_data$winterover <- factor(nasa_data$winterover)
if (type != "vol") {
	nasa_vol$winterover <- factor(nasa_vol$winterover)
}

# Change "subject_2" to "Time" (Adon's version)
colnames(nasa_data)[colnames(nasa_data)=="subject_2"] <- "Time"

# Create wo labels (Adon's version)
wo2015_vec <- c(grep("concordia_0", nasa_data[,"subject_1"]), grep("DLR_0", nasa_data[,"subject_1"]))
nasa_data$winterover <- NA
num_rows = nrow(nasa_data)
for (i in 1:num_rows) {
	if (i %in% wo2015_vec) {
		nasa_data[i, "winterover"] <- "wo_2015"
	} else {
		nasa_data[i, "winterover"] <- "wo_2016"
	}
}

# Call plotFuncs.R functions
if (type == "cort") {
	# cort
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="anatomical_corticalThickness_mean_")
	DVColumnNums <- grep("_ave_", colnames(nasa_data))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
	ROIlist <- grep("_zscore", colnames(nasa_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
	# vol
	nasa_vol <- averageLeftAndRight_Vol(nasa_vol, "_R_", "_L_", "_ave_")
	DVColumnNums_vol <- grep("_ave_", colnames(nasa_vol))
	IVColumnNums_vol <- c()
	nasa_vol <- regressMultDVs(nasa_vol, DVColumnNums_vol, IVColumnNums_vol)
	ROIlist_vol <- grep("_zscore", colnames(nasa_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "gmd") {
	# gmd
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="anatomical_gmd_mean_")
	DVColumnNums <- grep("_ave_", colnames(nasa_data))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
	ROIlist <- grep("_zscore", colnames(nasa_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	# vol
	nasa_vol <- averageLeftAndRight_Vol(nasa_vol, "_R_", "_L_", "_ave_")
	DVColumnNums_vol <- grep("_ave_", colnames(nasa_vol))
	IVColumnNums_vol <- c()
	nasa_vol <- regressMultDVs(nasa_vol, DVColumnNums_vol, IVColumnNums_vol)
	ROIlist_vol <- grep("_zscore", colnames(nasa_vol), value=TRUE)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
} else if (type == "vol") {
	nasa_data <- averageLeftAndRight_Vol(nasa_data, "_R_", "_L_", "_ave_")
	DVColumnNums <- grep("_ave_", colnames(nasa_data))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
	ROIlist <- grep("_zscore", colnames(nasa_data), value=TRUE)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}


# Call plotFuncs.R functions that create lobular indices
if (type == "cort") {
	# vol
	ROIlist_tmp_vol <- grep("_ave_", colnames(nasa_vol), value=TRUE)
	keep_vol <- !grepl("_zscore", ROIlist_tmp_vol)
	ROIlist_vol <- subset(ROIlist_tmp_vol, keep_vol)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_Raw_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_Raw_vol <- removeUnderScore(ROI_ListofLists_Raw_vol)	
	ROI_ListofLists_Raw_vol$BasGang <- NULL
	ROI_ListofLists_Raw_vol$Limbic <- NULL
	# cort
	ROIlist_tmp_cort <- grep("_ave_", colnames(nasa_data), value=TRUE)
	keep_cort <- !grepl("_zscore", ROIlist_tmp_cort)
	ROIlist_cort <- subset(ROIlist_tmp_cort, keep_cort)
	ROIlist_cort <- addUnderScore(ROIlist_cort)
	ROI_ListofLists_Raw_cort <- roiLobes(ROIlist_cort, lobeDef=FALSE)
	ROI_ListofLists_Raw_cort <- removeUnderScore(ROI_ListofLists_Raw_cort)
	ROI_ListofLists_Raw_cort$BasGang <- NULL
	ROI_ListofLists_Raw_cort$Limbic <- NULL
} else if (type == "gmd") { 
	# vol
	ROIlist_tmp_vol <- grep("_ave_", colnames(nasa_vol), value=TRUE)
	keep_vol <- !grepl("_zscore", ROIlist_tmp_vol)
	ROIlist_vol <- subset(ROIlist_tmp_vol, keep_vol)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_Raw_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_Raw_vol <- removeUnderScore(ROI_ListofLists_Raw_vol)	
	# gmd
	ROIlist_tmp_gmd <- grep("_ave_", colnames(nasa_data), value=TRUE)
	keep_gmd <- !grepl("_zscore", ROIlist_tmp_gmd)
	ROIlist_gmd <- subset(ROIlist_tmp_gmd, keep_gmd)
	ROIlist_gmd <- addUnderScore(ROIlist_gmd)
	ROI_ListofLists_Raw_gmd <- roiLobes(ROIlist_gmd, lobeDef=FALSE)
	ROI_ListofLists_Raw_gmd <- removeUnderScore(ROI_ListofLists_Raw_gmd)
} else if (type == "vol") {
	ROIlist_tmp <- grep("_ave_", colnames(nasa_data), value=TRUE)
	keep <- !grepl("_zscore", ROIlist_tmp)
	ROIlist <- subset(ROIlist_tmp, keep)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists_Raw <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists_Raw <- removeUnderScore(ROI_ListofLists_Raw)
}

if (type == "cort") {
	nasa_vol <- lobeVolumes(nasa_vol, ROI_ListofLists_Raw_vol)
	nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Raw_vol, ROI_ListofLists_Raw_cort, type="cort")
} else if (type == "gmd") {
	nasa_vol <- lobeVolumes(nasa_vol, ROI_ListofLists_Raw_vol)
	nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Raw_vol, ROI_ListofLists_Raw_gmd, type="gmd")
} else if (type == "vol") {
	nasa_data <- lobeVolumes(nasa_data, ROI_ListofLists_Raw)
}

# Z-score lobe values
if (type == "cort") { 
	DVColumnNums <- c()
	DVColumnNums <- grep("_CT", colnames(nasa_data))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
} else if (type == "gmd") { 
	DVColumnNums <- c()
	DVColumnNums <- grep("_GMD", colnames(nasa_data))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
} else if (type == "vol") {
	DVColumnNums <- grep("_Vol", colnames(nasa_data))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
}





### separate by winter
# create summaryDF
factorsList <- c("winterover", "Time")
if (type == "cort") {
	summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_") 
} else if (type == "gmd") {
	summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_") 
} else if (type == "vol") {
	summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists) 
}

# wo_2015 plot
if (year == "2015") {
	wo_2015_data <- summaryDF[which(summaryDF$winterover == "wo_2015"), ]
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_2015.pdf", width=12, height=8)
		plot_wo_2015 <- createGGPlotImage(wo_2015_data, "Time", "Cortical thickness changes during WO 2015", lower_order=-1.3)
		print(plot_wo_2015)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_2015.pdf", width=12, height=8)
		plot_wo_2015 <- createGGPlotImage(wo_2015_data, "Time", "Gray matter density changes during WO 2015", upper_order=1.1)
		print(plot_wo_2015)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_2015.pdf", width=12, height=8)
		plot_wo_2015 <- createGGPlotImage(wo_2015_data, "Time", "Volume changes during WO 2015")
		print(plot_wo_2015)
		dev.off()
	}
}

# wo_2016 plot
if (year == "2016") {
	wo_2016_data <- summaryDF[which(summaryDF$winterover == "wo_2016"), ]
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_2016.pdf", width=12, height=8)
		plot_wo_2016 <- createGGPlotImage(wo_2016_data, "Time", "Cortical thickness changes during WO 2016", lower_order=-1.3)
		print(plot_wo_2016)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_2016.pdf", width=12, height=8)
		plot_wo_2016 <- createGGPlotImage(wo_2016_data, "Time", "Gray matter density changes during WO 2016")
		print(plot_wo_2016)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_2016.pdf", width=12, height=8)
		plot_wo_2016 <- createGGPlotImage(wo_2016_data, "Time", "Volume changes during WO 2016")
		print(plot_wo_2016)
		dev.off()
	}
}

### combined - just crew
# create summaryDF
factorsList <- c("Time")
if (type == "cort") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_") 
} else if (type == "gmd") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_") 
} else if (type == "vol") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists) 
}

# combined plot
if (year == "combined") {
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_combined.pdf", width=12, height=8)
		plot_combined <- createGGPlotImage(comb_summaryDF, "Time", "Cortical thickness changes over WO 2015 & 2016")
		print(plot_combined)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_combined.pdf", width=12, height=8)
		plot_combined <- createGGPlotImage(comb_summaryDF, "Time", "Gray matter density changes over WO 2015 & 2016", upper_order=1.3)
		print(plot_combined)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_combined.pdf", width=12, height=8)
		plot_combined <- createGGPlotImage(comb_summaryDF, "Time", "Volume changes over WO 2015 & 2016")
		print(plot_combined)
		dev.off()
	}
}

####### combined - crew and controls
#### ROIs
# create summaryDF 
factorsList <- c("Time", "CrewStatus")
if (type == "cort") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_corticalThickness_mean_miccai_ave_") 
} else if (type == "gmd") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_") 
} else if (type == "vol") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists) 
}

# summaryDF for Crew
crew_comb_summaryDF <- comb_summaryDF[comb_summaryDF$CrewStatus == "Crew", ]

# summaryDF for Controls
controls_comb_summaryDF <- comb_summaryDF[comb_summaryDF$CrewStatus == "Control", ]


# combined plot
if (year == "combined") {
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_slowjlf_combined_crew.pdf", width=12, height=8)
		crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew - Cortical thickness", lower_order =-2)
		print(crew_plot_combined)
		dev.off()

		pdf(file = "/home/ebutler/nasa_plots/cort_slowjlf_combined_controls.pdf", width=12, height=8)
		control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls - Cortical thickness", lower_order =-2)
		print(control_plot_combined)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_slowjlf_combined_crew.pdf", width=12, height=8)
		crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew - Gray matter density", upper_order=1.3)
		print(crew_plot_combined)
		dev.off()

		pdf(file = "/home/ebutler/nasa_plots/gmd_slowjlf_combined_controls.pdf", width=12, height=8)
		control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls - Gray matter density", upper_order=1.3)
		print(control_plot_combined)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_slowjlf_combined_crew.pdf", width=12, height=8)
		crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew - Volume")
		print(crew_plot_combined)
		dev.off()

		pdf(file = "/home/ebutler/nasa_plots/vol_slowjlf_combined_controls.pdf", width=12, height=8)
		controls_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls - Volume")
		print(controls_plot_combined)
		dev.off()
	}
}

#### Lobes
# create summaryDF 
factorsList <- c("Time", "CrewStatus")
if (type == "cort") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists = c(), pattern1="", pattern2="_CT_zscore", ROIlist=c("FrontOrb_CT_zscore", "FrontDors_CT_zscore", "Temporal_CT_zscore", "Parietal_CT_zscore", "Occipital_CT_zscore")) 
} else if (type == "gmd") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists = c(), pattern1="", pattern2="_GMD_zscore", ROIlist=c("FrontOrb_GMD_zscore", "FrontDors_GMD_zscore", "Temporal_GMD_zscore", "Parietal_GMD_zscore", "Occipital_GMD_zscore")) 
} else if (type == "vol") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists = c(), pattern1="", pattern2="_Vol_zscore", ROIlist=c("BasGang_Vol_zscore", "Limbic_Vol_zscore", "FrontOrb_Vol_zscore", "FrontDors_Vol_zscore", "Temporal_Vol_zscore", "Parietal_Vol_zscore", "Occipital_Vol_zscore")) 
}

# summaryDF for Crew
crew_comb_summaryDF <- comb_summaryDF[comb_summaryDF$CrewStatus == "Crew", ]

# summaryDF for Controls
controls_comb_summaryDF <- comb_summaryDF[comb_summaryDF$CrewStatus == "Control", ]


# combined plot
if (year == "combined") {
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_combined_lobes_crew.pdf", width=12, height=8)
		crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew - Cortical thickness", lower_order=-2, rois=FALSE)
		print(crew_plot_combined)
		dev.off()

		pdf(file = "/home/ebutler/nasa_plots/cort_combined_lobes_controls.pdf", width=12, height=8)
		control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls - Cortical thickness", rois=FALSE)
		print(control_plot_combined)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_combined_lobes_crew.pdf", width=12, height=8)
		crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew - Gray matter density", rois=FALSE)
		print(crew_plot_combined)
		dev.off()

		pdf(file = "/home/ebutler/nasa_plots/gmd_combined_lobes_controls.pdf", width=12, height=8)
		control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls - Gray matter density", rois=FALSE)
		print(control_plot_combined)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_combined_lobes_crew.pdf", width=12, height=8)
		crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew - Volume", rois=FALSE)
		print(crew_plot_combined)
		dev.off()

		pdf(file = "/home/ebutler/nasa_plots/vol_combined_lobes_controls.pdf", width=12, height=8)
		controls_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls - Volume", rois=FALSE)
		print(controls_plot_combined)
		dev.off()
	}
}
























