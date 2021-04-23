### This script creates csvs of raw data with lobular values (lobes and whole brain) for md, and organizes fa
### 
### Ellyn Butler
### June 5, 2019

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

####### ---------------- FA ---------------- #######

### Load the data
df1 <- read.csv("/home/ebutler/erb_data/nasa/Concordia_DTI_crew_fa.csv")
df2 <- read.csv("/home/ebutler/erb_data/nasa/Concordia_Phantom_dti_fa.csv")
df3 <- read.csv("/home/ebutler/erb_data/nasa/DLR_dti_fa.csv")

### Rename time columns
names(df1)[names(df1) == 'time'] <- 'Time'
names(df2)[names(df2) == 'time'] <- 'Time'
names(df3)[names(df3) == 'time'] <- 'Time'

### Correct subject identifiers
# df1
df1$subject_1 <- NA
for (i in 1:nrow(df1)) {
	if (df1[i, "ID"] < 10) {
		df1[i, "subject_1"] <- paste0("concordia_00", df1[i, "ID"])
	} else if (df1[i, "ID"] >= 10 & df1[i, "ID"] < 100) {
		df1[i, "subject_1"] <- paste0("concordia_0", df1[i, "ID"])
	} else {
		df1[i, "subject_1"] <- paste0("concordia_", df1[i, "ID"])
	}
}
df1$subject_1 <- factor(df1$subject_1)
df1$ID <- NULL

# df2
df2$subject_1 <- NA
df2$ID <- NULL
for (i in 1:nrow(df2)) {
	df2[i, "subject_1"] <- strsplit(as.character(df2[i, "Subject"]), split="m")[[1]][2]
}
df2$subject_1 <- factor(df2$subject_1)
df2$Subject <- NULL

# df3
df3$Subject <- NULL
df3$subject_1 <- NA
for (i in 1:nrow(df3)) {
	if (df3[i, "ID"] < 10) {
		df3[i, "subject_1"] <- paste0("DLR_00", df3[i, "ID"])
	} else if (df3[i, "ID"] >= 10 & df3[i, "ID"] < 100) {
		df3[i, "subject_1"] <- paste0("DLR_0", df3[i, "ID"])
	} else {
		df3[i, "subject_1"] <- paste0("DLR_", df3[i, "ID"])
	}
}
df3$subject_1 <- factor(df3$subject_1)
df3$ID <- NULL


### Merge dfs
fa_df <- rbind(df1, df2)
fa_df <- rbind(fa_df, df3)

### Reorder columns
fa_df <- fa_df[,c(28, 1, 2:27)]
fa_df$subject_1 <- factor(fa_df$subject_1)
fa_df$Time <- factor(fa_df$Time)

### Add rows for missing subjects with NAs
NA_vec <- rep(NA, 26)

# concordia_010 at t0
concordia_010_t0 <- c("concordia_010", "t0", NA_vec)

# concordia_102 at t0
concordia_102_t0 <- c("concordia_102", "t0", NA_vec)

# concordia_104 at t12
concordia_104_t12 <- c("concordia_104", "t12", NA_vec)

### Finish off dataframe
fa_df <- rbind(fa_df, concordia_010_t0)
fa_df <- rbind(fa_df, concordia_102_t0)
fa_df <- rbind(fa_df, concordia_104_t12)

write.csv(fa_df, "/home/ebutler/erb_data/nasa/nasa_raw_fa.csv", row.names=FALSE)

####### ---------------- MD ---------------- #######

md_df <- read.csv("/home/ebutler/erb_data/nasa/MD_Data_all_06042019.csv")
mapping_df <- read.csv("/home/ebutler/xcpEngineInfo/miccaiIndexNameMapping.csv")
mapping_df$Index <- as.numeric(mapping_df$Index)
mapping_df$Name <- as.character(mapping_df$Name)

### Fix subject identifiers

md_df$Phantoms_MD <- as.character(md_df$Phantoms_MD)
md_df[80, "Phantoms_MD"] <- "concordia_001_t0_FA.nii.gz"

