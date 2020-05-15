### This script averages L and R hippocampal rois for volume and gives total hippocampal metrics
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
	scale_y_continuous(limits = c(.8, 1.7), breaks=c(0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7)) +
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
	scale_y_continuous(limits = c(.8, 1.7), breaks=c(0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7)) +
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
	scale_y_continuous(limits = c(.8, 1.7), breaks=c(0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7)) +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))


### ------- EA ------- ###
nasa_data_EA <- nasa_data_mm3[nasa_data_mm3$subject_1 == "EA", ]
ave_col_nums <- grep("_ave_", colnames(nasa_data_EA))

col_name_vec <- colnames(nasa_data_EA) 
for (i in ave_col_nums) {
	# Get the name of the column
	col_name <- col_name_vec[[i]]
	new_col_name <- paste0(col_name, "_tNdivtt1")
	nasa_data_EA[,new_col_name] <- NA
	for (j in 1:nrow(nasa_data_EA)) {
		beta <- nasa_data_EA[j, col_name]/nasa_data_EA[1, col_name]
		nasa_data_EA[j, new_col_name] <- beta
	}
}

melted_nasa_data_EA <- melt(nasa_data_EA)
betas_melted_EA <- melted_nasa_data_EA[97:128, ]
betas_melted_EA$Time <- as.factor(betas_melted_EA$Time)
betas_melted_EA$Scan <- NA
for (i in 1:nrow(betas_melted_EA)) {
	if (betas_melted_EA[i, "Time"] == "t1") {
		betas_melted_EA[i, "Scan"] <- "t1 - CGN 2014"
	} else if (betas_melted_EA[i, "Time"] == "t2") {
		betas_melted_EA[i, "Scan"] <- "t2 - CHR"
	} else if (betas_melted_EA[i, "Time"] == "t3") {
		betas_melted_EA[i, "Scan"] <- "t3 - HOB"
	} else if (betas_melted_EA[i, "Time"] == "t4") {
		betas_melted_EA[i, "Scan"] <- "t4 - CGN 2017"
	}
}

betas_melted_EA$Scan <- as.factor(betas_melted_EA$Scan)

# Simplify names
for (i in 1:nrow(betas_melted_EA)) {
	stringy <- as.character(betas_melted_EA[i, "variable"])
	name_vec <- strsplit(stringy, "_")
	newname <- as.character(name_vec[[1]][[4]])
	betas_melted_EA[i, "short_variable"] <- newname
}

betas_melted_EA$short_variable <- as.factor(betas_melted_EA$short_variable)


EA_plot <- ggplot(betas_melted_EA, aes(x=short_variable, y=value, group=Scan)) +
	ggtitle("AE's Scanner Effects for the Hippocampus") +
	geom_line(aes(color=Scan), size=2) +
	xlab("ROI Volume") +
	ylab("Beta (B=(tN)/(t1))") +
	scale_y_continuous(limits = c(.8, 1.7), breaks=c(0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7)) +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))


### ------- PK ------- ###
nasa_data_PK <- nasa_data_mm3[nasa_data_mm3$subject_1 == "PK", ]
ave_col_nums <- grep("_ave_", colnames(nasa_data_PK))

col_name_vec <- colnames(nasa_data_PK) 
for (i in ave_col_nums) {
	# Get the name of the column
	col_name <- col_name_vec[[i]]
	new_col_name <- paste0(col_name, "_tNdivtt1")
	nasa_data_PK[,new_col_name] <- NA
	for (j in 1:nrow(nasa_data_PK)) {
		beta <- nasa_data_PK[j, col_name]/nasa_data_PK[1, col_name]
		nasa_data_PK[j, new_col_name] <- beta
	}
}

melted_nasa_data_PK <- melt(nasa_data_PK)
betas_melted_PK <- melted_nasa_data_PK[73:96, ]
betas_melted_PK$Time <- as.factor(betas_melted_PK$Time)
betas_melted_PK$Scan <- NA
for (i in 1:nrow(betas_melted_PK)) {
	if (betas_melted_PK[i, "Time"] == "t1") {
		betas_melted_PK[i, "Scan"] <- "t1 - CGN 2014"
	} else if (betas_melted_PK[i, "Time"] == "t2") {
		betas_melted_PK[i, "Scan"] <- "t2 - CHR"
	} else if (betas_melted_PK[i, "Time"] == "t3") {
		betas_melted_PK[i, "Scan"] <- "t3 - HOB"
	} else if (betas_melted_PK[i, "Time"] == "t4") {
		betas_melted_PK[i, "Scan"] <- "t4 - CGN 2017"
	}
}

betas_melted_PK$Scan <- as.factor(betas_melted_PK$Scan)

# Simplify names
for (i in 1:nrow(betas_melted_PK)) {
	stringy <- as.character(betas_melted_PK[i, "variable"])
	name_vec <- strsplit(stringy, "_")
	newname <- as.character(name_vec[[1]][[4]])
	betas_melted_PK[i, "short_variable"] <- newname
}

betas_melted_PK$short_variable <- as.factor(betas_melted_PK$short_variable)


PK_plot <- ggplot(betas_melted_PK, aes(x=short_variable, y=value, group=Scan)) +
	ggtitle("KP's Scanner Effects for the Hippocampus") +
	geom_line(aes(color=Scan), size=2) +
	xlab("ROI Volume") +
	ylab("Beta (B=(tN)/(t1))") +
	scale_y_continuous(limits = c(.8, 1.7), breaks=c(0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7)) +
	theme_bw() +
	theme(text=element_text(size=20), axis.text.x = element_text(angle = 60, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=20), axis.title.x = element_text(face="bold", size=20), axis.title.y = element_text(face="bold", size=20), plot.title = element_text(face="bold", size=20), strip.text.x = element_text(size=20))



################# Save all phantom plots ################# 
pdf(file="/home/ebutler/nasa_plots/phantoms_hippocampus_vol.pdf", width=10, height=10)
print(GR_plot)
print(BJ_plot)
print(BM_plot)
print(EA_plot)
print(PK_plot)
dev.off()











