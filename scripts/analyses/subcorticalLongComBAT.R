### This script tests for differences in subcortical volumes before and after
### a stay in Antarctica, using longitudinal combat to address site effects
###
### Ellyn Butler
### May 28, 2020 - June 12, 2020

library('miceadds')
library('ggplot2')
library('ggseg')
library('ggpubr')
library('dplyr')
library('lme4')
library('pbkrtest')
library('R.utils')
source.all('~/Documents/longCombat/R')

set.seed(20)


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
ind_data <- final_df[final_df$group %in% c("Crew", "Phantom"), ]
final_df$Time <- recode(final_df$Time, "t1"="t0", "t2"="t0", "t3"="t0")


################################### Plot ###################################

crew_phan_df <- final_df[final_df$group %in% c("Crew", "Phantom"), ]
row.names(crew_phan_df) <- 1:nrow(crew_phan_df)
crew_phan_df$Crew <- recode(crew_phan_df$group, "Crew"=1, "Phantom"=0)
crew_phan_df$Time2 <- recode(crew_phan_df$Time, "t0"=0, "t12"=1, "t18"=0)
crew_phan_df$Time3 <- recode(crew_phan_df$Time, "t0"=0, "t12"=0, "t18"=1)

mod1 <- longCombat(idvar="subject_1", batchvar="scanner",
 features=grep("vol_", names(crew_phan_df), value=TRUE),
 formula="Crew:Time2 + Crew:Time3", ranef="(1|subject_1)", data=crew_phan_df)
 #ranef="1 + (1|subject_1)" Probably not, since overall intercept isn't random
 #Is the "Crew:" part necessary, since I coded it such that all phantom scans are at t0?

data_combat <- mod1$data_combat
data_combat <- data_combat[, subcortical]
names(data_combat) <- paste0("combat_", names(data_combat))
all_data <- cbind(crew_phan_df, data_combat)
#all_data <- all_data[, c("subject_1", "Time", "scanner", "group", "sex", "age",
#  grep("combat_", names(all_data), value=TRUE))]
tmp_data <- all_data
all_data <- all_data[all_data$group == "Crew",]
row.names(all_data) <- 1:nrow(all_data)

#### Plot to see if site effects gone
for (region in grep("ol", names(all_data), value=TRUE)) {
  all_data[,paste0("perbase_", region)] <- NA
  for (sub in unique(all_data$subject_1)) {
    if ("t0" %in% all_data[all_data$subject_1 == sub, "Time"]) {
      baseval <- all_data[all_data$subject_1 == sub & all_data$Time == "t0", region]
      timepoints <- unique(all_data[all_data$subject_1 == sub, "Time"])
      for (tp in timepoints) {
        all_data[all_data$subject_1 == sub & all_data$Time == tp, paste0("perbase_", region)] <- all_data[all_data$subject_1 == sub & all_data$Time == tp, region]/baseval
      }
    }
  }
}

crew_df <- reshape2::melt(all_data, c("subject_1", "Time", "scanner"),
  c(paste0("perbase_combat_", subcortical), paste0("perbase_", subcortical)))
names(crew_df) <- c("CrewMember", "Time", "Scanner", "Region", "PercentBase")
crew_df$PercentBase <- crew_df$PercentBase*100

for (i in 1:nrow(crew_df)) {
  crewmem <- crew_df[i, "CrewMember"]
  scanners <- crew_df[crew_df$CrewMember == crewmem &
    crew_df$Region == "perbase_combat_vol_miccai_ave_Accumbens_Area", "Scanner"]
  scanstring <- paste(sapply(scanners, paste, collapse="-"), collapse="-")
  crew_df[i, "ScannerOrder"] <- scanstring
}
crew_df$ScannerOrder <- ordered(crew_df$ScannerOrder, c("CGN-HOB-CGN", "CGN-HOB",
  "CGN-CHR-CGN", "CGN-CHR", "CGN", "CHR-CGN", "HOB-CHR", "HOB-CGN"))

crew_combat_df <- crew_df[crew_df$Region %in% grep("combat",
  crew_df$Region, value=TRUE),]
crew_combat_df$Region <- recode(crew_combat_df$Region,
    "perbase_combat_vol_miccai_ave_Accumbens_Area"="Accumbens",
    "perbase_combat_vol_miccai_ave_Amygdala"="Amygdala",
    "perbase_combat_vol_miccai_ave_Caudate"="Caudate",
    "perbase_combat_vol_miccai_ave_Hippocampus"="Hippocampus",
    "perbase_combat_vol_miccai_ave_Pallidum"="Pallidum",
    "perbase_combat_vol_miccai_ave_Putamen"="Putamen",
    "perbase_combat_vol_miccai_ave_Thalamus_Proper"="Thalamus")

crew_raw_df <- crew_df[!(crew_df$Region %in% grep("combat",
  crew_df$Region, value=TRUE)),]
