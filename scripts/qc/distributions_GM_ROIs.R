### This script creates plots of the distributions of gray matter ROI values (New ANTs... data from December 2018)
###
### Ellyn Butler
### January 14, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
source("/home/ebutler/scripts/nasa_PHI/makeREDCapFriendly_NASAAntartica.R")
library('plyr')
library('gridExtra')


############## New ANTs ##############
# Load data
nasa_vol_NewANTs <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv')
names(nasa_vol_NewANTs)[names(nasa_vol_NewANTs) == 'id0'] <- 'winterover'
names(nasa_vol_NewANTs)[names(nasa_vol_NewANTs) == 'id1'] <- 'subject_1'
names(nasa_vol_NewANTs)[names(nasa_vol_NewANTs) == 'id2'] <- 'Time'
nasa_vol_NewANTs <- makeREDCapFriendly_NASAAntartica(nasa_vol_NewANTs)
nasa_vol_NewANTs <- scanningSite_NASAAntartica(nasa_vol_NewANTs)

nasa_gmd_NewANTs <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_gmd.csv')
names(nasa_gmd_NewANTs)[names(nasa_gmd_NewANTs) == 'id0'] <- 'winterover'
names(nasa_gmd_NewANTs)[names(nasa_gmd_NewANTs) == 'id1'] <- 'subject_1'
names(nasa_gmd_NewANTs)[names(nasa_gmd_NewANTs) == 'id2'] <- 'Time'
nasa_gmd_NewANTs <- makeREDCapFriendly_NASAAntartica(nasa_gmd_NewANTs)
nasa_gmd_NewANTs <- scanningSite_NASAAntartica(nasa_gmd_NewANTs)


# Vol plots
for (i in 4:120) {
	ROI <- colnames(nasa_vol)[i]
	nam <- paste("p", i, sep = "")
	assign(nam, ggplot(nasa_vol, aes_string(x=ROI, color="scanner")) + geom_histogram(fill="white", position="dodge") + theme(legend.position="top"))
}

pdf(file = "/home/ebutler/plots/nasa_antartica/nasa_ROIs_NewANTs_vol.pdf", width=21, height=6)
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
grid.arrange(p58, p59, p60, ncol=3)
grid.arrange(p61, p62, p63, ncol=3)
grid.arrange(p64, p65, p66, ncol=3)
grid.arrange(p67, p68, p69, ncol=3)
grid.arrange(p70, p71, p72, ncol=3)
grid.arrange(p73, p74, p75, ncol=3)
grid.arrange(p76, p77, p78, ncol=3)
grid.arrange(p79, p80, p81, ncol=3)
grid.arrange(p82, p83, p84, ncol=3)
grid.arrange(p85, p86, p87, ncol=3)
grid.arrange(p88, p89, p90, ncol=3)
grid.arrange(p91, p92, p93, ncol=3)
grid.arrange(p94, p95, p96, ncol=3)
grid.arrange(p97, p98, p99, ncol=3)
grid.arrange(p100, p101, p102, ncol=3)
grid.arrange(p103, p104, p105, ncol=3)
grid.arrange(p106, p107, p108, ncol=3)
grid.arrange(p109, p110, p111, ncol=3)
grid.arrange(p112, p113, p114, ncol=3)
grid.arrange(p115, p116, p117, ncol=3)
grid.arrange(p118, p119, p120, ncol=3)
dev.off()

# GMD plots
for (i in 4:120) {
	ROI <- colnames(nasa_gmd)[i]
	nam <- paste("pp", i, sep = "")
	assign(nam, ggplot(nasa_gmd, aes_string(x=ROI, color="scanner")) + geom_histogram(fill="white", position="dodge") + theme(legend.position="top"))
}

