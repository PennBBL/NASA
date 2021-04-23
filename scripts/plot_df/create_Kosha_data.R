### This script combines all of the data the Kosha asked for
###
### Ellyn Butler
### December 17, 2018... edited June 1-5, 2019 (previously output without Rest or DTI)

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
source("/home/ebutler/scripts/nasa_PHI/makeREDCapFriendly_NASAAntartica.R")
library('plyr')


### ---------- Ellyn's GMD ---------- ###
# Read in the data
data1 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_brain_gmd.csv', header=T)

# Put in REDCap indicators
data1 <- makeREDCapFriendly_NASAAntartica(data1)

### ---------- Ellyn's Volume ---------- ###
# Read in the data
data2 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_brain_vol.csv', header=T)
data2$CGMV <- (data2$FrontOrb_Vol + data2$FrontDors_Vol + data2$Temporal_Vol + data2$Parietal_Vol + data2$Occipital_Vol)*2

### ---------- Hippo ---------- ###
# Read in the data
data3 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_hippo_vol.csv', header=T)

### ---------- Demographics ---------- ###
# Read in the data
data4 <- read.csv('/home/ebutler/erb_data/nasa/nasa_antartica_demographics.csv', header=T)

### ---------- Total Brain metrics ---------- ###
# Read in the data
data5 <- read.csv('/home/ebutler/erb_data/nasa/nasa_WhiteMatterVolume.csv', header=T)

data5$WMV <- data5$R_Cerebral_White_Matter + data5$L_Cerebral_White_Matter

### ---------- REHO ---------- ###
data6 <- read.csv('/home/ebutler/erb_data/nasa/nasa_rawLobesGlobal_reho.csv', header=T)

### ---------- ALFF ---------- ###
data7 <- read.csv('/home/ebutler/erb_data/nasa/nasa_rawLobesGlobal_alff.csv', header=T)

### ---------- QUALITY ---------- ###
data8 <- read.csv('/home/ebutler/erb_data/nasa/nasa_T1w_quality.csv', header=T)
data8 <- data8[,c("winterover", "subject_1", "Time", "meanGMD")]
colnames(data8) <- c("winterover", "subject_1", "Time", "Quality_MeanGMD")

### ---------- FA ---------- ###
data9 <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_fa.csv', header=T)

### ---------- MD ---------- ###
data10 <- read.csv('/home/ebutler/erb_data/nasa/nasa_rawWLobe_md.csv', header=T)
data10 <- data10[,c("subject_1", "Time", "FrontOrb_MD", "FrontDors_MD", "Temporal_MD", "Parietal_MD", "Occipital_MD")]


##################### Merge the data #####################

final_data <- merge(data1, data2)
final_data <- merge(final_data, data3)
final_data <- merge(final_data, data4)
final_data <- merge(final_data, data5)
final_data <- merge(final_data, data6)
final_data <- merge(final_data, data7)
final_data <- merge(final_data, data8)
final_data <- merge(final_data, data9)
final_data <- merge(final_data, data10)

# Rename gray and white matter volume variables
names(final_data)[names(final_data) == 'CGMV'] <- 'Cortical_Vol'
names(final_data)[names(final_data) == 'WMV'] <- 'WhiteMatter_Vol'

# Rename reho and alff global columns
names(final_data)[names(final_data) == 'anatomical_reho_mean_segmentation_CSF'] <- 'CSF_REHO'
names(final_data)[names(final_data) == 'anatomical_reho_mean_segmentation_GM'] <- 'GrayMatter_REHO'
names(final_data)[names(final_data) == 'anatomical_reho_mean_segmentation_WM'] <- 'WhiteMatter_REHO'
names(final_data)[names(final_data) == 'anatomical_alff_mean_segmentation_CSF'] <- 'CSF_ALFF'
names(final_data)[names(final_data) == 'anatomical_alff_mean_segmentation_GM'] <- 'GrayMatter_ALFF'
names(final_data)[names(final_data) == 'anatomical_alff_mean_segmentation_WM'] <- 'WhiteMatter_ALFF'

