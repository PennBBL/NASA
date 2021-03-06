### This script compares the ROI values from December 2018 (MNI+Otsu) and March 2019 (OASIS)
###
### Ellyn Butler
### March 25, 2019

# load libraries
library('ggplot2')
library('remove')
library('gridExtra')

# read in the data
#oasiscort <- read.csv("/home/ebutler/erb_data/nasa/nasa_OASIS_CT.csv")
oasisgmd <- read.csv("/home/ebutler/erb_data/nasa/nasa_OASIS_gmd.csv", header=T)
oasisvol <- read.csv("/home/ebutler/erb_data/nasa/nasa_OASIS_vol.csv", header=T)
#mnicort <- read.csv("/home/ebutler/erb_data/nasa/nasa_raw_brain_CT.csv")
mnigmd <- read.csv("/home/ebutler/erb_data/nasa/nasa_raw_brain_gmd.csv", header=T)
mnivol <- read.csv("/home/ebutler/erb_data/nasa/nasa_raw_brain_vol.csv", header=T)

colnames(oasisgmd) <- paste("oasis", colnames(oasisgmd), sep = "_")
colnames(oasisvol) <- paste("oasis", colnames(oasisvol), sep = "_")

# rename oasis id colnames
names(oasisgmd)[names(oasisgmd) == "oasis_id0"] <- "winterover"
names(oasisgmd)[names(oasisgmd) == "oasis_id1"] <- "subject_1"
names(oasisgmd)[names(oasisgmd) == "oasis_id2"] <- "Time"
names(oasisvol)[names(oasisvol) == "oasis_id0"] <- "winterover"
names(oasisvol)[names(oasisvol) == "oasis_id1"] <- "subject_1"
names(oasisvol)[names(oasisvol) == "oasis_id2"] <- "Time"

# merge dfs
gmd_df <- merge(oasisgmd, mnigmd, by=c("winterover", "subject_1", "Time"))
vol_df <- merge(oasisvol, mnivol, by=c("winterover", "subject_1", "Time"))

##### create scatterplot of R rois
# gmd
R_gmd_oasis <- colnames(gmd_df)[grepl("oasis", colnames(gmd_df))]
R_gmd_oasis <- R_gmd_oasis[grepl("_R_", R_gmd_oasis)]
R_gmd_mni <- gsub("oasis_", "", R_gmd_oasis)

for (i in 1:length(R_gmd_oasis)) {
	oasisroi <- R_gmd_oasis[[i]]
	mniroi <- R_gmd_mni[[i]]
	p <- ggplot(gmd_df, aes_string(x=mniroi, y=oasisroi, color="scanner")) +
		geom_point() + theme_minimal() + ggtitle("X: MNI (Nov 2018), Y: OASIS (March 2019)")
	assign(paste0("p", i), p)
	
}

# vol
R_vol_oasis <- colnames(vol_df)[grepl("oasis", colnames(vol_df))]
R_vol_oasis <- R_vol_oasis[grepl("_R_", R_vol_oasis)]
R_vol_mni <- gsub("oasis_", "", R_vol_oasis)

for (i in 1:length(R_vol_oasis)) {
	oasisroi <- R_vol_oasis[[i]]
	mniroi <- R_vol_mni[[i]]
	g <- ggplot(vol_df, aes_string(x=mniroi, y=oasisroi, color="scanner")) +
		geom_point() + theme_minimal() + ggtitle("X: MNI (Nov 2018), Y: OASIS (March 2019)")
	assign(paste0("g", i), g)	
}


pdf(file="/home/ebutler/plots/nasa_antartica/quality_control/gmd_OASISvsMNI.pdf", width=12, height=5)
grid.arrange(p1, p2, p3, ncol=3)
grid.arrange(p4, p5, p6, ncol=3)
grid.arrange(p7, p8, p9, ncol=3)
grid.arrange(p10, p11, p12, ncol=3)
grid.arrange(p13, p14, p15, ncol=3)
grid.arrange(p16, p17, p18, ncol=3)
grid.arrange(p19, p20, p21, ncol=3)
grid.arrange(p22, p23, p24, ncol=3)
grid.arrange(p25, p26, p27, ncol=3)
grid.arrange(p28, p29, p30, ncol=3)
grid.arrange(p31, p32, p33, ncol=3)
grid.arrange(p34, p35, p36, ncol=3)
grid.arrange(p37, p38, p39, ncol=3)
grid.arrange(p40, p41, p42, ncol=3)
grid.arrange(p43, p44, p45, ncol=3)
grid.arrange(p46, p47, p48, ncol=3)
grid.arrange(p49, p50, p51, ncol=3)
grid.arrange(p52, p53, p54, ncol=3)
grid.arrange(p55, p56, p57, ncol=3)
dev.off()


pdf(file="/home/ebutler/plots/nasa_antartica/quality_control/vol_OASISvsMNI.pdf", width=12, height=5)
grid.arrange(g1, g2, g3, ncol=3)
grid.arrange(g4, g5, g6, ncol=3)
grid.arrange(g7, g8, g9, ncol=3)
grid.arrange(g10, g11, g12, ncol=3)
grid.arrange(g13, g14, g15, ncol=3)
grid.arrange(g16, g17, g18, ncol=3)
grid.arrange(g19, g20, g21, ncol=3)
grid.arrange(g22, g23, g24, ncol=3)
grid.arrange(g25, g26, g27, ncol=3)
grid.arrange(g28, g29, g30, ncol=3)
grid.arrange(g31, g32, g33, ncol=3)
grid.arrange(g34, g35, g36, ncol=3)
grid.arrange(g37, g38, g39, ncol=3)
grid.arrange(g40, g41, g42, ncol=3)
grid.arrange(g43, g44, g45, ncol=3)
grid.arrange(g46, g47, g48, ncol=3)
grid.arrange(g49, g50, g51, ncol=3)
grid.arrange(g52, g53, g54, ncol=3)
grid.arrange(g55, g56, g57, ncol=3)
dev.off()









