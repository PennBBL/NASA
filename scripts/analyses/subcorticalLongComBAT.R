### This script tests for differences in subcortical volumes before and after
### a stay in Antarctica, using longitudinal combat to address site effects
###
### Ellyn Butler
### May 28, 2020 - June 3, 2020

library('miceadds')
library('ggplot2')
library('ggpubr')
library('dplyr')
library('lme4')
library('pbkrtest')
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
subcortical <- c("vol_miccai_ave_Accumbens_Area", "vol_miccai_ave_Amygdala",
  "vol_miccai_ave_Caudate", "vol_miccai_ave_Hippocampus", "vol_miccai_ave_Pallidum",
  "vol_miccai_ave_Putamen", "vol_miccai_ave_Thalamus_Proper")
vol_df <- vol_df[, c("subject_1", "Time", "scanner", "group",
  grep("_ave_", names(vol_df), value=TRUE))]

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


################################### Analysis ###################################


mod1 <- longCombat(idvar="subject_1", batchvar="scanner",
 features=grep("vol_", names(final_df), value=TRUE),
 formula="I(group)*I(Time)", ranef="(1|subject_1)", data=final_df)

data_combat <- mod1$data_combat
data_combat <- data_combat[, subcortical]
names(data_combat) <- paste0("combat_", names(data_combat))
all_data <- cbind(final_df, data_combat)
all_data <- all_data[, c("subject_1", "Time", "scanner", "group", "sex", "age",
  grep("combat_", names(all_data), value=TRUE))]

#### Plot to see if site effects gone
for (region in grep("ol", names(all_data), value=TRUE)) {
  all_data[,paste0("perbase_", region)] <- NA
  for (sub in unique(all_data$subject_1)) {
    if (all_data[all_data$subject_1 == sub, "group"] %in% c("Crew", "Control")) {
      if ("t0" %in% all_data[all_data$subject_1 == sub, "Time"]) {
        baseval <- all_data[all_data$subject_1 == sub & all_data$Time == "t0", region]
        timepoints <- unique(all_data[all_data$subject_1 == sub, "Time"])
        for (tp in timepoints) {
          all_data[all_data$subject_1 == sub & all_data$Time == tp, paste0("perbase_", region)] <- all_data[all_data$subject_1 == sub & all_data$Time == tp, region]/baseval
        }
      }
    } else {
      baseval <- all_data[all_data$subject_1 == sub & all_data$scanner == "CGN", region]
      scanners <- c("CGN", "HOB", "CHR")
      for (scan in scanners) {
        all_data[all_data$subject_1 == sub & all_data$scanner == scan, paste0("perbase_", region)] <- all_data[all_data$subject_1 == sub & all_data$scanner == scan, region]/baseval
      }
    }
  }
}

#### Model
all_data$Time2 <- with(all_data, ifelse(Time == "t12", 1,
  ifelse(Time == "t0" | Time == "t18", 0, NA)))
all_data$Time3 <- with(all_data, ifelse(Time == "t18", 1,
  ifelse(Time == "t0" | Time == "t12", 0, NA)))

# Linear Mixed Effects Models (maybe add 3 versus 1) Add indicator for Crew
small_mod <- lmer(combat_vol_miccai_ave_Accumbens_Area ~ (1|subject_1) + Crew, data=all_data)
med_mod <- lmer(combat_vol_miccai_ave_Accumbens_Area ~ (1|subject_1) + Crew + Crew:Time2, data=all_data)
big_mod <- lmer(combat_vol_miccai_ave_Accumbens_Area ~ (1|subject_1) + Crew + Crew:Time2 + Crew:Time3, data=all_data)
other_mod <- lmer(combat_vol_miccai_ave_Accumbens_Area ~ (1|subject_1) + Crew + Crew:Time3, data=all_data)
KRmodcomp(med_mod, small_mod)
KRmodcomp(big_mod, med_mod)