md_df$subject_1 <- NA
md_df$Time <- NA
for (i in 1:nrow(md_df)) {
	boo <- strsplit(md_df[i, "Phantoms_MD"], split="_")
	time <- boo[[1]][3]
	name <- strsplit(boo[[1]][1], split="m")
	if (name[[1]][1] == "phanto") {
		name <- name[[1]][2]
	} else {
		name <- paste0(boo[[1]][1], "_", boo[[1]][2])
	}
	md_df[i, "subject_1"] <- name
	md_df[i, "Time"] <- time
}
md_df$Phantoms_MD <- NULL


### Rename or get rid of MD columns

poocols <- c()
for (i in 1:length(grepl("NZ", colnames(md_df))[grepl("NZ", colnames(md_df)) == TRUE])) {
	colnum <- strsplit(colnames(md_df)[i], split="_")[[1]][2]
	if (colnum %in% mapping_df$Index) {
		colnames(md_df)[i] <- paste0("dti_jlf_md_", mapping_df[mapping_df$Index == i, "Name"])
	} else {
		poocols <- c(poocols, colnames(md_df)[i])
	}
}
md_df[,poocols] <- NULL
md_df <- md_df[,c(118, 119, 1:117)]


### Create lobular definitions

nasa_data <- md_df
nasa_vol <- read.csv("/home/ebutler/erb_data/nasa/nasa_slowjlf_vol.csv", header=TRUE)
nasa_vol$id0 <- NULL
colnames(nasa_vol)[colnames(nasa_vol)=="id1"] <- "subject_1"
colnames(nasa_vol)[colnames(nasa_vol)=="id2"] <- "Time"

# Remove subjects without md from nasa_vol
row1 <- as.numeric(rownames(nasa_vol[nasa_vol$subject_1 == "concordia_010" & nasa_vol$Time == "t0",]))
row2 <- as.numeric(rownames(nasa_vol[nasa_vol$subject_1 == "concordia_102" & nasa_vol$Time == "t0",]))
row3 <- as.numeric(rownames(nasa_vol[nasa_vol$subject_1 == "concordia_104" & nasa_vol$Time == "t12",]))
nasa_vol <- nasa_vol[-c(row1, row2, row3),]

rownames(nasa_vol) <- 1:nrow(nasa_vol)

# Calculate whole-brain metrics
nasa_data <- averageLeftAndRight_WeightByVol(nasa_vol, nasa_data, volString="vol_miccai", otherString="dti_jlf_md")
ROIlist <- grep("_ave_", colnames(nasa_data), value=TRUE)
ROIlist <- addUnderScore(ROIlist)
ROI_ListofLists <- roiLobes(ROIlist, lobeDef=FALSE)
ROI_ListofLists <- removeUnderScore(ROI_ListofLists)
ROI_ListofLists$Cerebellum <- NULL
# vol
nasa_vol <- averageLeftAndRight_Vol(nasa_vol, "_R_", "_L_", "_ave_")
ROIlist <- grep("_ave_", colnames(nasa_vol), value=TRUE)
ROIlist <- addUnderScore(ROIlist)
ROI_ListofLists_Vol <- roiLobes(ROIlist, lobeDef=FALSE)
ROI_ListofLists_Vol <- removeUnderScore(ROI_ListofLists_Vol)
ROI_ListofLists_Vol$Cerebellum <- NULL
nasa_vol <- lobeVolumes(nasa_vol, ROI_ListofLists_Vol, lastList=TRUE) 
# create lobular definitions
nasa_data <- averageROIsInLobes_WeightByVol(nasa_vol, nasa_data, ROI_ListofLists_Vol, ROI_ListofLists, lastList=TRUE, type="md")


### Put in rows for missing subjects

NA_vec <- rep(NA, 181)

# concordia_010 at t0
concordia_010_t0 <- c("concordia_010", "t0", NA_vec)

# concordia_102 at t0
concordia_102_t0 <- c("concordia_102", "t0", NA_vec)

# concordia_104 at t12
concordia_104_t12 <- c("concordia_104", "t12", NA_vec)

nasa_data2 <- rbind(nasa_data, concordia_010_t0)
nasa_data2 <- rbind(nasa_data2, concordia_102_t0)
nasa_data2 <- rbind(nasa_data2, concordia_104_t12)

write.csv(nasa_data2, file="/home/ebutler/erb_data/nasa/nasa_rawWLobe_md.csv", row.names=FALSE)











