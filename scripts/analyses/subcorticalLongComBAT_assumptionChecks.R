### This script checks assumptions of longitudinal ComBat and produces
### relevant visualizations.
###
### Ellyn Butler
### June 15, 2020 - July 15, 2020

library('ggplot2')
library('ggpubr')
library('reshape2')

longcom_df <- read.csv("~/Documents/nasa_antarctica/NASA/data/longCombatCrew.csv")

subcortical <- paste0("combat_", c("vol_miccai_ave_Accumbens_Area",
  "vol_miccai_ave_Amygdala", "vol_miccai_ave_Caudate", "vol_miccai_ave_Hippocampus",
  "vol_miccai_ave_Pallidum", "vol_miccai_ave_Putamen", "vol_miccai_ave_Thalamus_Proper"))
longcom_df <- longcom_df[,c("subject", subcortical)]
names(longcom_df) <- c("subject", "Accumbens", "Amygdala", "Caudate", "Hippocampus",
  "Pallidum", "Putamen", "Thalamus")

long_df <- reshape2::melt(longcom_df, "subject", c("Accumbens", "Amygdala", "Caudate",
  "Hippocampus", "Pallidum", "Putamen", "Thalamus"))


hist_plot <- ggplot(long_df, aes(x=value)) + theme_linedraw() +
  geom_histogram(bins=15) + facet_grid(. ~ variable, scale="free") +
  labs(x=expression("Volume (mm"^3*")")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/normalAssumption.pdf", width=7, height=4)
hist_plot
dev.off()

################################################################################

# Raw values by sex
raw_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/dataForLongCombat.csv')
longraw_df <- reshape2::melt(raw_df, c('subject', 'sex'),
  c('vol_miccai_ave_Accumbens_Area', 'vol_miccai_ave_Amygdala', 'vol_miccai_ave_Caudate',
  'vol_miccai_ave_Hippocampus', 'vol_miccai_ave_Pallidum', 'vol_miccai_ave_Putamen',
  'vol_miccai_ave_Thalamus_Proper'))
longraw_df$variable <- recode(longraw_df$variable, "vol_miccai_ave_Accumbens_Area"="Accumbens",
    "vol_miccai_ave_Amygdala"="Amygdala", "vol_miccai_ave_Caudate"="Caudate",
    "vol_miccai_ave_Hippocampus"="Hippocampus", "vol_miccai_ave_Pallidum"="Pallidum",
    "vol_miccai_ave_Putamen"="Putamen", "vol_miccai_ave_Thalamus_Proper"="Thalamus")

hist_sex_plot <- ggplot(longraw_df, aes(x=value, fill=sex)) + theme_linedraw() +
  geom_histogram(bins=15) + facet_grid(. ~ variable, scale="free") +
  labs(x=expression("Volume (mm"^3*")")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/sexCheck.pdf", width=7, height=4)
hist_sex_plot
dev.off()

################################################################################

# Check mean values for crew
mean(longcom_df$Accumbens)
mean(longcom_df$Amygdala)
mean(longcom_df$Caudate)
mean(longcom_df$Hippocampus)
mean(longcom_df$Pallidum)
mean(longcom_df$Putamen)
mean(longcom_df$Thalamus)
