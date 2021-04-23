### This script creates ROI and Lobe plots for the normed (MeanSD) and raw values for crew members and controls
### for brain vol and gmd (without pallidum) and hippocampal vol 
###
### Ellyn Butler
### December 11, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
library('gridExtra')

# Read in the data
if (type == "gmd") {
	nasa_data_z <- read.csv("/home/ebutler/erb_data/nasa/nasa_normedMeanSD_brain_gmd.csv", header=T)
	nasa_data_raw <- read.csv("/home/ebutler/erb_data/nasa/nasa_raw_brain_gmd.csv", header=T)
} else if (type == "vol") {
	nasa_data_z <- read.csv("/home/ebutler/erb_data/nasa/nasa_normedMeanSD_brain_vol.csv", header=T)
	nasa_data_raw <- read.csv("/home/ebutler/erb_data/nasa/nasa_raw_brain_vol.csv", header=T)
} else if (type == "hippovol") {
	nasa_data_z <- read.csv("/home/ebutler/erb_data/nasa/nasa_normedMeanSD_hippo_vol.csv", header=T)
	nasa_data_raw <- read.csv("/home/ebutler/erb_data/nasa/nasa_raw_hippo_vol.csv", header=T)
}

# Remove phantoms from raw
toBeRemoved <- which(nasa_data_raw$group == "Phantom")
nasa_data_raw <- nasa_data_raw[-toBeRemoved,]

# Re-factor
nasa_data_raw$group <- factor(nasa_data_raw$group)
nasa_data_raw$subject_1 <- factor(nasa_data_raw$subject_1)
nasa_data_raw$Time <- factor(nasa_data_raw$Time)


#### Create ROI plots
# Call plotFuncs.R functions
if (type == "gmd") {
	# gmd
	ROIlist <- grep("_ave_", colnames(nasa_data_z), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)	
} else if (type == "vol") {
	ROIlist <- grep("_ave_", colnames(nasa_data_z), value=TRUE)
	ROIlist <- addUnderScore(ROIlist)
	ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
	ROI_ListofLists <- removeUnderScore(ROI_ListofLists)	
} 

factorsList <- c("Time", "group")
if (type == "gmd") {
	z_comb_summaryDF <- createSummaryDF(nasa_data_z, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="")
	raw_comb_summaryDF <- createSummaryDF(nasa_data_raw, factorsList, ROI_ListofLists, pattern1="anatomical_gmd_mean_miccai_ave_", pattern2="")
} else if (type == "vol") {
	z_comb_summaryDF <- comb_summaryDF <- createSummaryDF(nasa_data_z, factorsList, ROI_ListofLists, pattern2="") 
	raw_comb_summaryDF <- comb_summaryDF <- createSummaryDF(nasa_data_raw, factorsList, ROI_ListofLists, pattern2="") 
} 


# summaryDF for Crew and Controls
z_crew_comb_summaryDF <- z_comb_summaryDF[z_comb_summaryDF$group == "Crew", ]
z_controls_comb_summaryDF <- z_comb_summaryDF[z_comb_summaryDF$group == "Control", ]
raw_crew_comb_summaryDF <- raw_comb_summaryDF[raw_comb_summaryDF$group == "Crew", ]
raw_controls_comb_summaryDF <- raw_comb_summaryDF[raw_comb_summaryDF$group == "Control", ]