pdf(file = "/home/ebutler/plots/nasa_antartica/nasa_ROIs_NewANTs_gmd.pdf", width=33, height=6)
grid.arrange(pp4, pp5, pp6, ncol=9)
grid.arrange(pp7, pp8, pp9, ncol=9)
grid.arrange(pp10, pp11, pp12, ncol=9)
grid.arrange(pp13, pp14, pp15, ncol=9)
grid.arrange(pp16, pp17, pp18, ncol=9)
grid.arrange(pp19, pp20, pp21, ncol=9)
grid.arrange(pp22, pp23, pp24, ncol=9)
grid.arrange(pp25, pp26, pp27, ncol=9)
grid.arrange(pp28, pp29, pp30, ncol=9)
grid.arrange(pp31, pp32, pp33, ncol=9)
grid.arrange(pp34, pp35, pp36, ncol=9)
grid.arrange(pp37, pp38, pp39, ncol=9)
grid.arrange(pp40, pp41, pp42, ncol=9)
grid.arrange(pp43, pp44, pp45, ncol=9)
grid.arrange(pp46, pp47, pp48, ncol=9)
grid.arrange(pp49, pp50, pp51, ncol=9)
grid.arrange(pp52, pp53, pp54, ncol=9)
grid.arrange(pp55, pp56, pp57, ncol=9)
grid.arrange(pp58, pp59, pp60, ncol=9)
grid.arrange(pp61, pp62, pp63, ncol=9)
grid.arrange(pp64, pp65, pp66, ncol=9)
grid.arrange(pp67, pp68, pp69, ncol=9)
grid.arrange(pp70, pp71, pp72, ncol=9)
grid.arrange(pp73, pp74, pp75, ncol=9)
grid.arrange(pp76, pp77, pp78, ncol=9)
grid.arrange(pp79, pp80, pp81, ncol=9)
grid.arrange(pp82, pp83, pp84, ncol=9)
grid.arrange(pp85, pp86, pp87, ncol=9)
grid.arrange(pp88, pp89, pp90, ncol=9)
grid.arrange(pp91, pp92, pp93, ncol=9)
grid.arrange(pp94, pp95, pp96, ncol=9)
grid.arrange(pp97, pp98, pp99, ncol=9)
grid.arrange(pp100, pp101, pp102, ncol=9)
grid.arrange(pp103, pp104, pp105, ncol=9)
grid.arrange(pp106, pp107, pp108, ncol=9)
grid.arrange(pp109, pp110, pp111, ncol=9)
grid.arrange(pp112, pp113, pp114, ncol=9)
grid.arrange(pp115, pp116, pp117, ncol=9)
grid.arrange(pp118, pp119, pp120, ncol=9)
dev.off()

############## Old ANTs ##############
# Load data
nasa_vol_OldANTs <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_OldAnts_vol.csv')
names(nasa_vol_OldANTs)[names(nasa_vol_OldANTs) == 'id0'] <- 'winterover'
names(nasa_vol_OldANTs)[names(nasa_vol_OldANTs) == 'id1'] <- 'subject_1'
names(nasa_vol_OldANTs)[names(nasa_vol_OldANTs) == 'id2'] <- 'Time'
nasa_vol_OldANTs <- makeREDCapFriendly_NASAAntartica(nasa_vol_OldANTs)
nasa_vol_OldANTs <- scanningSite_NASAAntartica(nasa_vol_OldANTs)

nasa_gmd_OldANTs <- read.csv('/home/ebutler/erb_data/nasa/nasa_slowjlf_OldAnts_gmd.csv')
names(nasa_gmd_OldANTs)[names(nasa_gmd_OldANTs) == 'id0'] <- 'winterover'
names(nasa_gmd_OldANTs)[names(nasa_gmd_OldANTs) == 'id1'] <- 'subject_1'
names(nasa_gmd_OldANTs)[names(nasa_gmd_OldANTs) == 'id2'] <- 'Time'
nasa_gmd_OldANTs <- makeREDCapFriendly_NASAAntartica(nasa_gmd_OldANTs)
nasa_gmd_OldANTs <- scanningSite_NASAAntartica(nasa_gmd_OldANTs)



############## Correlations between New and Old ANTs ##############


# VOLUME
# subset New ANTs for subjects in both
oldsubids <- nasa_vol_OldANTs$subid
subset_vol_NewANTs <- nasa_vol_NewANTs[nasa_vol_NewANTs$subid %in% oldsubids,]
subset_vol_OldANTs <- nasa_vol_OldANTs

# prepend on "NewANTs_" and "OldANTs_"
colnames(nasa_vol_NewANTs) <- paste("NewANTs_", colnames(nasa_vol_NewANTs), sep="")
colnames(nasa_vol_OldANTs) <- paste("OldANTs_", colnames(nasa_vol_OldANTs), sep="")

