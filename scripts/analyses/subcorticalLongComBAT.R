### This script tests for differences in subcortical volumes before and after
### a stay in Antarctica, using longitudinal combat to address site effects
###
### Ellyn Butler
### May 28, 2020 - June 1, 2020

library('miceadds')
library('ggplot2')
library('gridExtra')
library('ggpubr')
library('dplyr')
library('lme4')
library('data.table')
source.all('~/Documents/longCombat/R')


################################### Data ###################################
# Load data
demo_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_antartica_demographics.csv')
vol_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_raw_brain_vol.csv')
params_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_T1_acparams.csv')

# Subset demo
demo_df <- demo_df[, c("subject_1", "Time", "PatientSex", "PatientAgeYears")]
names(demo_df) <- c("subject_1", "Time", "sex", "age")

# Subset volume
vol_df <- vol_df[, c("subject_1", "Time", "scanner", "group",
 "vol_miccai_ave_Accumbens_Area", "vol_miccai_ave_Amygdala", "vol_miccai_ave_Caudate",
 "vol_miccai_ave_Hippocampus", "vol_miccai_ave_Pallidum", "vol_miccai_ave_Putamen",
 "vol_miccai_ave_Thalamus_Proper")]

# Subset params
params_df$combo <- paste(params_df$scanner, params_df$dx, params_df$dy, params_df$dz,
  params_df$FlipAngle, params_df$PhaseDirection, params_df$Te, params_df$Tr, sep="_")
params_df$comboGroup <- recode(params_df$combo, "CGN_0.9375_0.9375_1_9_ROW_3.51_1810"="One",
  "HOB_0.9375_0.9375_1_9_ROW_5.228_12.856"="Two",
  "CHR_0.9375_0.9375_1_9_ROW_5.228_12.856"="Three",
  "CHR_0.9375_0.9375_1_15_ROW_3.228_8.776"= "Four",
  "HOB_0.9375_0.9375_1_15_ROW_3.228_8.716"="Five",
  "HOB_0.9375_0.9375_1_9_ROW_5.296_12.976"="Six",
  "CGN_0.9375_0.9375_1_9_ROW_3.37_1810"="Seven")
#params_df[,c("subject_1", "Time", "comboGroup", "scanner")]

params_df <- params_df[params_df$comboGroup %in% c("One", "Two", "Three"),]
row.names(params_df) <- 1:nrow(params_df)
params_df <- params_df[, c("subject_1", "Time", "scanner", "comboGroup")]

final_df <- merge(demo_df, vol_df)
final_df <- merge(final_df, params_df)

# Remove irrelevant phantoms
final_df <- final_df[final_df$subject_1 != "BJ" & final_df$Time != "t4",]
row.names(final_df) <- 1:nrow(final_df)

# Recode time for phantoms to t0
final_df$Time <- recode(final_df$Time, "t1"="t0", "t2"="t0", "t3"="t0")


################################### Model ###################################

long_df <- reshape2::melt(final_df, c("subject_1", "Time", "group", "comboGroup",
  "age", "sex"), grep("vol_", names(final_df), value=TRUE))

mod1 <- longCombat(idvar="subject_1", batchvar="comboGroup",
  features="variable", formula="group*Time", ranef="(1|subject_1)", data=long_df)
