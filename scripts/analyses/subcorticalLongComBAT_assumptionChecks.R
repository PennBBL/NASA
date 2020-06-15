### This script checks assumptions of longitudinal ComBat and produces
### relevant visualizations.
###
### Ellyn Butler
### June 15, 2020

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
