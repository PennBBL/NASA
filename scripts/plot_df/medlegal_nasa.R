# Source my functions
source("/home/ebutler/scripts/plotFuncs.R")

##### Plot condordia_001 at t00 against all other subjects at all other times
# --- Select which type of dataset you are using ---
type <- "vol" # "cort", "gmd", "vol"

# Load the data
if (type == "cort") {
	nasa_cort <- read.csv("/data/jux/BBL/studies/nasa/processedData/structural/xcpAccel/nasa_cort.csv", header=T)
	nasa_data <- nasa_cort
	nasa_vol <- read.csv("/data/jux/BBL/studies/nasa/processedData/structural/xcpAccel/nasa_vol.csv", header=T)
} else if (type == "gmd") {
	nasa_gmd <- read.csv("/data/jux/BBL/studies/nasa/processedData/structural/xcpAccel/nasa_gmd.csv", header=T) 
	nasa_data <- nasa_gmd
	nasa_vol <- read.csv("/data/jux/BBL/studies/nasa/processedData/structural/xcpAccel/nasa_vol.csv", header=T)
} else if (type == "vol") {
	nasa_vol <- read.csv("/data/jux/BBL/studies/nasa/processedData/structural/xcpAccel/nasa_vol.csv", header=T)
	nasa_data <- nasa_vol
}

# Change "subject_2" to "Time" #ERB: make these changes to nasa_vol when type isn't "vol"
colnames(nasa_data)[colnames(nasa_data)=="subject_2"] <- "Time"

# average left and right
if (type == "cort") {
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="anatomical_corticalThickness_mean_")
} else if (type == "gmd") {
	nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, otherString="anatomical_gmd_mean_")
} else if (type == "vol") {
	nasa_data <- averageLeftAndRight_Vol(nasa_data, "_R_", "_L_", "_ave_")
}
ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE) # "BasFor" missing (at least from vol)

# ---USER---: Subset this list to get rid of unwanted ROIs
ROIlist <- ROIlist[-4] # index for cerebellum var
ROIlist <- addUnderScore(ROIlist)

if (type == "cort") {
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists$BasGang <- NULL
	ROI_ListofLists$Limbic <- NULL
} else if (type == "gmd") {
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
} else if (type == "vol") {
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
}

# remove underscores from ROI_ListofLists
ROI_ListofLists <- removeUnderScore(ROI_ListofLists)

# remove underscores from ROIlist
ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
ROIlist <- ROIlist[-4]

# subset nasa_data
retainCols <- c("subject_1", "Time", ROIlist)
nasa_data <- nasa_data[,retainCols]

# create summaryDF
factorsList <- c()
if (type == "cort") {
	summaryDF <- subjectCompare("concordia_001", "t00", "subject_1", "Time", 3:58, factorsList, ROI_ListofLists, nasa_data, pattern1="anatomical_corticalThickness_mean_miccai_ave_", pattern2="") 
} else if (type == "gmd") {
	summaryDF <- subjectCompare("concordia_001", "t00", "subject_1", "Time", 3:58, factorsList, ROI_ListofLists, nasa_data, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="") 
} else if (type == "vol") {
	summaryDF <- subjectCompare("concordia_001", "t00", "subject_1", "Time", 3:58, factorsList, ROI_ListofLists, nasa_data, pattern1="vol_miccai_ave_", pattern2="") 
}



# create plot #ERB: CHANGE
if (type == "cort") {
	plot <- createGGPlotImage(dataframe=summaryDF, factor="", plotTitle="Cortical Thickness Z-Scores for Subject Compared to Group")
} else if (type == "gmd") {
	plot <- createGGPlotImage(dataframe=summaryDF, factor="", plotTitle="Grey Matter Density Z-Scores for Subject Compared to Group")
} else if (type == "vol") {
	plot <- createGGPlotImage(dataframe=summaryDF, factor="", plotTitle="Volume Z-Scores for Concordia_001 at t00 Compared to All Others", lower_order=-2.5, upper_order=.5, increment=.2)
}


















