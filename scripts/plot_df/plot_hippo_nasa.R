### This script averages L and R hippocampal rois for surfume and surface area and gives total hippocampal metrics
###
### Ellyn Butler
### November 12, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_hippo_jlfcllite.csv", header=T)
nasa_data$winterover <- as.factor(nasa_data$winterover)
nasa_data$subject_1 <- as.factor(nasa_data$subject_1)
nasa_data$Time <- as.factor(nasa_data$Time)

volcol <- c("winterover", "subject_1", "Time", "vol_princeton_L_CA1", "vol_princeton_L_CA23", "vol_princeton_L_DG", "vol_princeton_L_ERC", "vol_princeton_L_PHC", "vol_princeton_L_PRC", "vol_princeton_L_SUB", "vol_princeton_R_CA1", "vol_princeton_R_CA23", "vol_princeton_R_DG", "vol_princeton_R_ERC", "vol_princeton_R_PHC", "vol_princeton_R_PRC", "vol_princeton_R_SUB")

nasa_pixdim <- read.csv("/home/ebutler/erb_data/nasa/nasa_pixdim_hippo.csv", header=T)

nasa_data <- nasa_data[, volcol]
nasa_data_mm3 <- nasa_data
for (i in 1:nrow(nasa_data_mm3)) {
	winterover <- as.character(nasa_data_mm3[i, "winterover"])
	subject_1 <- as.character(nasa_data_mm3[i, "subject_1"])
	Time <- as.character(nasa_data_mm3[i, "Time"])
	# pixel product
	subj_rownum <- as.numeric(rownames(nasa_pixdim[nasa_pixdim$winterover == winterover & nasa_pixdim$subject_1 == subject_1 & nasa_pixdim$Time == Time,])) 
	pixvolmm3 <- nasa_pixdim[subj_rownum, "pixdim1"] * nasa_pixdim[subj_rownum, "pixdim2"] * nasa_pixdim[subj_rownum, "pixdim3"]
	for (j in 4:ncol(nasa_data_mm3)) {
		nasa_data_mm3[i, j] <- nasa_data_mm3[i, j] * pixvolmm3
	}
}

# Plots
# vol
# data for histograms (all participants, but with averages)
nasa_data_mm3$vol_princeton_L_hippo <- nasa_data_mm3$vol_princeton_L_CA1 + nasa_data_mm3$vol_princeton_L_CA23 + nasa_data_mm3$vol_princeton_L_DG + nasa_data_mm3$vol_princeton_L_ERC + nasa_data_mm3$vol_princeton_L_PHC + nasa_data_mm3$vol_princeton_L_PRC + nasa_data_mm3$vol_princeton_L_SUB
nasa_data_mm3$vol_princeton_R_hippo <- nasa_data_mm3$vol_princeton_R_CA1 + nasa_data_mm3$vol_princeton_R_CA23 + nasa_data_mm3$vol_princeton_R_DG + nasa_data_mm3$vol_princeton_R_ERC + nasa_data_mm3$vol_princeton_R_PHC + nasa_data_mm3$vol_princeton_R_PRC + nasa_data_mm3$vol_princeton_R_SUB
nasa_data_mm3 <- averageLeftAndRight_Vol(nasa_data_mm3, "_R_", "_L_", "_ave_")

# Histograms
hist_vol_princeton_ave_hippo <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_hippo)) + geom_histogram()
hist_vol_princeton_ave_CA1 <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_CA1)) + geom_histogram()
hist_vol_princeton_ave_CA23 <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_CA23)) + geom_histogram()
hist_vol_princeton_ave_DG <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_DG)) + geom_histogram()
hist_vol_princeton_ave_ERC <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_ERC)) + geom_histogram()
hist_vol_princeton_ave_PHC <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_PHC)) + geom_histogram()
hist_vol_princeton_ave_PRC <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_PRC)) + geom_histogram()
hist_vol_princeton_ave_SUB <- ggplot(nasa_data_mm3, aes(x=vol_princeton_ave_SUB)) + geom_histogram()