crew_raw_df$Region <- recode(crew_raw_df$Region,
    "perbase_vol_miccai_ave_Accumbens_Area"="Accumbens",
    "perbase_vol_miccai_ave_Amygdala"="Amygdala",
    "perbase_vol_miccai_ave_Caudate"="Caudate",
    "perbase_vol_miccai_ave_Hippocampus"="Hippocampus",
    "perbase_vol_miccai_ave_Pallidum"="Pallidum",
    "perbase_vol_miccai_ave_Putamen"="Putamen",
    "perbase_vol_miccai_ave_Thalamus_Proper"="Thalamus")

crew_combat_plot <- ggplot(crew_combat_df, aes(x=Time, y=PercentBase, color=ScannerOrder,
      group=CrewMember)) + ylim(70, 130) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "red", "gray40",
      "gray", "black")) +
    ggtitle(expression(paste(bold("After"), " Longitudinal ComBat Adjustment"))) +
    theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))

crew_raw_plot <- ggplot(crew_raw_df, aes(x=Time, y=PercentBase, color=ScannerOrder,
      group=CrewMember)) + ylim(70, 130) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "red", "gray40",
      "gray", "black")) +
    ggtitle(expression(paste(bold("Before"), " Longitudinal ComBat Adjustment"))) +
    theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/beforeAndAfterCombat.pdf", width=14, height=5)
ggarrange(crew_raw_plot, crew_combat_plot, ncol=2)
dev.off()

######### Not percent base values plot #########
crew_values_df <- reshape2::melt(all_data, c("subject_1", "Time", "scanner"),
  c(paste0("combat_", subcortical), subcortical))
names(crew_values_df) <- c("CrewMember", "Time", "Scanner", "Region", "Values")
crew_values_df$DataType <- c(rep("Combat", 448), rep("Raw", 448))

for (i in 1:nrow(crew_values_df)) {
  crewmem <- crew_values_df[i, "CrewMember"]
  scanners <- crew_values_df[crew_values_df$CrewMember == crewmem &
    crew_values_df$Region == "combat_vol_miccai_ave_Accumbens_Area", "Scanner"]
  scanstring <- paste(sapply(scanners, paste, collapse="-"), collapse="-")
  crew_values_df[i, "ScannerOrder"] <- scanstring
}
crew_df$ScannerOrder <- ordered(crew_df$ScannerOrder, c("CGN-HOB-CGN", "CGN-HOB",
  "CGN-CHR-CGN", "CGN-CHR", "CGN", "CHR-CGN", "HOB-CHR", "HOB-CGN"))

crew_values_df$Region <- recode(crew_values_df$Region,
    "vol_miccai_ave_Accumbens_Area"="Accumbens",
    "vol_miccai_ave_Amygdala"="Amygdala",
    "vol_miccai_ave_Caudate"="Caudate",
    "vol_miccai_ave_Hippocampus"="Hippocampus",
    "vol_miccai_ave_Pallidum"="Pallidum",
    "vol_miccai_ave_Putamen"="Putamen",
    "vol_miccai_ave_Thalamus_Proper"="Thalamus",
    "combat_vol_miccai_ave_Accumbens_Area"="Accumbens",
    "combat_vol_miccai_ave_Amygdala"="Amygdala",
    "combat_vol_miccai_ave_Caudate"="Caudate",
    "combat_vol_miccai_ave_Hippocampus"="Hippocampus",
    "combat_vol_miccai_ave_Pallidum"="Pallidum",
    "combat_vol_miccai_ave_Putamen"="Putamen",
    "combat_vol_miccai_ave_Thalamus_Proper"="Thalamus")

crew_values_plot <- ggplot(crew_values_df, aes(x=Time, y=Values, color=ScannerOrder,
      group=CrewMember)) +
    theme_linedraw() + geom_line() + facet_grid(DataType ~ Region, scales="free_y") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "red", "gray40",
      "gray", "black")) + theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/beforeAndAfterCombat_values.pdf", width=12, height=12)
crew_values_plot
dev.off()


################################### Model ###################################


results <- data.frame(Region=c("Accumbens", "Amygdala", "Caudate", "Hippocampus",
  "Pallidum", "Putamen", "Thalamus"), LongCombat_Coef_Time2=rep(NA, 7),
  LongCombat_P_Time2=rep(NA, 7), LongCombat_Coef_Time3=rep(NA, 7),
  LongCombat_P_Time3=rep(NA, 7), FixedScan_Coef_Time2=rep(NA, 7),
  FixedScan_P_Time2=rep(NA, 7), FixedScan_Coef_Time3=rep(NA, 7),
  FixedScan_P_Time3=rep(NA, 7), IndT_MeanDiff_Time2=rep(NA, 7),
  IndT_P_Time2=rep(NA, 7), IndT_MeanDiff_Time3=rep(NA, 7), IndT_P_Time3=rep(NA, 7))

######### Model with Combat Data #########

