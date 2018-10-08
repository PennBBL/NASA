# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Load the data
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

# Change "subject_2" to "Time"
colnames(nasa_data)[colnames(nasa_data)=="subject_2"] <- "Time"

# Create wo labels
wo2015_vec <- grep("concordia_0", nasa_data[,"subject_1"])
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
	DVColumnNums <- c(grep("FrontOrb", colnames(nasa_data)), grep("FrontDors", colnames(nasa_data)), grep("Temporal", colnames(nasa_data)), grep("Parietal", colnames(nasa_data)), grep("Occipital", colnames(nasa_data)))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
	ROIlist <- grep("_zscore", colnames(nasa_data), value=TRUE)
} else if (type == "gmd") {
	# gmd
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="gmd_")
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
	DVColumnNums <- c(grep("BasGang", colnames(nasa_data)), grep("Limbic", colnames(nasa_data)), grep("FrontOrb", colnames(nasa_data)), grep("FrontDors", colnames(nasa_data)), grep("Temporal", colnames(nasa_data)), grep("Parietal", colnames(nasa_data)), grep("Occipital", colnames(nasa_data)))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
	ROIlist <- grep("_zscore", colnames(nasa_data), value=TRUE)
} else if (type == "vol") {
	nasa_data <- averageLeftAndRight_Vol(nasa_data, "_R_", "_L_", "_ave_")
	ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
	# sum vols within lobe
	nasa_data <- lobeVolumes(nasa_data, ROI_ListofLists)
	# get z-scores
	DVColumnNums <- c(grep("BasGang", colnames(nasa_data)), grep("Limbic", colnames(nasa_data)), grep("FrontOrb", colnames(nasa_data)), grep("FrontDors", colnames(nasa_data)), grep("Temporal", colnames(nasa_data)), grep("Parietal", colnames(nasa_data)), grep("Occipital", colnames(nasa_data)))
	IVColumnNums <- c()
	nasa_data <- regressMultDVs(nasa_data, DVColumnNums, IVColumnNums)
	ROIlist <- grep("_zscore", colnames(nasa_data), value=TRUE)
}


# Plot!!!
### separate by winter
# create summaryDF
factorsList <- c("winterover", "Time")
if (type == "cort") {
	summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", ROIlist)
} else if (type == "gmd") {
	summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", ROIlist) 
} else if (type == "vol") {
	summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", ROIlist) 
}

# wo_2015 plot
if (year == "2015") {
	wo_2015_data <- summaryDF[which(summaryDF$winterover == "wo_2015"), ]
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_2015.pdf", width=12, height=8)
		plot_wo_2015 <- createGGPlotImage(wo_2015_data, "Time", "Cortical thickness changes during WO 2015", rois=FALSE)
		print(plot_wo_2015)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_2015.pdf", width=12, height=8)
		plot_wo_2015 <- createGGPlotImage(wo_2015_data, "Time", "Gray matter density changes during WO 2015", rois=FALSE)
		print(plot_wo_2015)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_2015.pdf", width=12, height=8)
		plot_wo_2015 <- createGGPlotImage(wo_2015_data, "Time", "Volume changes during WO 2015", rois=FALSE)
		print(plot_wo_2015)
		dev.off()
	}
}

# wo_2016 plot
if (year == "2016") {
	wo_2016_data <- summaryDF[which(summaryDF$winterover == "wo_2016"), ]
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_2016.pdf", width=12, height=8)
		plot_wo_2016 <- createGGPlotImage(wo_2016_data, "Time", "Cortical thickness changes during WO 2016", rois=FALSE)
		print(plot_wo_2016)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_2016.pdf", width=12, height=8)
		plot_wo_2016 <- createGGPlotImage(wo_2016_data, "Time", "Gray matter density changes during WO 2016", rois=FALSE)
		print(plot_wo_2016)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_2016.pdf", width=12, height=8)
		plot_wo_2016 <- createGGPlotImage(wo_2016_data, "Time", "Volume changes during WO 2016", rois=FALSE)
		print(plot_wo_2016)
		dev.off()
	}
}


### combined
# create summaryDF
factorsList <- c("Time")
if (type == "cort") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", ROIlist) 
} else if (type == "gmd") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", ROIlist) 
} else if (type == "vol") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", ROIlist) 
}

# combined plot
if (year == "combined") {
	if (type == "cort") {
		pdf(file = "/home/ebutler/nasa_plots/cort_combined.pdf", width=12, height=8)
		plot_combined <- createGGPlotImage(comb_summaryDF, "Time", "Cortical thickness changes over WO 2015 & 2016", rois=FALSE)
		print(plot_combined)
		dev.off()
	} else if (type == "gmd") {
		pdf(file = "/home/ebutler/nasa_plots/gmd_combined.pdf", width=12, height=8)
		plot_combined <- createGGPlotImage(comb_summaryDF, "Time", "Gray matter density changes over WO 2015 & 2016", rois=FALSE)
		print(plot_combined)
		dev.off()
	} else if (type == "vol") {
		pdf(file = "/home/ebutler/nasa_plots/vol_combined.pdf", width=12, height=8)
		plot_combined <- createGGPlotImage(comb_summaryDF, "Time", "Volume changes over WO 2015 & 2016", rois=FALSE)
		print(plot_combined)
		dev.off()
	}
}