pdf(file = "/home/ebutler/nasa_plots/nasa_antartica_hippo_histograms.pdf", width=12, height=8)
print(hist_vol_princeton_ave_hippo)
print(hist_vol_princeton_ave_CA1)
print(hist_vol_princeton_ave_CA23)
print(hist_vol_princeton_ave_DG)
print(hist_vol_princeton_ave_ERC)
print(hist_vol_princeton_ave_PHC)
print(hist_vol_princeton_ave_PRC)
print(hist_vol_princeton_ave_SUB)
dev.off()


### -------------- Phantom Plots -------------- ###
### Medlegal Style
### ------- GR ------- ###
nasa_data_GR <- nasa_data_mm3[nasa_data_mm3$subject_1 == "GR", ]
ave_col_nums <- grep("_ave_", colnames(nasa_data_GR))

col_name_vec <- colnames(nasa_data_GR) #ERB: Turn this into a function
for (i in ave_col_nums) {
	# Get the name of the column
	col_name <- col_name_vec[[i]]
	new_col_name <- paste0(col_name, "_tNdivtt1")
	nasa_data_GR[,new_col_name] <- NA
	for (j in 1:nrow(nasa_data_GR)) {
		beta <- nasa_data_GR[j, col_name]/nasa_data_GR[1, col_name]
		nasa_data_GR[j, new_col_name] <- beta
	}
}

melted_nasa_data_GR <- melt(nasa_data_GR)
betas_melted_GR <- melted_nasa_data_GR[97:128, ]
betas_melted_GR$Time <- as.factor(betas_melted_GR$Time)
betas_melted_GR$Scan <- NA
for (i in 1:nrow(betas_melted_GR)) {
	if (betas_melted_GR[i, "Time"] == "t1") {
		betas_melted_GR[i, "Scan"] <- "t1 - CGN 2014"
	} else if (betas_melted_GR[i, "Time"] == "t2") {
		betas_melted_GR[i, "Scan"] <- "t2 - CHR"
	} else if (betas_melted_GR[i, "Time"] == "t3") {
		betas_melted_GR[i, "Scan"] <- "t3 - HOB"
	} else if (betas_melted_GR[i, "Time"] == "t4") {
		betas_melted_GR[i, "Scan"] <- "t4 - CGN 2017"
	}
}

betas_melted_GR$Scan <- as.factor(betas_melted_GR$Scan)

# Simplify names
for (i in 1:nrow(betas_melted_GR)) {
	stringy <- as.character(betas_melted_GR[i, "variable"])
	name_vec <- strsplit(stringy, "_")
	newname <- as.character(name_vec[[1]][[4]])
	betas_melted_GR[i, "short_variable"] <- newname
}

betas_melted_GR$short_variable <- as.factor(betas_melted_GR$short_variable)


GR_plot <- ggplot(betas_melted_GR, aes(x=short_variable, y=value, group=Scan)) +
	ggtitle("Ruben Gur's Scanner Effects for the Hippocampus") +
	geom_line(aes(color=Scan), size=2) +
	xlab("ROI Volume") +
	ylab("Beta (B=(tN)/(t1))") +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))
	

### ------- BJ ------- ###
nasa_data_BJ <- nasa_data_mm3[nasa_data_mm3$subject_1 == "BJ", ]
ave_col_nums <- grep("_ave_", colnames(nasa_data_BJ))

col_name_vec <- colnames(nasa_data_BJ) 
for (i in ave_col_nums) {
	# Get the name of the column
	col_name <- col_name_vec[[i]]
	new_col_name <- paste0(col_name, "_tNdivtt1")
	nasa_data_BJ[,new_col_name] <- NA
	for (j in 1:nrow(nasa_data_BJ)) {
		beta <- nasa_data_BJ[j, col_name]/nasa_data_BJ[1, col_name]
		nasa_data_BJ[j, new_col_name] <- beta
	}
}

melted_nasa_data_BJ <- melt(nasa_data_BJ)
betas_melted_BJ <- melted_nasa_data_BJ[49:64, ]
betas_melted_BJ$Time <- as.factor(betas_melted_BJ$Time)
betas_melted_BJ$Scan <- NA
for (i in 1:nrow(betas_melted_BJ)) {
	if (betas_melted_BJ[i, "Time"] == "t1") {
		betas_melted_BJ[i, "Scan"] <- "t1 - CGN 2014"
	} else if (betas_melted_BJ[i, "Time"] == "t2") {
		betas_melted_BJ[i, "Scan"] <- "t2 - CHR"
	} else if (betas_melted_BJ[i, "Time"] == "t3") {
		betas_melted_BJ[i, "Scan"] <- "t3 - HOB"
	} else if (betas_melted_BJ[i, "Time"] == "t4") {
		betas_melted_BJ[i, "Scan"] <- "t4 - CGN 2017"
	}
}