# rename identifiers
colnames(nasa_vol_NewANTs)[1] <- "winterover"
colnames(nasa_vol_NewANTs)[2] <- "subject_1"
colnames(nasa_vol_NewANTs)[3] <- "Time"
colnames(nasa_vol_NewANTs)[121] <- "subid"
colnames(nasa_vol_NewANTs)[122] <- "scanner"
colnames(nasa_vol_OldANTs)[1] <- "winterover"
colnames(nasa_vol_OldANTs)[2] <- "subject_1"
colnames(nasa_vol_OldANTs)[3] <- "Time"
colnames(nasa_vol_OldANTs)[121] <- "subid"
colnames(nasa_vol_OldANTs)[122] <- "scanner"

# merge the datasets
merged_ANTs <- merge(nasa_vol_OldANTs, nasa_vol_NewANTs)

# scatterplots
# with outliers & NAs turned to 0s
merged_ANTs[is.na(merged_ANTs)] <- 0

for (i in 6:122) {
	ROI_Old <- colnames(merged_ANTs)[i]
	roi_old_string <- strsplit(ROI_Old, split="_")
	ROI_New <- "NewANTs"
	for (j in 2:length(roi_old_string[[1]])) {
		ROI_New <- paste0(ROI_New,"_",roi_old_string[[1]][[j]])
	}
	nam <- paste("c", i, sep = "")
	maxval <- max(c(merged_ANTs[,ROI_Old],merged_ANTs[,ROI_New]))
	assign(nam, ggplot(merged_ANTs, aes_string(x=ROI_Old, y=ROI_New, color="scanner")) + geom_point() + scale_x_continuous(limits = c(0, maxval)) + geom_abline(slope=1, intercept=0) + geom_point() + scale_y_continuous(limits = c(0, maxval)) + geom_smooth(method=lm))
}


pdf(file = "/home/ebutler/plots/nasa_antartica/nasa_ROIs_NewOldANTs_correlations_vol.pdf", width=21, height=6)
grid.arrange(c6, c7, c8, ncol=3)
grid.arrange(c9, c10, c11, ncol=3)
grid.arrange(c12, c13, c14, ncol=3)
grid.arrange(c15, c16, c17, ncol=3)
grid.arrange(c18, c19, c20, ncol=3)
grid.arrange(c21, c22, c23, ncol=3)
grid.arrange(c24, c25, c26, ncol=3)
grid.arrange(c27, c28, c29, ncol=3)
grid.arrange(c30, c31, c32, ncol=3)
grid.arrange(c33, c34, c35, ncol=3)
grid.arrange(c36, c37, c38, ncol=3)
grid.arrange(c39, c40, c41, ncol=3)
grid.arrange(c42, c43, c44, ncol=3)
grid.arrange(c45, c46, c47, ncol=3)
grid.arrange(c48, c49, c50, ncol=3)
grid.arrange(c51, c52, c53, ncol=3)
grid.arrange(c54, c55, c56, ncol=3)
grid.arrange(c57, c58, c59, ncol=3)
grid.arrange(c60, c61, c62, ncol=3)
grid.arrange(c63, c64, c65, ncol=3)
grid.arrange(c66, c67, c68, ncol=3)
grid.arrange(c69, c70, c71, ncol=3)
grid.arrange(c72, c73, c74, ncol=3)
grid.arrange(c75, c76, c77, ncol=3)
grid.arrange(c78, c79, c80, ncol=3)
grid.arrange(c81, c82, c83, ncol=3)
grid.arrange(c84, c85, c86, ncol=3)
grid.arrange(c87, c88, c89, ncol=3)
grid.arrange(c90, c91, c92, ncol=3)
grid.arrange(c93, c94, c95, ncol=3)
grid.arrange(c96, c97, c98, ncol=3)
grid.arrange(c99, c100, c101, ncol=3)
grid.arrange(c102, c103, c104, ncol=3)
grid.arrange(c105, c106, c107, ncol=3)
grid.arrange(c108, c109, c110, ncol=3)
grid.arrange(c111, c112, c113, ncol=3)
grid.arrange(c114, c115, c116, ncol=3)
grid.arrange(c117, c118, c119, ncol=3)
grid.arrange(c120, c121, c122, ncol=3)
dev.off()

#### without outliers 
# scatterplots
# vol
# with outliers & NAs turned to 0s
outliers <- as.vector(which(merged_ANTs$OldANTs_vol_miccai_R_TTG == 0))
merged_ANTs_noout <- merged_ANTs[-c(2, 3, 10, 16, 17, 21, 22, 24, 26, 31, 41, 43, 47),]