# Reorder columns
KoshaTaki <- final_data[,c("subid", "winterover", "subject_1", "Time", "sub_id", "ses_id", "group", "scanner", "PatientSex", "PatientSize", "PatientWeight", "PatientBirthDate", "AcquisitionDate", "PatientAgeYears", "Quality_MeanGMD", "BasGang_GMD", "Limbic_GMD", "FrontOrb_GMD", "FrontDors_GMD", "Temporal_GMD", "Parietal_GMD", "Occipital_GMD", "AGMD", "BasGang_Vol", "Limbic_Vol", "FrontOrb_Vol", "FrontDors_Vol", "Temporal_Vol", "Parietal_Vol", "Occipital_Vol", "Cortical_Vol", "WhiteMatter_Vol", "BasGang_REHO", "Limbic_REHO", "FrontOrb_REHO", "FrontDors_REHO", "Temporal_REHO", "Parietal_REHO", "Occipital_REHO", "CSF_REHO", "GrayMatter_REHO", "WhiteMatter_REHO", "BasGang_ALFF", "Limbic_ALFF", "FrontOrb_ALFF", "FrontDors_ALFF", "Temporal_ALFF", "Parietal_ALFF", "Occipital_ALFF", "CSF_ALFF", "GrayMatter_ALFF", "WhiteMatter_ALFF", "vol_princeton_ave_CA1", "vol_princeton_ave_CA23", "vol_princeton_ave_DG", "vol_princeton_ave_ERC", "vol_princeton_ave_PHC", "vol_princeton_ave_PRC", "vol_princeton_ave_SUB", "vol_princeton_ave_hippo", "ATR_L", "ATR_R", "ATR", "CGG_L", "CGG_R", "CGC", "CGH_L", "CGH_R", "CGH", "CST_L", "CST_R", "CST", "Forceps_Major", "Forceps_Minor", "L_IFO", "R_IFO", "IFO", "L_ILF", "R_ILF", "ILF", "L_SLF", "R_SLF", "SLF", "L_UF", "R_UF", "UF", "FrontOrb_MD", "FrontDors_MD", "Temporal_MD", "Parietal_MD", "Occipital_MD")]

##################### Create normed columns #####################

phantom_data <- KoshaTaki[KoshaTaki$group == "Phantom" & KoshaTaki$subject_1 != "BJ", ]
phantom_data$subject_1 <- factor(phantom_data$subject_1)

# get the columns that are ROIs
col_names <- colnames(phantom_data)
nonroicols <- c("subid", "winterover", "subject_1", "Time", "sub_id", "ses_id", "group", "scanner", "PatientSex", "PatientSize", "PatientWeight", "PatientBirthDate", "AcquisitionDate", "PatientAgeYears", "Quality_MeanGMD")
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
	phantom_summary[i, "Mean_CGN"] <- mean(phantom_data[phantom_data$scanner == "CGN", roi])
	phantom_summary[i, "SD_CGN"] <- sd(phantom_data[phantom_data$scanner == "CGN", roi])
	# CHR
	phantom_summary[i, "Mean_CHR"] <- mean(phantom_data[phantom_data$scanner == "CHR", roi])
	phantom_summary[i, "SD_CHR"] <- sd(phantom_data[phantom_data$scanner == "CHR", roi])
	# HOB
	phantom_summary[i, "Mean_HOB"] <- mean(phantom_data[phantom_data$scanner == "HOB", roi])
	phantom_summary[i, "SD_HOB"] <- sd(phantom_data[phantom_data$scanner == "HOB", roi])
}


# transform crew and controls by phantom parameters
phantomed_df <- KoshaTaki
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
			newroi <- paste0("z_", roi)
			if (phantomed_df[i, "scanner"] == "CGN") {
				phantomed_df[i, newroi] <- (phantomed_df[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CGN"])/phantom_summary[phantom_summary$ROI == roi, "SD_CGN"]
			} else if (phantomed_df[i, "scanner"] == "CHR") {
				phantomed_df[i, newroi] <- (phantomed_df[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_CHR"])/phantom_summary[phantom_summary$ROI == roi, "SD_CHR"]
			} else { # HOB
				phantomed_df[i, newroi] <- (phantomed_df[i, roi] - phantom_summary[phantom_summary$ROI == roi, "Mean_HOB"])/phantom_summary[phantom_summary$ROI == roi, "SD_HOB"]
			}
		}
	}
}


##################### Write the data #####################

write.csv(phantomed_df, file='/home/ebutler/erb_data/nasa/nasa_strucRestDTI_KoshaTaki.csv', row.names=F)