betas_melted_BJ$Scan <- as.factor(betas_melted_BJ$Scan)

# Simplify names
for (i in 1:nrow(betas_melted_BJ)) {
	stringy <- as.character(betas_melted_BJ[i, "variable"])
	name_vec <- strsplit(stringy, "_")
	newname <- as.character(name_vec[[1]][[4]])
	betas_melted_BJ[i, "short_variable"] <- newname
}

betas_melted_BJ$short_variable <- as.factor(betas_melted_BJ$short_variable)


BJ_plot <- ggplot(betas_melted_BJ, aes(x=short_variable, y=value, group=Scan)) +
	ggtitle("JB's Scanner Effects for the Hippocampus") +
	geom_line(aes(color=Scan), size=2) +
	xlab("ROI Volume") +
	ylab("Beta (B=(tN)/(t1))") +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))

### ------- BM ------- ###
nasa_data_BM <- nasa_data_mm3[nasa_data_mm3$subject_1 == "BM", ]
ave_col_nums <- grep("_ave_", colnames(nasa_data_BM))

col_name_vec <- colnames(nasa_data_BM) 
for (i in ave_col_nums) {
	# Get the name of the column
	col_name <- col_name_vec[[i]]
	new_col_name <- paste0(col_name, "_tNdivtt1")
	nasa_data_BM[,new_col_name] <- NA
	for (j in 1:nrow(nasa_data_BM)) {
		beta <- nasa_data_BM[j, col_name]/nasa_data_BM[1, col_name]
		nasa_data_BM[j, new_col_name] <- beta
	}
}

melted_nasa_data_BM <- melt(nasa_data_BM)
betas_melted_BM <- melted_nasa_data_BM[97:128, ]
betas_melted_BM$Time <- as.factor(betas_melted_BM$Time)
betas_melted_BM$Scan <- NA
for (i in 1:nrow(betas_melted_BM)) {
	if (betas_melted_BM[i, "Time"] == "t1") {
		betas_melted_BM[i, "Scan"] <- "t1 - CGN 2014"
	} else if (betas_melted_BM[i, "Time"] == "t2") {
		betas_melted_BM[i, "Scan"] <- "t2 - CHR"
	} else if (betas_melted_BM[i, "Time"] == "t3") {
		betas_melted_BM[i, "Scan"] <- "t3 - HOB"
	} else if (betas_melted_BM[i, "Time"] == "t4") {
		betas_melted_BM[i, "Scan"] <- "t4 - CGN 2017"
	}
}

betas_melted_BM$Scan <- as.factor(betas_melted_BM$Scan)

# Simplify names
for (i in 1:nrow(betas_melted_BM)) {
	stringy <- as.character(betas_melted_BM[i, "variable"])
	name_vec <- strsplit(stringy, "_")
	newname <- as.character(name_vec[[1]][[4]])
	betas_melted_BM[i, "short_variable"] <- newname
}

betas_melted_BM$short_variable <- as.factor(betas_melted_BM$short_variable)


BM_plot <- ggplot(betas_melted_BM, aes(x=short_variable, y=value, group=Scan)) +
	ggtitle("Mathias Basner's Scanner Effects for the Hippocampus") +
	geom_line(aes(color=Scan), size=2) +
	xlab("ROI Volume") +
	ylab("Beta (B=(tN)/(t1))") +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))


### ------- EA ------- ###
nasa_data_BM <- nasa_data_mm3[nasa_data_mm3$subject_1 == "BM", ]
ave_col_nums <- grep("_ave_", colnames(nasa_data_BM))

col_name_vec <- colnames(nasa_data_BM) 
for (i in ave_col_nums) {
	# Get the name of the column
	col_name <- col_name_vec[[i]]
	new_col_name <- paste0(col_name, "_tNdivtt1")
	nasa_data_BM[,new_col_name] <- NA
	for (j in 1:nrow(nasa_data_BM)) {
		beta <- nasa_data_BM[j, col_name]/nasa_data_BM[1, col_name]
		nasa_data_BM[j, new_col_name] <- beta
	}
}