if (type == "vol") {
	#### For Volume
	### Plots
	## BasGang
	# Crew
	z_basgang_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "BasGang", ]
	z_basgang_crew_plot <- createGGPlotImage(z_basgang_crew_comb_summaryDF, "Time", "Crew (Z-norm) - BasGang Vol", upper_order=2, lower_order=-2, increment=.5, rois=FALSE)
	raw_basgang_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "BasGang", ]
	raw_basgang_crew_plot <- createGGPlotImage(raw_basgang_crew_comb_summaryDF, "Time", "Crew (Raw) - BasGang Vol", upper_order=9000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_basgang_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "BasGang", ]
	z_basgang_controls_plot <- createGGPlotImage(z_basgang_controls_comb_summaryDF, "Time", "Controls (Z-norm) - BasGang Vol", upper_order=2, lower_order=-2, increment=.5, rois=FALSE)
	raw_basgang_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "BasGang", ]
	raw_basgang_controls_plot <- createGGPlotImage(raw_basgang_controls_comb_summaryDF, "Time", "Controls (Raw) - BasGang Vol", upper_order=9000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")

	## Limbic
	# Crew
	z_limbic_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "Limbic", ]
	z_limbic_crew_plot <- createGGPlotImage(z_limbic_crew_comb_summaryDF, "Time", "Crew (Z-norm) - Limbic Vol", upper_order=7, lower_order=-1, increment=.5, rois=FALSE)
	raw_limbic_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "Limbic", ]
	raw_limbic_crew_plot <- createGGPlotImage(raw_limbic_crew_comb_summaryDF, "Time", "Crew (Raw) - Limbic Vol", upper_order=6000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_limbic_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "Limbic", ]
	z_limbic_controls_plot <- createGGPlotImage(z_limbic_controls_comb_summaryDF, "Time", "Controls (Z-norm) - Limbic Vol", upper_order=4, lower_order=-1, increment=.5, rois=FALSE)
	raw_limbic_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "Limbic", ]
	raw_limbic_controls_plot <- createGGPlotImage(raw_limbic_controls_comb_summaryDF, "Time", "Controls (Raw) - Limbic Vol", upper_order=6000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")

	## FrontOrb
	# Crew
	z_frontorb_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "FrontOrb", ]
	z_frontorb_crew_plot <- createGGPlotImage(z_frontorb_crew_comb_summaryDF, "Time", "Crew (Z-norm) - FrontOrb Vol", upper_order=4, lower_order=-2, increment=.5, rois=FALSE)
	raw_frontorb_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "FrontOrb", ]
	raw_frontorb_crew_plot <- createGGPlotImage(raw_frontorb_crew_comb_summaryDF, "Time", "Crew (Raw) - FrontOrb Vol", upper_order=6000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_frontorb_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "FrontOrb", ]
	z_frontorb_controls_plot <- createGGPlotImage(z_frontorb_controls_comb_summaryDF, "Time", "Controls (Z-norm) - FrontOrb Vol", upper_order=4, lower_order=-2, increment=.5, rois=FALSE)
	raw_frontorb_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "FrontOrb", ]
	raw_frontorb_controls_plot <- createGGPlotImage(raw_frontorb_controls_comb_summaryDF, "Time", "Controls (Raw) - FrontOrb Vol", upper_order=6000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")

	## FrontDors
	# Crew
	z_frontdors_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "FrontDors", ]
	z_frontdors_crew_plot <- createGGPlotImage(z_frontdors_crew_comb_summaryDF, "Time", "Crew (Z-norm) - FrontDors Vol", upper_order=2, lower_order=-1, increment=.5, rois=FALSE)
	raw_frontdors_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "FrontDors", ]
	raw_frontdors_crew_plot <- createGGPlotImage(raw_frontdors_crew_comb_summaryDF, "Time", "Crew (Raw) - FrontDors Vol", upper_order=20000, lower_order=0, increment=2000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_frontdors_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "FrontDors", ]
	z_frontdors_controls_plot <- createGGPlotImage(z_frontdors_controls_comb_summaryDF, "Time", "Controls (Z-norm) - FrontDors Vol", upper_order=2, lower_order=-1, increment=.5, rois=FALSE)
	raw_frontdors_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "FrontDors", ]
	raw_frontdors_controls_plot <- createGGPlotImage(raw_frontdors_controls_comb_summaryDF, "Time", "Controls (Raw) - FrontDors Vol", upper_order=20000, lower_order=0, increment=2000, rois=FALSE, ylabel="Volume mm3")

	## Temporal
	# Crew
	z_temporal_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "Temporal", ]
	z_temporal_crew_plot <- createGGPlotImage(z_temporal_crew_comb_summaryDF, "Time", "Crew (Z-norm) - Temporal Vol", upper_order=6, lower_order=-1, increment=.5, rois=FALSE)
	raw_temporal_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "Temporal", ]
	raw_temporal_crew_plot <- createGGPlotImage(raw_temporal_crew_comb_summaryDF, "Time", "Crew (Raw) - Temporal Vol", upper_order=16000, lower_order=0, increment=2000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_temporal_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "Temporal", ]
	z_temporal_controls_plot <- createGGPlotImage(z_temporal_controls_comb_summaryDF, "Time", "Controls (Z-norm) - Temporal Vol", upper_order=6, lower_order=-1, increment=.5, rois=FALSE)
	raw_temporal_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "Temporal", ]
	raw_temporal_controls_plot <- createGGPlotImage(raw_temporal_controls_comb_summaryDF, "Time", "Controls (Raw) - Temporal Vol", upper_order=16000, lower_order=0, increment=2000, rois=FALSE, ylabel="Volume mm3")

	## Parietal
	# Crew
	z_parietal_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "Parietal", ]
	z_parietal_crew_plot <- createGGPlotImage(z_parietal_crew_comb_summaryDF, "Time", "Crew (Z-norm) - Parietal Vol", upper_order=1.5, lower_order=-1, increment=.5, rois=FALSE)
	raw_parietal_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "Parietal", ]
	raw_parietal_crew_plot <- createGGPlotImage(raw_parietal_crew_comb_summaryDF, "Time", "Crew (Raw) - Parietal Vol", upper_order=12000, lower_order=0, increment=2000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_parietal_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "Parietal", ]
	z_parietal_controls_plot <- createGGPlotImage(z_parietal_controls_comb_summaryDF, "Time", "Controls (Z-norm) - Parietal Vol", upper_order=1.5, lower_order=-1, increment=.5, rois=FALSE)
	raw_parietal_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "Parietal", ]
	raw_parietal_controls_plot <- createGGPlotImage(raw_parietal_controls_comb_summaryDF, "Time", "Controls (Raw) - Parietal Vol", upper_order=12000, lower_order=0, increment=2000, rois=FALSE, ylabel="Volume mm3")

	## Occipital
	# Crew
	z_occipital_crew_comb_summaryDF <- z_crew_comb_summaryDF[z_crew_comb_summaryDF$Lobe == "Occipital", ]
	z_occipital_crew_plot <- createGGPlotImage(z_occipital_crew_comb_summaryDF, "Time", "Crew (Z-norm) - Occipital Vol", upper_order=5, lower_order=-2, increment=.5, rois=FALSE)
	raw_occipital_crew_comb_summaryDF <- raw_crew_comb_summaryDF[raw_crew_comb_summaryDF$Lobe == "Occipital", ]
	raw_occipital_crew_plot <- createGGPlotImage(raw_occipital_crew_comb_summaryDF, "Time", "Crew (Raw) - Occipital Vol", upper_order=9000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")
	# Controls
	z_occipital_controls_comb_summaryDF <- z_controls_comb_summaryDF[z_controls_comb_summaryDF$Lobe == "Occipital", ]
	z_occipital_controls_plot <- createGGPlotImage(z_occipital_controls_comb_summaryDF, "Time", "Controls (Z-norm) - Occipital Vol", upper_order=5, lower_order=-2, increment=.5, rois=FALSE)
	raw_occipital_controls_comb_summaryDF <- raw_controls_comb_summaryDF[raw_controls_comb_summaryDF$Lobe == "Occipital", ]
	raw_occipital_controls_plot <- createGGPlotImage(raw_occipital_controls_comb_summaryDF, "Time", "Controls (Raw) - Occipital Vol", upper_order=9000, lower_order=0, increment=1000, rois=FALSE, ylabel="Volume mm3")
}

