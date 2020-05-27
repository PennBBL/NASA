### This script creates lobe plots for volume, gmd, reho, alff, FA and MD norming using a pooled mean and SD, and with 
### a phantom mean and SD. It also does the same for the volume of hippocampal subfields.
###
### Ellyn Butler
### May 21, 2019 - June 5, 2019 (CGN Phantoms changed June 18, 2019)

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
library('dplyr')
library('gridExtra')

# Read in the data
nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_strucRestDTI_KoshaTaki.csv")

# Remove BJ... messes with interpretability of phantom plots, and should not be used for scaling
nasa_data$subject_1 <- factor(nasa_data$subject_1)
nasa_data$Time <- factor(nasa_data$Time)
nasa_data$sub_id <- factor(nasa_data$sub_id)
nasa_data$ses_id <- factor(nasa_data$ses_id)

# Remove z columns (just so you don't have to edit this script a bunch)
nasa_data <- nasa_data[, !(grepl("z_", colnames(nasa_data)))]
rownames(nasa_data) <- 1:nrow(nasa_data)

# Define functions
roundTo <- function(x, multiple, FUN) { 
	if (FUN == "ceiling") {	ceiling(x/multiple)*multiple 
	} else if (FUN == "floor") { floor(x/multiple)*multiple 
	}
}

# Remove values for subjects who fail QA (structural metrics with MeanGMD > 3 SDs... subjects with too much motion already removed)
nasa_data$Remove <- 0

for (i in 1:nrow(nasa_data)) {
	if ((nasa_data[i, "Quality_MeanGMD"] > mean(nasa_data$Quality_MeanGMD) + 2.5*sd(nasa_data$Quality_MeanGMD)) | (nasa_data[i, "Quality_MeanGMD"] < mean(nasa_data$Quality_MeanGMD) - 2.5*sd(nasa_data$Quality_MeanGMD))) {
		nasa_data[i, "Remove"] <- 1
	}
}

for (i in 1:nrow(nasa_data)) {
	if (nasa_data[i, "Remove"] == 1) {
		nasa_data[i, grepl("_GMD", colnames(nasa_data))] <- NA
		nasa_data[i, "AGMD"] <- NA
		nasa_data[i, grepl("_Vol", colnames(nasa_data))] <- NA
	}
}



#### ----------- Create plots that normed with a pooled and phantomed mean and SD ----------- ####
####### -------------------- Norm -------------------- #######
### ----- Pooled ----- ###
brain <- colnames(nasa_data)[16:91]
pooled_df <- nasa_data %>% mutate_each_(funs(scale(.) %>% as.vector), vars=brain)

### ----- Phantomed ----- ###
phantom_data <- nasa_data[nasa_data$group == "Phantom", ]
phantom_data$subject_1 <- factor(phantom_data$subject_1)

# get the columns that are ROIs
col_names <- colnames(phantom_data)
nonroicols <- c("subid", "winterover", "subject_1", "Time", "sub_id", "ses_id", "group", "scanner", "PatientSex", "PatientSize", "PatientWeight", "PatientBirthDate", "AcquisitionDate", "PatientAgeYears", "Quality_MeanGMD", "Remove")
TF_vec <- c()
for (i in 1:length(col_names)) {
	if (col_names[[i]] %in% nonroicols) {
		TF_vec <- c(TF_vec, FALSE)
	} else {
		TF_vec <- c(TF_vec, TRUE)
	}
}
roicols <- subset(col_names, TF_vec)

## Mean and SD summary dataframes
round_df <- function(df, digits) {
	nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))
	df[,nums] <- round(df[,nums], digits = digits)
	(df)
}