melted_nasa_data_BM <- melt(nasa_data_BM)
betas_melted_BM <- melted_nasa_data_BM[97:128, ]
betas_melted_BM$Time <- as.factor(betas_melted_BM$Time)
betas_melted_BM$Scan <- NA
for (i in 1:nrow(betas_melted_BM)) {
	if (betas_melted_BM[i, "Time"] == "t1") {
		betas_melted_BM[i, "Scan"] <- "t1 - CGN 2014"
	} else if (betas_melted_BM[i, "Time"] == "t2") {
		betas_melted_BM[i, "Scan"] <- "t2 - CHR"
	} else if (betas_melted_BM[i, "Time"] == "t3") {
		betas_melted_BM[i, "Scan"] <- "t3 - HOB"
	} else if (betas_melted_BM[i, "Time"] == "t4") {
		betas_melted_BM[i, "Scan"] <- "t4 - CGN 2017"
	}
}

betas_melted_BM$Scan <- as.factor(betas_melted_BM$Scan)

# Simplify names
for (i in 1:nrow(betas_melted_BM)) {
	stringy <- as.character(betas_melted_BM[i, "variable"])
	name_vec <- strsplit(stringy, "_")
	newname <- as.character(name_vec[[1]][[4]])
	betas_melted_BM[i, "short_variable"] <- newname
}

betas_melted_BM$short_variable <- as.factor(betas_melted_BM$short_variable)


BM_plot <- ggplot(betas_melted_BM, aes(x=short_variable, y=value, group=Scan)) +
	ggtitle("Mathias Basner's Scanner Effects for the Hippocampus") +
	geom_line(aes(color=Scan), size=2) +
	xlab("ROI Volume") +
	ylab("Beta (B=(tN)/(t1))") +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))

################# Save all phantom plots ################# 
pdf(file="/home/ebutler/nasa_plots/phantoms_hippocampus.pdf")
print(GR_plot)
print(BJ_plot)
print(BM_plot)
print(EA_plot)
print(PK_plot)
dev.off()




















#### GIVE UP

surfcol <- c("winterover", "subject_1", "Time", "surf_princeton_L_CA1", "surf_princeton_L_CA23", "surf_princeton_L_DG", "surf_princeton_L_ERC", "surf_princeton_L_PHC", "surf_princeton_L_PRC", "surf_princeton_L_SUB", "surf_princeton_R_CA1", "surf_princeton_R_CA23", "surf_princeton_R_DG", "surf_princeton_R_ERC", "surf_princeton_R_PHC", "surf_princeton_R_PRC", "surf_princeton_R_SUB")

volcol <- c("winterover", "subject_1", "Time", "vol_princeton_L_CA1", "vol_princeton_L_CA23", "vol_princeton_L_DG", "vol_princeton_L_ERC", "vol_princeton_L_PHC", "vol_princeton_L_PRC", "vol_princeton_L_SUB", "vol_princeton_R_CA1", "vol_princeton_R_CA23", "vol_princeton_R_DG", "vol_princeton_R_ERC", "vol_princeton_R_PHC", "vol_princeton_R_PRC", "vol_princeton_R_SUB")

### -------------------- CREW AND CONTROLS -------------------- ###

### ------- QC Plots ------- ###

# Filter for crew and controls 
nasa_data_cc <- nasa_data[nasa_data$winterover != "phantoms", ]

# Create a column that specifies Crew or Control... MAKE SURE NO PHANTOMS
crew_vec <- grep("concordia", nasa_data_cc[,"subject_1"])
nasa_data_cc$CrewStatus <- NA
num_rows = nrow(nasa_data_cc)
for (i in 1:num_rows) {
	if (i %in% crew_vec) {
		nasa_data_cc[i, "CrewStatus"] <- "Crew"
	} else {
		nasa_data_cc[i, "CrewStatus"] <- "Control"
	}
}

# Re-factor data
nasa_data_cc$winterover <- as.factor(nasa_data_cc$winterover)
nasa_data_cc$subject_1 <- as.factor(nasa_data_cc$subject_1)
nasa_data_cc$Time <- as.factor(nasa_data_cc$Time)

