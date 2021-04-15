### This script checks assumptions of longitudinal ComBat and produces
### relevant visualizations.
###
### Ellyn Butler
### June 15, 2020 - July 15, 2020
### March 9, 2021: Add lobes

library('ggplot2') # Version 3.3.2
library('ggpubr') # Version 0.4.0
library('dplyr') # Version 1.0.2
library('reshape2') # Version 1.4.4

longcom_df <- read.csv("~/Documents/nasa_antarctica/NASA/data/longCombatCrew_2021-03-08.csv")

subcortical <- paste0("combat_", c("vol_miccai_ave_Accumbens_Area",
  "vol_miccai_ave_Amygdala", "vol_miccai_ave_Caudate", "vol_miccai_ave_Hippocampus",
  "vol_miccai_ave_Pallidum", "vol_miccai_ave_Putamen", "vol_miccai_ave_Thalamus_Proper"))
cortical <- paste0("combat_", c("Temporal_Vol", "Parietal_Vol", "Occipital_Vol", "Frontal_Vol"))
longcom_df <- longcom_df[,c("subject", subcortical, cortical)]
names(longcom_df) <- c("subject", "Accumbens", "Amygdala", "Caudate", "Hippocampus",
  "Pallidum", "Putamen", "Thalamus", "Temporal", "Parietal", "Occipital", "Frontal")

subcort <- c("Accumbens", "Amygdala", "Caudate", "Hippocampus", "Pallidum", "Putamen", "Thalamus")
cort <- c("Temporal", "Parietal", "Occipital", "Frontal")
long_df <- reshape2::melt(longcom_df, "subject", c(subcort, cort))