for (i in 6:122) {
	ROI_Old <- colnames(merged_ANTs_noout)[i]
	roi_old_string <- strsplit(ROI_Old, split="_")
	ROI_New <- "NewANTs"
	for (j in 2:length(roi_old_string[[1]])) {
		ROI_New <- paste0(ROI_New,"_",roi_old_string[[1]][[j]])
	}
	nam <- paste("d", i, sep = "")
	maxval <- max(c(merged_ANTs_noout[,ROI_Old],merged_ANTs_noout[,ROI_New]))
	assign(nam, ggplot(merged_ANTs_noout, aes_string(x=ROI_Old, y=ROI_New)) + geom_point() + scale_x_continuous(limits = c(0, maxval)) + geom_abline(slope=1, intercept=0) + geom_point() + scale_y_continuous(limits = c(0, maxval)) + geom_smooth(method=lm))
}


pdf(file = "/home/ebutler/plots/nasa_antartica/nasa_ROIs_NewOldANTsNoOut_correlations_vol.pdf", width=21, height=6)
grid.arrange(d6, d7, d8, ncol=3)
grid.arrange(d9, d10, d11, ncol=3)
grid.arrange(d12, d13, d14, ncol=3)
grid.arrange(d15, d16, d17, ncol=3)
grid.arrange(d18, d19, d20, ncol=3)
grid.arrange(d21, d22, d23, ncol=3)
grid.arrange(d24, d25, d26, ncol=3)
grid.arrange(d27, d28, d29, ncol=3)
grid.arrange(d30, d31, d32, ncol=3)
grid.arrange(d33, d34, d35, ncol=3)
grid.arrange(d36, d37, d38, ncol=3)
grid.arrange(d39, d40, d41, ncol=3)
grid.arrange(d42, d43, d44, ncol=3)
grid.arrange(d45, d46, d47, ncol=3)
grid.arrange(d48, d49, d50, ncol=3)
grid.arrange(d51, d52, d53, ncol=3)
grid.arrange(d54, d55, d56, ncol=3)
grid.arrange(d57, d58, d59, ncol=3)
grid.arrange(d60, d61, d62, ncol=3)
grid.arrange(d63, d64, d65, ncol=3)
grid.arrange(d66, d67, d68, ncol=3)
grid.arrange(d69, d70, d71, ncol=3)
grid.arrange(d72, d73, d74, ncol=3)
grid.arrange(d75, d76, d77, ncol=3)
grid.arrange(d78, d79, d80, ncol=3)
grid.arrange(d81, d82, d83, ncol=3)
grid.arrange(d84, d85, d86, ncol=3)
grid.arrange(d87, d88, d89, ncol=3)
grid.arrange(d90, d91, d92, ncol=3)
grid.arrange(d93, d94, d95, ncol=3)
grid.arrange(d96, d97, d98, ncol=3)
grid.arrange(d99, d100, d101, ncol=3)
grid.arrange(d102, d103, d104, ncol=3)
grid.arrange(d105, d106, d107, ncol=3)
grid.arrange(d108, d109, d110, ncol=3)
grid.arrange(d111, d112, d113, ncol=3)
grid.arrange(d114, d115, d116, ncol=3)
grid.arrange(d117, d118, d119, ncol=3)
grid.arrange(d120, d121, d122, ncol=3)
dev.off()

# GMD
# subset New ANTs for subjects in both
oldsubids <- nasa_gmd_OldANTs$subid
subset_gmd_NewANTs <- nasa_gmd_NewANTs[nasa_gmd_NewANTs$subid %in% oldsubids,]
subset_gmd_OldANTs <- nasa_gmd_OldANTs

# prepend on "NewANTs_" and "OldANTs_"
colnames(nasa_gmd_NewANTs) <- paste("NewANTs_", colnames(nasa_gmd_NewANTs), sep="")
colnames(nasa_gmd_OldANTs) <- paste("OldANTs_", colnames(nasa_gmd_OldANTs), sep="")

# rename identifiers
colnames(nasa_gmd_NewANTs)[1] <- "winterover"
colnames(nasa_gmd_NewANTs)[2] <- "subject_1"
colnames(nasa_gmd_NewANTs)[3] <- "Time"
colnames(nasa_gmd_NewANTs)[121] <- "subid"
colnames(nasa_gmd_NewANTs)[122] <- "scanner"
colnames(nasa_gmd_OldANTs)[1] <- "winterover"
colnames(nasa_gmd_OldANTs)[2] <- "subject_1"
colnames(nasa_gmd_OldANTs)[3] <- "Time"
colnames(nasa_gmd_OldANTs)[121] <- "subid"
colnames(nasa_gmd_OldANTs)[122] <- "scanner"