nasa_surf_cc <- nasa_data_cc[,surfcol]
nasa_vol_cc <- nasa_data_cc[,volcol]

# Average Left and Right ROIs
# surf
nasa_surf_cc <- averageLeftAndRight_Vol(nasa_surf_cc, "_R_", "_L_", "_ave_")
DVColumnNums_surf <- grep("_ave_", colnames(nasa_surf_cc))
IVColumnNums_surf <- c()
nasa_surf_cc <- regressMultDVs(nasa_surf_cc, DVColumnNums_surf, IVColumnNums_surf)
ROIlist <- grep("_zscore", colnames(nasa_surf_cc), value=TRUE)
# vol 
nasa_vol_cc <- averageLeftAndRight_Vol(nasa_vol_cc, "_R_", "_L_", "_ave_")
DVColumnNums_vol <- grep("_ave_", colnames(nasa_vol_cc))
IVColumnNums_vol <- c()
nasa_vol_cc <- regressMultDVs(nasa_vol_cc, DVColumnNums_vol, IVColumnNums_vol)
ROIlist <- grep("_zscore", colnames(nasa_vol_cc), value=TRUE)

# Plots
# vol
# data for histograms (all participants, but with averages)
nasa_data$vol_princeton_L_hippo <- nasa_data$vol_princeton_L_CA1 + nasa_data$vol_princeton_L_CA23 + nasa_data$vol_princeton_L_DG + nasa_data$vol_princeton_L_ERC + nasa_data$vol_princeton_L_PHC + nasa_data$vol_princeton_L_PRC + nasa_data$vol_princeton_L_SUB
nasa_data$vol_princeton_R_hippo <- nasa_data$vol_princeton_R_CA1 + nasa_data$vol_princeton_R_CA23 + nasa_data$vol_princeton_R_DG + nasa_data$vol_princeton_R_ERC + nasa_data$vol_princeton_R_PHC + nasa_data$vol_princeton_R_PRC + nasa_data$vol_princeton_R_SUB
nasa_hist_data <- averageLeftAndRight_Vol(nasa_data, "_R_", "_L_", "_ave_")

# Histograms
hist_vol_princeton_ave_hippo <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_hippo)) + geom_histogram()
hist_vol_princeton_ave_CA1 <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_CA1)) + geom_histogram()
hist_vol_princeton_ave_CA23 <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_CA23)) + geom_histogram()
hist_vol_princeton_ave_DG <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_DG)) + geom_histogram()
hist_vol_princeton_ave_ERC <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_ERC)) + geom_histogram()
hist_vol_princeton_ave_PHC <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_PHC)) + geom_histogram()
hist_vol_princeton_ave_PRC <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_PRC)) + geom_histogram()
hist_vol_princeton_ave_SUB <- ggplot(nasa_hist_data, aes(x=vol_princeton_ave_SUB)) + geom_histogram()

pdf(file = "/home/ebutler/nasa_plots/nasa_antartica_hippo_histograms.pdf", width=12, height=8)
print(hist_vol_princeton_ave_hippo)
print(hist_vol_princeton_ave_CA1)
print(hist_vol_princeton_ave_CA23)
print(hist_vol_princeton_ave_DG)
print(hist_vol_princeton_ave_ERC)
print(hist_vol_princeton_ave_PHC)
print(hist_vol_princeton_ave_PRC)
print(hist_vol_princeton_ave_SUB)
dev.off()

### ------- Phantom Plots ------- ###
### Medlegal Style
# GR
nasa_data_GR <- nasa_hist_data[nasa_hist_data$subject_1 == "GR", ]
nasa_hist_data$vol_princeton_ave_hippo_CHRtoCGN1 <- 



#nasa_vol_cc_t0t12 <- 
#plot(nasa_vol_cc[which(nasa_vol_cc$Time == "t0"),"vol_princeton_L_CA1"], nasa_vol_cc[which(nasa_vol_cc$Time == "t12"),"vol_princeton_L_CA1"])

### ------- Trend Plots ------- ###



### -------------------- PHANTOMS -------------------- ###

### ------- QC Plots ------- ###

### ------- Trend Plots ------- ###