# Create pdfs
if (type == "gmd") {
	#pdf(file = "/home/ebutler/nasa_plots/gmd_rois_normedMeanSD_crew.pdf", width=12, height=8)
	#crew_plot_combined <- createGGPlotImage(crew_comb_summaryDF, "Time", "Crew (Z-norm) - Gray matter density", upper_order=2.4)
	#print(crew_plot_combined)
	#dev.off()

	#pdf(file = "/home/ebutler/nasa_plots/gmd_rois_normedMeanSD_controls.pdf", width=12, height=8)
	#control_plot_combined <- createGGPlotImage(controls_comb_summaryDF, "Time", "Controls (Z-norm) - Gray matter density", upper_order=2.4)
	#print(control_plot_combined)
	#dev.off()
} else if (type == "vol") {
	pdf(file = "/home/ebutler/nasa_plots/vol_rois_MeanSDvsRaw_crewcontrols.pdf", width=30, height=8)
	grid.arrange(z_basgang_crew_plot, raw_basgang_crew_plot, z_basgang_controls_plot, raw_basgang_controls_plot, ncol=4)
	grid.arrange(z_limbic_crew_plot, raw_limbic_crew_plot, z_limbic_controls_plot, raw_limbic_controls_plot, ncol=4)
	grid.arrange(z_frontorb_crew_plot, raw_frontorb_crew_plot, z_frontorb_controls_plot, raw_frontorb_controls_plot, ncol=4)
	grid.arrange(z_frontdors_crew_plot, raw_frontdors_crew_plot, z_frontdors_controls_plot, raw_frontdors_controls_plot, ncol=4)
	grid.arrange(z_temporal_crew_plot, raw_temporal_crew_plot, z_temporal_controls_plot, raw_temporal_controls_plot, ncol=4)
	grid.arrange(z_parietal_crew_plot, raw_parietal_crew_plot, z_parietal_controls_plot, raw_parietal_controls_plot, ncol=4)
	grid.arrange(z_occipital_crew_plot, raw_occipital_crew_plot, z_occipital_controls_plot, raw_occipital_controls_plot, ncol=4)
	dev.off()

}



#################################### Create Lobe/Hippo plots ####################################
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