# *** phantom summary *** #
phantom_summary <- data.frame(matrix(NA, nrow=length(roicols), ncol=7))
colnames(phantom_summary) <- c("ROI", "Mean_CGN", "SD_CGN", "Mean_CHR", "SD_CHR", "Mean_HOB", "SD_HOB")
phantom_summary$ROI <- roicols
for (i in 1:length(roicols)) {
	roi <- roicols[[i]]
	# CGN
	#phantom_summary[i, "Mean_CGN"] <- (mean(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t1", roi]) + mean(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t4", roi]))/2
	phantom_summary[i, "Mean_CGN"] <- mean(phantom_data[phantom_data$scanner == "CGN", roi])
	phantom_summary[i, "SD_CGN"] <- sd(phantom_data[phantom_data$scanner == "CGN" & phantom_data$Time == "t1", roi])
	# CHR
	phantom_summary[i, "Mean_CHR"] <- mean(phantom_data[phantom_data$scanner == "CHR", roi])
	phantom_summary[i, "SD_CHR"] <- sd(phantom_data[phantom_data$scanner == "CHR", roi])
	# HOB
	phantom_summary[i, "Mean_HOB"] <- mean(phantom_data[phantom_data$scanner == "HOB", roi])
	phantom_summary[i, "SD_HOB"] <- sd(phantom_data[phantom_data$scanner == "HOB", roi])
}
phantom_summary_gmd <- round_df(phantom_summary[1:7,], digits=4)
colnames(phantom_summary_gmd) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")
phantom_summary_vol <- round_df(phantom_summary[9:15,], digits=0)
colnames(phantom_summary_vol) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")
phantom_summary_reho <- round_df(phantom_summary[18:24,], digits=4)
colnames(phantom_summary_reho) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")
phantom_summary_alff <- round_df(phantom_summary[28:34,], digits=0)
colnames(phantom_summary_alff) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")
phantom_summary_hippovol <- round_df(phantom_summary[38:45,], digits=2)
colnames(phantom_summary_hippovol) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")
phantom_summary_fa <- round_df(phantom_summary[c(48, 51, 54, 57, 58, 59, 62, 65, 68, 71),], digits=8)
colnames(phantom_summary_fa) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")
phantom_summary_md <- round_df(phantom_summary[72:76,], digits=8)
colnames(phantom_summary_md) <- c("Region (Phantoms)", "CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD")

# *** crew/control summary *** #
cc_data <- nasa_data[nasa_data$group == "Crew" | nasa_data$group == "Control", ]
cc_summary <- data.frame(matrix(NA, nrow=length(roicols), ncol=9))
colnames(cc_summary) <- c("ROI", "Mean_CGN_Crew", "SD_CGN_Crew", "Mean_CHR_Crew", "SD_CHR_Crew", "Mean_HOB_Crew", "SD_HOB_Crew", "Mean_CGN_Control", "SD_CGN_Control")
cc_summary$ROI <- roicols
for (i in 1:length(roicols)) {
	roi <- roicols[[i]]
	# CGN Crew
	cc_summary[i, "Mean_CGN_Crew"] <- mean(cc_data[cc_data$scanner == "CGN" & cc_data$group == "Crew", roi], na.rm =TRUE)
	cc_summary[i, "SD_CGN_Crew"] <- sd(cc_data[cc_data$scanner == "CGN" & cc_data$group == "Crew", roi], na.rm =TRUE)
	# CHR Crew
	cc_summary[i, "Mean_CHR_Crew"] <- mean(cc_data[cc_data$scanner == "CHR" & cc_data$group == "Crew", roi], na.rm =TRUE)
	cc_summary[i, "SD_CHR_Crew"] <- sd(cc_data[cc_data$scanner == "CHR" & cc_data$group == "Crew", roi], na.rm =TRUE)
	# HOB Crew
	cc_summary[i, "Mean_HOB_Crew"] <- mean(cc_data[cc_data$scanner == "HOB" & cc_data$group == "Crew", roi], na.rm =TRUE)
	cc_summary[i, "SD_HOB_Crew"] <- sd(cc_data[cc_data$scanner == "HOB" & cc_data$group == "Crew", roi], na.rm =TRUE)
	# CGN Controls
	cc_summary[i, "Mean_CGN_Control"] <- mean(cc_data[cc_data$scanner == "CGN" & cc_data$group == "Control", roi], na.rm =TRUE)
	cc_summary[i, "SD_CGN_Control"] <- sd(cc_data[cc_data$scanner == "CGN" & cc_data$group == "Control", roi], na.rm =TRUE)
}
cc_summary_gmd <- round_df(cc_summary[1:7,], digits=4)
colnames(cc_summary_gmd) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")
cc_summary_vol <- round_df(cc_summary[9:15,], digits=0)
colnames(cc_summary_vol) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")
cc_summary_reho <- round_df(cc_summary[18:24,], digits=4)
colnames(cc_summary_reho) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")
cc_summary_alff <- round_df(cc_summary[28:34,], digits=0)
colnames(cc_summary_alff) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")
cc_summary_hippovol <- round_df(cc_summary[38:45,], digits=2)
colnames(cc_summary_hippovol) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")
cc_summary_fa <- round_df(cc_summary[c(48, 51, 54, 57, 58, 59, 62, 65, 68, 71),], digits=8)
colnames(cc_summary_fa) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")
cc_summary_md <- round_df(cc_summary[72:76,], digits=8)
colnames(cc_summary_md) <- c("Region", "Crew: CGN Mean", "CGN SD", "CHR Mean", "CHR SD", "HOB Mean", "HOB SD", "Controls: CGN Mean", "CGN SD")