for (i in 1:length(subcortical)) {
  region <- paste0("combat_", subcortical)[i]
  time2_mod <- lmer(formula(paste(region, "~ (1|subject_1) + Time2")), data=all_data)
  time23_mod <- lmer(formula(paste(region, "~ (1|subject_1) + Time2 + Time3")), data=all_data)
  time3_mod <- lmer(formula(paste(region, "~ (1|subject_1) + Time3")), data=all_data)

  ## Test if adding in Time 2 explains additional variance in within subject variability
  results[i, "LongCombat_P_Time2"] <- KRmodcomp(time23_mod, time3_mod)$stats$p.value
  results[i, "LongCombat_Coef_Time2"] <- time23_mod@beta[2]

  ## Test if adding in Time 3 explains additional variance in within subject variability
  results[i, "LongCombat_P_Time3"] <- KRmodcomp(time23_mod, time2_mod)$stats$p.value
  results[i, "LongCombat_Coef_Time3"] <- time23_mod@beta[3]
}

######### Model with Fixed Effect for Scanner in Raw Data #########

fe_data <- tmp_data

for (i in 1:length(subcortical)) {
  region <- subcortical[i]
  time2_mod <- lmer(formula(paste(region, "~ 1 + (1|subject_1) + Time2 + group")), data=fe_data) #Include "1 +"?
  time23_mod <- lmer(formula(paste(region, "~ 1 + (1|subject_1) + Time2 + Time3 + group")), data=fe_data)
  time3_mod <- lmer(formula(paste(region, "~ 1 + (1|subject_1) + Time3 + group")), data=fe_data)

  ## Test if adding in Time 2 explains additional variance in within subject variability
  results[i, "FixedScan_P_Time2"] <- KRmodcomp(time23_mod, time3_mod)$stats$p.value
  results[i, "FixedScan_Coef_Time2"] <- time23_mod@beta[2]

  ## Test if adding in Time 3 explains additional variance in within subject variability
  results[i, "FixedScan_P_Time3"] <- KRmodcomp(time23_mod, time2_mod)$stats$p.value
  results[i, "FixedScan_Coef_Time3"] <- time23_mod@beta[3]
}

results <- results[, 1:9]

write.csv(results, file='~/Documents/nasa_antarctica/NASA/data/results/longCombat_vs_FixedScanner.csv', row.names=FALSE)

resultsTime2 <- results[, c('Region', 'LongCombat_Coef_Time2', 'LongCombat_P_Time2')]
resultsTime2$Time <- 't12'
names(resultsTime2) <- c('Region', 'Coef', 'P', 'Time')
resultsTime3 <- results[, c('Region', 'LongCombat_Coef_Time3', 'LongCombat_P_Time3')]
resultsTime3$Time <- 't18'
names(resultsTime3) <- c('Region', 'Coef', 'P', 'Time')
longcombat_results <- rbind(resultsTime2, resultsTime3)

longcombat_results$P_FDR <- p.adjust(longcombat_results$P, method='fdr')
longcombat_results$P_FDR_NegLog10 <- -log10(longcombat_results$P_FDR)


######### Independent Samples T-tests #########

ind_data <- ind_data[, c("subject_1", "Time", "scanner", "group", subcortical)]
# TO DO

################################ Brain Figure ################################

longcombat_results$area <- recode(longcombat_results$Region,
  "Hippocampus"="hippocampus", "Thalamus"="thalamus proper", "Putamen"="putamen",
  "Amygdala"="amygdala", "Pallidum"="pallidum", "Caudate"="caudate")

aseg_t12 <- aseg
for (i in 1:nrow(aseg_t12)) {
  thisarea <- as.character(aseg_t12[i, 'area'])
  if (thisarea %in% longcombat_results$area) {
    aseg_t12[i, 'P_FDR_NegLog10'] <- longcombat_results[longcombat_results$area == thisarea &
      longcombat_results$Time == 't12', 'P_FDR_NegLog10']
  }
}
aseg_t18 <- aseg
for (i in 1:nrow(aseg_t18)) {
  thisarea <- as.character(aseg_t18[i, 'area'])
  if (thisarea %in% longcombat_results$area) {
    aseg_t18[i, 'P_FDR_NegLog10'] <- longcombat_results[longcombat_results$area == thisarea &
      longcombat_results$Time == 't18', 'P_FDR_NegLog10']
  }
}

p_t12 <- ggseg(aseg_t12, atlas="aseg", hemisphere=c("left", "right"),
  mapping=aes(fill=P_FDR_NegLog10), size=.1, colour="black") +
  labs(fill=expression(-log[10]*"p-value")) +
  scale_fill_gradient(low="lavenderblush1", high="red3", limits=c(0, 5)) +
  theme(text=element_text(size=14), axis.title.x=element_blank(),
    axis.text.x=element_blank()) +
  ggtitle("Effect Immediately After Antarctica (t12)")

p_t18 <- ggseg(aseg_t18, atlas="aseg", hemisphere=c("left", "right"),
  mapping=aes(fill=P_FDR_NegLog10), size=.1, colour="black") +
  labs(fill=expression(-log[10]*"p-value")) +
  scale_fill_gradient(low="lavenderblush1", high="red3", limits=c(0, 5)) +
  theme(text=element_text(size=14), axis.title.x=element_blank(),
    axis.text.x=element_blank()) + #, family="Arial"
  ggtitle("Effect Six Months After Antarctica (t18)")

pdf(file="~/Documents/nasa_antarctica/NASA/plots/ggsegNegLogP.pdf", width=14, height=5)
ggarrange(p_t12, p_t18, ncol=2)
dev.off()
