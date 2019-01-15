### This script averages L and R hippocampal rois for volume, gives total hippocampal metrics and
### produces histograms for quality assessment
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
