### This script creates ROI and Lobe plots for the normed (MeanSD) crew members and controls
### for brain vol and gmd (without pallidum) and hippocampal vol
###
### Ellyn Butler
### December 11, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Read in the data
if (type == "gmd") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_normedMeanSD_brain_gmd.csv", header=T)
} else if (type == "vol") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_normedMeanSD_brain_vol.csv", header=T)
} else if (type == "hippovol") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_normedMeanSD_hippo_vol.csv", header=T)
}




#### Create ROI plots
# Call plotFuncs.R functions
if (type == "gmd") {
	# gmd
	ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)	
	# vol
	ROIlist_vol <- grep("_ave_", colnames(nasa_vol), value=TRUE)
	ROIlist_vol <- addUnderScore(ROIlist_vol)
	ROI_ListofLists_vol <- roiLobes(ROIlist_vol, lobeDef=FALSE)
	ROI_ListofLists_vol <- removeUnderScore(ROI_ListofLists_vol)	
} else if (type == "vol") {
	ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)	
} 

factorsList <- c("Time", "group")
if (type == "gmd") {
	comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="") 
} else if (type == "vol") {
	comb_summaryDF <- comb_summaryDF <- createSummaryDF(nasa_data, factorsList, ROI_ListofLists, pattern2="") 
} 

# summaryDF for Crew and Controls
crew_comb_summaryDF <- comb_summaryDF[comb_summaryDF$group == "Crew", ]
controls_comb_summaryDF <- comb_summaryDF[comb_summaryDF$group == "Control", ]

# Create plots
if (type == "gmd") {
	pdf(file = "/home/ebutler/nasa_plots/gmd_rois_normedMeanSD_crew.pdf", width=12, height=8)
	crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew (Z-norm) - Gray matter density", upper_order=2.4)
	print(crew_plot_combined)
	dev.off()

	pdf(file = "/home/ebutler/nasa_plots/gmd_rois_normedMeanSD_controls.pdf", width=12, height=8)
	control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls (Z-norm) - Gray matter density", upper_order=2.4)
	print(control_plot_combined)
	dev.off()
} else if (type == "vol") {
	pdf(file = "/home/ebutler/nasa_plots/vol_rois_normedMeanSD_crew.pdf", width=12, height=8)
	crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew (Z-norm) - Volume", upper_order=7, lower_order=-2)
	print(crew_plot_combined)
	dev.off()

	pdf(file = "/home/ebutler/nasa_plots/vol_rois_normedMeanSD_controls.pdf", width=12, height=8)
	controls_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls (Z-norm) - Volume", upper_order=7, lower_order=-2)
	print(controls_plot_combined)
	dev.off()
}



#### Create Lobe/Hippo plots
factorsList <- c("Time", "group")
if (type == "gmd") {
	ROIlist <- c("BasGang_GMD", "Limbic_GMD", "FrontOrb_GMD", "FrontDors_GMD", "Temporal_GMD", "Parietal_GMD", "Occipital_GMD", "AGMD")
	summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", pattern2="_GMD", ROIlist=ROIlist) 
} else if (type == "vol") {
	ROIlist <- c("BasGang_Vol", "Limbic_Vol", "FrontOrb_Vol", "FrontDors_Vol", "Temporal_Vol", "Parietal_Vol", "Occipital_Vol", "AHGMV")
	summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="", pattern2="_Vol", ROIlist=ROIlist) 
} else if (type == "hippovol") {
	ROIlist <- c("vol_princeton_ave_CA1", "vol_princeton_ave_CA23", "vol_princeton_ave_DG", "vol_princeton_ave_ERC", "vol_princeton_ave_PHC", "vol_princeton_ave_PRC", "vol_princeton_ave_SUB", "vol_princeton_ave_hippo")
	summaryDF <- createSummaryDF(nasa_data, factorsList, list(), pattern1="vol_princeton_ave_", pattern2="", ROIlist=ROIlist) 
}

# summaryDF for Crew and Controls
crew_comb_summaryDF <- summaryDF[summaryDF$group == "Crew", ]
controls_comb_summaryDF <- summaryDF[summaryDF$group == "Control", ]

# Create plots
if (type == "gmd") {
	pdf(file = "/home/ebutler/nasa_plots/gmd_lobes_normedMeanSD_crew.pdf", width=12, height=8)
	crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew (Z-norm) - Gray matter density", upper_order=3.5, rois=FALSE)
	print(crew_plot_combined)
	dev.off()

	pdf(file = "/home/ebutler/nasa_plots/gmd_lobes_normedMeanSD_controls.pdf", width=12, height=8)
	control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls (Z-norm) - Gray matter density", upper_order=3.5, rois=FALSE)
	print(control_plot_combined)
	dev.off()
} else if (type == "vol") {
	pdf(file = "/home/ebutler/nasa_plots/vol_lobes_normedMeanSD_crew.pdf", width=12, height=8)
	crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew (Z-norm) - Volume", upper_order=2, lower_order=-1, rois=FALSE)
	print(crew_plot_combined)
	dev.off()

	pdf(file = "/home/ebutler/nasa_plots/vol_lobes_normedMeanSD_controls.pdf", width=12, height=8)
	controls_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls (Z-norm) - Volume", upper_order=2, lower_order=-1, rois=FALSE)
	print(controls_plot_combined)
	dev.off()
} else if (type == "hippovol") {
	pdf(file = "/home/ebutler/nasa_plots/vol_hippo_normedMeanSD_crew.pdf", width=12, height=8)
	crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew (Z-norm) - Hippocampal Volume", upper_order=3.5, lower_order=-5, increment=.5, rois=FALSE)
	print(crew_plot_combined)
	dev.off()

	pdf(file = "/home/ebutler/nasa_plots/vol_hippo_normedMeanSD_controls.pdf", width=12, height=8)
	controls_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls (Z-norm) - Hippocampal Volume", upper_order=3.5, lower_order=-5, increment=.5, rois=FALSE)
	print(controls_plot_combined)
	dev.off()
}