subcort_hist_plot <- ggplot(long_df[long_df$variable %in% subcort, ],
    aes(x=value)) + theme_linedraw() +
  geom_histogram(bins=15) + facet_grid(. ~ variable, scale="free") +
  labs(x=expression("Volume (mm"^3*")")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

cort_hist_plot <- ggplot(long_df[long_df$variable %in% cort, ],
    aes(x=value)) + theme_linedraw() +
  geom_histogram(bins=15) + facet_grid(. ~ variable, scale="free") +
  labs(x=expression("Volume (mm"^3*")")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

normal_plot <- cowplot::plot_grid(subcort_hist_plot, cort_hist_plot, labels=c('A', 'B'), nrow=2)


pdf(file="~/Documents/nasa_antarctica/NASA/plots/normalAssumption.pdf", width=7, height=8)
normal_plot
dev.off()

################################################################################

#### MAY WANT TO ADD CORTICAL HERE
# Raw values by sex
raw_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/dataForLongCombat.csv')
longraw_df <- reshape2::melt(raw_df, c('subject', 'sex'),
  c('vol_miccai_ave_Accumbens_Area', 'vol_miccai_ave_Amygdala', 'vol_miccai_ave_Caudate',
  'vol_miccai_ave_Hippocampus', 'vol_miccai_ave_Pallidum', 'vol_miccai_ave_Putamen',
  'vol_miccai_ave_Thalamus_Proper', 'Temporal_Vol', 'Parietal_Vol', 'Occipital_Vol',
  'Frontal_Vol'))
longraw_df$variable <- recode(longraw_df$variable, "vol_miccai_ave_Accumbens_Area"="Accumbens",
    "vol_miccai_ave_Amygdala"="Amygdala", "vol_miccai_ave_Caudate"="Caudate",
    "vol_miccai_ave_Hippocampus"="Hippocampus", "vol_miccai_ave_Pallidum"="Pallidum",
    "vol_miccai_ave_Putamen"="Putamen", "vol_miccai_ave_Thalamus_Proper"="Thalamus",
    'Temporal_Vol'='Temporal', 'Parietal_Vol'='Parietal', 'Occipital_Vol'='Occipital',
    'Frontal_Vol'='Frontal')

hist_sex_plot <- ggplot(longraw_df, aes(x=value, fill=sex)) + theme_linedraw() +
  geom_histogram(bins=15) + facet_grid(. ~ variable, scale="free") +
  labs(x=expression("Volume (mm"^3*")")) + theme(legend.position='bottom') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/sexCheck.pdf", width=10, height=4.2)
hist_sex_plot
dev.off()

# Raw values by age
longraw_df <- reshape2::melt(raw_df, c('subject', 'age'),
  c('vol_miccai_ave_Accumbens_Area', 'vol_miccai_ave_Amygdala', 'vol_miccai_ave_Caudate',
  'vol_miccai_ave_Hippocampus', 'vol_miccai_ave_Pallidum', 'vol_miccai_ave_Putamen',
  'vol_miccai_ave_Thalamus_Proper', 'Temporal_Vol', 'Parietal_Vol', 'Occipital_Vol',
  'Frontal_Vol'))
longraw_df$variable <- recode(longraw_df$variable, "vol_miccai_ave_Accumbens_Area"="Accumbens",
    "vol_miccai_ave_Amygdala"="Amygdala", "vol_miccai_ave_Caudate"="Caudate",
    "vol_miccai_ave_Hippocampus"="Hippocampus", "vol_miccai_ave_Pallidum"="Pallidum",
    "vol_miccai_ave_Putamen"="Putamen", "vol_miccai_ave_Thalamus_Proper"="Thalamus",
    'Temporal_Vol'='Temporal', 'Parietal_Vol'='Parietal', 'Occipital_Vol'='Occipital',
    'Frontal_Vol'='Frontal')

subcort_scatter_age_plot <- ggplot(longraw_df[longraw_df$variable %in% subcort, ],
    aes(x=age, y=value, colour=subject)) +
  theme_linedraw() + geom_point() + facet_grid(variable ~ ., scale="free") +
  labs(y=expression("Volume (mm"^3*")")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position='none')

cort_scatter_age_plot <- ggplot(longraw_df[longraw_df$variable %in% cort, ],
    aes(x=age, y=value, colour=subject)) +
  theme_linedraw() + geom_point() + facet_grid(variable ~ ., scale="free") +
  labs(y='') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position='none')

pdf(file="~/Documents/nasa_antarctica/NASA/plots/ageCheck.pdf", width=6, height=7.5)
cowplot::plot_grid(subcort_scatter_age_plot, cort_scatter_age_plot, labels=c('A', 'B'), ncol=2)
dev.off()


# Raw values by crew
longraw_df <- reshape2::melt(raw_df, c('subject', 'group'),
  c('vol_miccai_ave_Accumbens_Area', 'vol_miccai_ave_Amygdala', 'vol_miccai_ave_Caudate',
  'vol_miccai_ave_Hippocampus', 'vol_miccai_ave_Pallidum', 'vol_miccai_ave_Putamen',
  'vol_miccai_ave_Thalamus_Proper', 'Temporal_Vol', 'Parietal_Vol', 'Occipital_Vol',
  'Frontal_Vol'))
longraw_df$variable <- recode(longraw_df$variable, "vol_miccai_ave_Accumbens_Area"="Accumbens",
    "vol_miccai_ave_Amygdala"="Amygdala", "vol_miccai_ave_Caudate"="Caudate",
    "vol_miccai_ave_Hippocampus"="Hippocampus", "vol_miccai_ave_Pallidum"="Pallidum",
    "vol_miccai_ave_Putamen"="Putamen", "vol_miccai_ave_Thalamus_Proper"="Thalamus",
    'Temporal_Vol'='Temporal', 'Parietal_Vol'='Parietal', 'Occipital_Vol'='Occipital',
    'Frontal_Vol'='Frontal')

hist_crew_plot <- ggplot(longraw_df, aes(x=value, fill=group)) + theme_linedraw() +
  geom_histogram(bins=15) + facet_grid(. ~ variable, scale="free") +
  labs(x=expression("Volume (mm"^3*")")) + theme(legend.position='bottom') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/crewCheck.pdf", width=10, height=4.2)
hist_crew_plot
dev.off()

################################################################################

# - Check if including cortical with subcortical in longitudinal combat was useful: “I think you could look at the differences in density plots of the gammahat (means) and delta2hat (variances) for the different tissue classes within a given row (i.e. a given scanner) I would suggest plot(density(data))) and then overlaying using lines(density(data), col=“differentcolor”) or something equivalent”


################################################################################

# Check mean values for crew
mean(longcom_df$Accumbens)
mean(longcom_df$Amygdala)
mean(longcom_df$Caudate)
mean(longcom_df$Hippocampus)
mean(longcom_df$Pallidum)
mean(longcom_df$Putamen)
mean(longcom_df$Thalamus)
