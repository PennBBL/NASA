### This script tests for time by cognitive performance interactions
###
### Ellyn Butler
### April 30, 2021

library('miceadds') # v 3.10-28... 3.11-6
library('ggplot2') # v 3.3.2
library('ggseg') # v 1.1.5... 1.6.00
library('ggpubr') # v 0.4.0
library('dplyr') # v 1.0.2
library('lme4') # v 1.1-23... 1.1-26
library('pbkrtest') # v 0.4-8.6... 0.5-0.1
library('R.utils') # v 2.10.1
library('sjPlot') # v 2.8.4... 2.8.6
library('kableExtra') # v 1.3.1... 1.3.4
library('ggrepel') # v 0.8.2
library('tidyverse') # v 1.3.0
library('cowplot') # v 1.1.1
library('longCombat') # v 0.0.0.90000


set.seed(20)


################################### Data ###################################

# Load data
demo_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_antartica_demographics.csv')
names(demo_df)[names(demo_df) == 'subject_1'] <- 'subject'
vol_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_raw_brain_vol.csv')
names(vol_df)[names(vol_df) == 'subject_1'] <- 'subject'
params_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_T1_acparams.csv')
names(params_df)[names(params_df) == 'subject_1'] <- 'subject'
cog_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/concordia_cognition_data_cleaned.csv')
cog_df <- cog_df[, c('subject', 'Battery', 'Time', 'Accuracy', 'Speed', 'Efficiency')]


# Subset demo
demo_df <- demo_df[, c("subject", "Time", "PatientSex", "PatientAgeYears")]
names(demo_df) <- c("subject", "Time", "sex", "age")

# Subset volume
subcortical <- c("vol_miccai_ave_Accumbens_Area", "vol_miccai_ave_Amygdala",
  "vol_miccai_ave_Caudate", "vol_miccai_ave_Hippocampus", "vol_miccai_ave_Pallidum",
  "vol_miccai_ave_Putamen", "vol_miccai_ave_Thalamus_Proper")
vol_df$Frontal_Vol <- vol_df$FrontOrb_Vol + vol_df$FrontDors_Vol
vol_df <- vol_df[, !(names(vol_df) %in% c("FrontOrb_Vol", "FrontDors_Vol"))]
cortical <- grep("_Vol", names(vol_df), value=TRUE)[!(grep("_Vol", names(vol_df), value=TRUE) %in% c("BasGang_Vol", "Limbic_Vol"))]
vol_df <- vol_df[, c("subject", "Time", "scanner", "group", subcortical, cortical)]

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

params_df <- params_df[params_df$comboGroup %in% c("One", "Two", "Three"),]
row.names(params_df) <- 1:nrow(params_df)
params_df <- params_df[, c("subject", "Time", "scanner", "comboGroup")]

final_df <- merge(demo_df, vol_df)
final_df <- merge(final_df, params_df)
final_df <- merge(final_df, cog_df)

# Remove irrelevant phantoms
final_df <- final_df[final_df$subject != "BJ" & final_df$Time != "t4",]
row.names(final_df) <- 1:nrow(final_df)

# Recode time for phantoms to t0
ind_data <- final_df[final_df$group %in% c("Crew", "Phantom"), ]
final_df$Time <- recode(final_df$Time, "t1"="t0", "t2"="t0", "t3"="t0")

# Scale summary cognition variables
final_df$Accuracy <- scale(final_df$Accuracy)
final_df$Speed <- scale(final_df$Speed)
final_df$Efficiency <- scale(final_df$Efficiency)

# Get rid of three rows with NAs for cog variables
final_df <- final_df[!is.na(final_df$Accuracy), ]
row.names(final_df) <- 1:nrow(final_df)

################################### Plot ###################################

crew_phan_df <- final_df[final_df$group %in% c("Crew", "Phantom"), ]
row.names(crew_phan_df) <- 1:nrow(crew_phan_df)
crew_phan_df$Crew <- recode(crew_phan_df$group, "Crew"=1, "Phantom"=0)
crew_phan_df$t12 <- recode(crew_phan_df$Time, "t0"=0, "t12"=1, "t18"=0)
crew_phan_df$t18 <- recode(crew_phan_df$Time, "t0"=0, "t12"=0, "t18"=1)

write.csv(crew_phan_df, '~/Documents/nasa_antarctica/NASA/data/dataForLongCombat.csv', row.names=FALSE)

crew_phan_df$Time <- as.factor(crew_phan_df$Time)

mod1_acc <- longCombat(idvar="subject", batchvar="scanner",
 features=c(subcortical, cortical), timevar="Time", formula="Time*Accuracy",
 ranef="(1|subject)", data=crew_phan_df)
mod1 <- mod1_acc

data_combat <- mod1$data_combat
data_combat <- data_combat[, paste0(c(subcortical, cortical), ".combat")]
names(data_combat) <- gsub(".combat", "", c(subcortical, cortical))
names(data_combat) <- paste0("combat_", names(data_combat))
all_data <- cbind(crew_phan_df, data_combat)

tmp_data <- all_data
all_data <- all_data[all_data$group == "Crew",]
row.names(all_data) <- 1:nrow(all_data)

#write.csv(all_data, paste0("~/Documents/nasa_antarctica/NASA/data/longCombatCrewCog_", Sys.Date(), ".csv"), row.names=FALSE)


################################### Model ###################################

simp <- c("Accumbens", "Amygdala", "Caudate", "Hippocampus",
  "Pallidum", "Putamen", "Thalamus", "Frontal", "Temporal", "Parietal", "Occipital")
results <- data.frame(Region=simp, LongCombat_Coef_t12=rep(NA, length(simp)),
  LongCombat_P_t12=rep(NA, length(simp)), LongCombat_Coef_t18=rep(NA, length(simp)),
  LongCombat_P_t18=rep(NA, length(simp)), FixedScan_Coef_t12=rep(NA, length(simp)),
  FixedScan_P_t12=rep(NA, length(simp)), FixedScan_Coef_t18=rep(NA, length(simp)),
  FixedScan_P_t18=rep(NA, length(simp)), IndT_MeanDiff_t12=rep(NA, length(simp)),
  IndT_P_t12=rep(NA, length(simp)), IndT_MeanDiff_t18=rep(NA, length(simp)),
  IndT_P_t18=rep(NA, length(simp)))

######### Model with Combat Data #########


for (i in 1:length(c(subcortical, cortical))) {
  region <- paste0("combat_", c(subcortical, cortical))[i]
  names(all_data)[names(all_data) == region] <- simp[i]
  cog_mod <- lmer(formula(paste(simp[i], "~ (1|subject) + t12 + t18 + Accuracy + t12:Accuracy + t18:Accuracy")), data=all_data)

  assign(paste0(region, "_cog_mod"), cog_mod)
}

print(tab_model(combat_vol_miccai_ave_Accumbens_Area_cog_mod,
  combat_vol_miccai_ave_Amygdala_cog_mod,
  combat_vol_miccai_ave_Caudate_cog_mod,
  combat_vol_miccai_ave_Hippocampus_cog_mod,
  combat_vol_miccai_ave_Pallidum_cog_mod,
  combat_vol_miccai_ave_Putamen_cog_mod,
  combat_vol_miccai_ave_Thalamus_Proper_cog_mod,
  combat_Frontal_Vol_time23_mod, combat_Parietal_Vol_cog_mod,
  combat_Occipital_Vol_time23_mod, combat_Temporal_Vol_cog_mod, show.ci=FALSE,
  p.val='kr', p.adjust='fdr', file="~/Documents/nasa_antarctica/NASA/tables/lmeTable_cog.html"))













#