# merge the datasets
merged_ANTs <- merge(nasa_gmd_OldANTs, nasa_gmd_NewANTs)

# scatterplots
# with outliers & NAs turned to 0s
merged_ANTs[is.na(merged_ANTs)] <- 0

for (i in 6:122) {
	ROI_Old <- colnames(merged_ANTs)[i]
	roi_old_string <- strsplit(ROI_Old, split="_")
	ROI_New <- "NewANTs"
	for (j in 2:length(roi_old_string[[1]])) {
		ROI_New <- paste0(ROI_New,"_",roi_old_string[[1]][[j]])
	}
	nam <- paste("cc", i, sep = "")
	maxval <- max(c(merged_ANTs[,ROI_Old],merged_ANTs[,ROI_New]))
	assign(nam, ggplot(merged_ANTs, aes_string(x=ROI_Old, y=ROI_New, color="scanner")) + geom_point() + scale_x_continuous(limits = c(0, maxval)) + geom_abline(slope=1, intercept=0) + geom_point() + scale_y_continuous(limits = c(0, maxval)) + geom_smooth(method=lm))
}


pdf(file = "/home/ebutler/plots/nasa_antartica/nasa_ROIs_NewOldANTs_correlations_gmd.pdf", width=21, height=6)
grid.arrange(cc6, cc7, cc8, ncol=3)
grid.arrange(cc9, cc10, cc11, ncol=3)
grid.arrange(cc12, cc13, cc14, ncol=3)
grid.arrange(cc15, cc16, cc17, ncol=3)
grid.arrange(cc18, cc19, cc20, ncol=3)
grid.arrange(cc21, cc22, cc23, ncol=3)
grid.arrange(cc24, cc25, cc26, ncol=3)
grid.arrange(cc27, cc28, cc29, ncol=3)
grid.arrange(cc30, cc31, cc32, ncol=3)
grid.arrange(cc33, cc34, cc35, ncol=3)
grid.arrange(cc36, cc37, cc38, ncol=3)
grid.arrange(cc39, cc40, cc41, ncol=3)
grid.arrange(cc42, cc43, cc44, ncol=3)
grid.arrange(cc45, cc46, cc47, ncol=3)
grid.arrange(cc48, cc49, cc50, ncol=3)
grid.arrange(cc51, cc52, cc53, ncol=3)
grid.arrange(cc54, cc55, cc56, ncol=3)
grid.arrange(cc57, cc58, cc59, ncol=3)
grid.arrange(cc60, cc61, cc62, ncol=3)
grid.arrange(cc63, cc64, cc65, ncol=3)
grid.arrange(cc66, cc67, cc68, ncol=3)
grid.arrange(cc69, cc70, cc71, ncol=3)
grid.arrange(cc72, cc73, cc74, ncol=3)
grid.arrange(cc75, cc76, cc77, ncol=3)
grid.arrange(cc78, cc79, cc80, ncol=3)
grid.arrange(cc81, cc82, cc83, ncol=3)
grid.arrange(cc84, cc85, cc86, ncol=3)
grid.arrange(cc87, cc88, cc89, ncol=3)
grid.arrange(cc90, cc91, cc92, ncol=3)
grid.arrange(cc93, cc94, cc95, ncol=3)
grid.arrange(cc96, cc97, cc98, ncol=3)
grid.arrange(cc99, cc100, cc101, ncol=3)
grid.arrange(cc102, cc103, cc104, ncol=3)
grid.arrange(cc105, cc106, cc107, ncol=3)
grid.arrange(cc108, cc109, cc110, ncol=3)
grid.arrange(cc111, cc112, cc113, ncol=3)
grid.arrange(cc114, cc115, cc116, ncol=3)
grid.arrange(cc117, cc118, cc119, ncol=3)
grid.arrange(cc120, cc121, cc122, ncol=3)
dev.off()



# ------------------ Hippo ------------------ #
nasa_hippo <- read.csv('/home/ebutler/erb_data/nasa/nasa_raw_hippo_vol.csv')
