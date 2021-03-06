### Script to create boxplots with dots for QC purposes
###
### Ellyn Butler
### October 18, 2018


# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Load the data produced by nasa.R
if (type == "cort") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_quickjlf_CT_computedvalues.csv", header=TRUE)
	string <- "_CT"
} else if (type == "gmd") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_quickjlf_gmd_computedvalues.csv", header=TRUE)
	string <- "_GMD"
} else if (type == "vol") {
	nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_quickjlf_vol_computedvalues.csv", header=TRUE)
	string <- "_Vol"
}

# Melt and filter nasa_data so that "variable" just contains rows with "_Vol"
melted_data <- melt(nasa_data)
if (type == "vol") {
	allLobe_vec <- grep("_Vol", colnames(nasa_data), value=TRUE)
}
include_vec <- !(grepl("_zscore", allLobe_vec))
rawLobe_vec <- allLobe_vec[include_vec]
lobe_melted_data <- melted_data[melted_data$variable == rawLobe_vec, ]

# Summary lobe box/dotplots
summary_boxdot <- ggplot(lobe_melted_data, aes(variable, value)) + geom_boxplot() + geom_dotplot(binaxis='y', stackdir='center', dotsize=1)

# Time by lobe box/dotplots
crew_data <- nasa_data[nasa_data$CrewStatus == "Crew", ]
contol_data <- nasa_data[nasa_data$CrewStatus == "Control", ]

BasGang_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("BasGang", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25) 

Limbic_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("Limbic", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25)

FrontOrb_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("FrontOrb", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25)

FrontDors_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("FrontDors", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25)

Temporal_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("Temporal", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25)

Parietal_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("Parietal", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25)

Occipital_crew_boxdot <- ggplot(crew_data, aes_string(x="Time", y=paste0("Occipital", string))) + stat_summary(fun.data=MinMeanSEMMax, geom="boxplot", colour="turquoise4") + geom_dotplot(binaxis='y', stackdir='center', dotsize=.25)


# Save plots
filename <- paste0("/home/ebutler/nasa_plots/quality_control/", type, 
pdf(file = "/home/ebutler/nasa_plots/quality_control/vol_crew_qc.pdf", width=6, height=6)
print(BasGang_crew_boxdot)
print(Limbic_crew_boxdot)
print(FrontOrb_crew_boxdot)
print(FrontDors_crew_boxdot)
print(Temporal_crew_boxdot)
print(Parietal_crew_boxdot)
print(Occipital_crew_boxdot)
dev.off()