# transform crew and controls by phantom parameters
phantomed_df <- nasa_data[nasa_data$group != "Phantom", ]
phantomed_df$subject_1 <- factor(phantomed_df$subject_1)
phantomed_df$group <- factor(phantomed_df$group)
phantomed_df$winterover <- factor(phantomed_df$winterover)
phantomed_df$sub_id <- factor(phantomed_df$sub_id)
phantomed_df$ses_id <- factor(phantomed_df$ses_id)

for (i in 1:nrow(phantomed_df)) {
	# loop through each roi for a subject
	for (j in 1:ncol(phantomed_df)) {
		# identify the roi
		roi <- colnames(phantomed_df[j])
		if (roi %in% roicols) {
			if (phantomed_df[i, "scanner"] == "CGN") {
				phantomed_df[i, roi] <- (phantomed_df[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN"]
			} else if (phantomed_df[i, "scanner"] == "CHR") {
				phantomed_df[i, roi] <- (phantomed_df[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CHR"])/phantom_summary[phantom_summary$ROI == roi, "SD_CHR"]
			} else { # HOB
				phantomed_df[i, roi] <- (phantomed_df[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_HOB"])/phantom_summary[phantom_summary$ROI == roi, "SD_HOB"]				
			}
		}
	}
}

####### -------------------- Plot -------------------- #######
types <- c("gmd", "vol", "reho", "alff", "hippovol", "fa", "md")

factorsList <- c("Time")
for (norm in c("pooled", "phantomed")) {
	for (type in types) {
		# Get the correct dataframe
		if (norm == "pooled") { 
			df <- pooled_df 
			title.info <- "(Normed w/ Pooled)"
			pdf.info <- "_normedPooled.pdf"
		} else { 
			df <- phantomed_df 
			title.info <- "(Normed w/ Phantoms)"
			pdf.info <- "_normedPhantomed.pdf"
		}
		# Get the correct modality information
		if (type == "gmd") {
			ROIlist <- c("BasGang_GMD", "Limbic_GMD", "FrontOrb_GMD", "FrontDors_GMD", "Temporal_GMD", "Parietal_GMD", "Occipital_GMD")
			pattern1 <- ""
			pattern2 <- "_GMD"
			plot.title <- "Gray Matter Density"
		} else if (type == "vol") {
			ROIlist <- c("BasGang_Vol", "Limbic_Vol", "FrontOrb_Vol", "FrontDors_Vol", "Temporal_Vol", "Parietal_Vol", "Occipital_Vol")
			pattern1 <- ""
			pattern2 <- "_Vol"
			plot.title <- "Gray Matter Volume"
		} else if (type == "reho") {
			ROIlist <- c("BasGang_REHO", "Limbic_REHO", "FrontOrb_REHO", "FrontDors_REHO", "Temporal_REHO", "Parietal_REHO", "Occipital_REHO")
			pattern1 <- ""
			pattern2 <- "_REHO"
			plot.title <- "Regional Homogeneity"

			df <- df[!(is.na(df$BasGang_REHO)),]
		} else if (type == "alff") {
			ROIlist <- c("BasGang_ALFF", "Limbic_ALFF", "FrontOrb_ALFF", "FrontDors_ALFF", "Temporal_ALFF", "Parietal_ALFF", "Occipital_ALFF")
			pattern1 <- ""
			pattern2 <- "_ALFF"
			plot.title <- "Amp of Low Freq Fluc"

			df <- df[!(is.na(df$BasGang_ALFF)),]
		} else if (type == "hippovol") {
			ROIlist <- c("vol_princeton_ave_CA1", "vol_princeton_ave_CA23", "vol_princeton_ave_DG", "vol_princeton_ave_ERC", "vol_princeton_ave_PHC", "vol_princeton_ave_PRC", "vol_princeton_ave_SUB", "vol_princeton_ave_hippo")
			pattern1 <- "vol_princeton_ave_"
			pattern2 <- ""
			plot.title <- "Hippocampal Volumes"
		} else if (type == "fa") {
			ROIlist <- c("ATR", "CGC", "CGH", "CST", "Forceps_Major", "Forceps_Minor", "IFO", "ILF", "SLF", "UF")
			pattern1 <- ""
			pattern2 <- ""
			plot.title <- "Fractional Anisotropy"

			df <- df[!(is.na(df$ATR)),]
		} else if (type == "md") {
			ROIlist <- c("FrontOrb_MD", "FrontDors_MD", "Temporal_MD", "Parietal_MD", "Occipital_MD")
			pattern1 <- ""
			pattern2 <- "_MD"
			plot.title <- "Mean Diffusivity"

			df <- df[!(is.na(df$FrontOrb_MD)),]
		}

		csv.name <- paste0("/home/ebutler/plots/nasa_antartica/BADBJ_", type, pdf.info)
	
		# Create group dataframes
		crew_df <- df[df$group == "Crew", ]
		control_df <- df[df$group == "Control", ]
		if (norm == "pooled") { phantom_df <- df[df$group == "Phantom", ] }

		### Crew
		crew_df$Time <- factor(crew_df$Time)
		crew_df$group <- factor(crew_df$group)
		summaryDF_crew <- createSummaryDF(crew_df, c("Time"), list(), pattern1=pattern1, pattern2=pattern2, ROIlist=ROIlist) 

		# Make t0 the zero line
		beg <- nrow(summaryDF_crew)/3 + 1
		j <- 1
		for (i in beg:nrow(summaryDF_crew)) {
			print(paste(summaryDF_crew[i, "ROI_name"], summaryDF_crew[i, "Time"], summaryDF_crew[j, "ROI_name"], summaryDF_crew[j, "Time"]))
			summaryDF_crew[i, "ROI_mean"] <- summaryDF_crew[i, "ROI_mean"] - summaryDF_crew[j, "ROI_mean"]
			if (j < beg-1) { j <- j+1
			} else { j <- 1 }
		}
		for (i in 1:(beg-1)) { summaryDF_crew[i, "ROI_mean"] <- 0 }

		# Rename time points 
		summaryDF_crew$Time[summaryDF_crew$Time == "t0"] <- "P-P" ###
		summaryDF_crew$Time[summaryDF_crew$Time == "t12"] <- "R-P"
		summaryDF_crew$Time[summaryDF_crew$Time == "t18"] <- "F-P"	
	
		summaryDF_crew$Time <- factor(summaryDF_crew$Time)
		summaryDF_crew$Time <- factor(summaryDF_crew$Time,levels(summaryDF_crew$Time)[c(2, 3, 1)])
		crew_title <- paste0("Crew ", title.info, " - ", plot.title)
	 #############

		### Controls
		control_df$Time <- factor(control_df$Time)
		control_df$group <- factor(control_df$group)
		summaryDF_control <- createSummaryDF(control_df, c("Time"), list(), pattern1=pattern1, pattern2=pattern2, ROIlist=ROIlist) 

		# Make t0 the zero line
		beg <- nrow(summaryDF_control)/3 + 1
		j <- 1
		for (i in beg:nrow(summaryDF_control)) {
			print(paste(summaryDF_control[i, "ROI_name"], summaryDF_control[i, "Time"], summaryDF_control[j, "ROI_name"], summaryDF_control[j, "Time"]))
			summaryDF_control[i, "ROI_mean"] <- summaryDF_control[i, "ROI_mean"] - summaryDF_control[j, "ROI_mean"]
			if (j < beg-1) { j <- j+1
			} else { j <- 1 }
		}
		for (i in 1:(beg-1)) { summaryDF_control[i, "ROI_mean"] <- 0 }

		# Rename time points 
		summaryDF_control$Time[summaryDF_control$Time == "t0"] <- "P-P" ###
		summaryDF_control$Time[summaryDF_control$Time == "t12"] <- "R-P"
		summaryDF_control$Time[summaryDF_control$Time == "t18"] <- "F-P"	
	
		summaryDF_control$Time <- factor(summaryDF_control$Time)
		summaryDF_control$Time <- factor(summaryDF_control$Time,levels(summaryDF_control$Time)[c(2, 3, 1)])

		control_title <- paste0("Controls ", title.info, " - ", plot.title)

		### Phantoms
		if (norm == "pooled") {
			phantom_df$scanner <- factor(phantom_df$scanner)
			phantom_df$group <- factor(phantom_df$group)
			summaryDF_phantom <- createSummaryDF(phantom_df, c("scanner"), list(), pattern1=pattern1, pattern2=pattern2, ROIlist=ROIlist) ### Is this working?

			# Make t0 the zero line
			beg <- nrow(summaryDF_phantom)/3 + 1
			j <- 1
			for (i in beg:nrow(summaryDF_phantom)) {
				print(paste(summaryDF_phantom[i, "ROI_name"], summaryDF_phantom[i, "Time"], summaryDF_phantom[j, "ROI_name"], summaryDF_phantom[j, "Time"]))
				summaryDF_phantom[i, "ROI_mean"] <- summaryDF_phantom[i, "ROI_mean"] - summaryDF_phantom[j, "ROI_mean"]
				if (j < beg-1) { j <- j+1
				} else { j <- 1 }
			}
			for (i in 1:(beg-1)) { summaryDF_phantom[i, "ROI_mean"] <- 0 }

			# Rename scanner column
			names(summaryDF_phantom)[names(summaryDF_phantom) == 'scanner'] <- 'Scanner'
			
			phantom_title <- paste0("Phantoms ", title.info, " - ", plot.title)
		}

		### Decide on upper and lower bounds
		lower_order <- 0
		upper_order <- 0
		if (norm == "pooled") { dfs <- c("summaryDF_crew", "summaryDF_control", "summaryDF_phantom")
		} else { dfs <- c("summaryDF_crew", "summaryDF_control") }

		for (i in 1:nrow(summaryDF_crew)) {
			for (j in 1:length(dfs)) {
				if (dfs[[j]] == "summaryDF_crew" | dfs[[j]] == "summaryDF_control") {
					boo <- get(dfs[[j]])
					current_low <- roundTo(boo[i, "ROI_mean"] - 2*boo[i, "ROI_se"], .5, "floor")
					current_high <- roundTo(boo[i, "ROI_mean"] + 2*boo[i, "ROI_se"], .5, "ceiling")
					if (current_low < lower_order) { lower_order <- current_low }
					if (current_high > upper_order) { upper_order <- current_high }
				} else if (dfs[[j]] == "summaryDF_phantom" & norm == "pooled") {
					boo <- get(dfs[[j]])
					current_low <- roundTo(boo[i, "ROI_mean"] - 2*boo[i, "ROI_se"], .5, "floor")
					current_high <- roundTo(boo[i, "ROI_mean"] + 2*boo[i, "ROI_se"], .5, "ceiling")
					if (current_low < lower_order) { lower_order <- current_low }
					if (current_high > upper_order) { upper_order <- current_high }
				}
			}
		}
		if ((abs(lower_order) < 2*abs(upper_order)) | (abs(upper_order) < 2*abs(lower_order))) {
			if (abs(lower_order) > abs(upper_order)) { upper_order <- abs(lower_order)
			} else { lower_order <- -abs(upper_order) }
		}

		####### Plots #######

		crew_plot <- createGGPlotImage(summaryDF_crew, "Time", crew_title, lower_order=lower_order, upper_order=upper_order, increment=.5, rois=FALSE, ylabel="Z-Score (95% CI)", builtInColors=FALSE, color_vec=c("black", "red", "blue"))
		control_plot <- createGGPlotImage(summaryDF_control, "Time", control_title, lower_order=lower_order, upper_order=upper_order, increment=.5, rois=FALSE, ylabel="Z-Score (95% CI)", builtInColors=FALSE, color_vec=c("black", "red", "blue"))
		phantom_plot <- createGGPlotImage(summaryDF_phantom, "Scanner", phantom_title, lower_order=lower_order, upper_order=upper_order, increment=.5, rois=FALSE, ylabel="Z-Score (95% CI)", builtInColors=FALSE, color_vec=c("black", "red", "blue"))

		# export plots
		phantom_table <- get(paste0("phantom_summary_", type))
		cc_table <- get(paste0("cc_summary_", type))

		if (norm == "pooled") {
			pdf(file = csv.name, width=12, height=8)
			grid.arrange(crew_plot)
			grid.arrange(control_plot)
			grid.arrange(phantom_plot)
			grid.arrange(tableGrob(phantom_table))
			grid.arrange(tableGrob(cc_table))
			dev.off()
		} else {
			pdf(file = csv.name, width=12, height=8)
			grid.arrange(crew_plot)
			grid.arrange(control_plot)
			grid.arrange(tableGrob(phantom_table))
			grid.arrange(tableGrob(cc_table))
			dev.off()
		}
	}
}











