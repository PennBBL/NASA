### This script makes a scatter plot of value before and after applying
### longitudinal combat, colored by scanner.
###
### Ellyn Butler
### July 21, 2020

library('ggplot2')
library('dplyr')
library('ggpubr')
library('reshape2')

# Load combat-ed data
combat_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/longCombatCrew.csv')
combat_df <- reshape2::melt(combat_df, c('subject', 'Time', 'scanner'),
  grep('combat_', names(combat_df), value=TRUE))
names(combat_df)[names(combat_df) == 'variable'] <- 'Region'
names(combat_df)[names(combat_df) == 'value'] <- 'value_after'
combat_df$Region <- recode(combat_df$Region,
    'combat_vol_miccai_ave_Accumbens_Area'='Accumbens',
    'combat_vol_miccai_ave_Amygdala'='Amygdala',
    'combat_vol_miccai_ave_Caudate'='Caudate',
    'combat_vol_miccai_ave_Hippocampus'='Hippocampus',
    'combat_vol_miccai_ave_Pallidum'='Pallidum',
    'combat_vol_miccai_ave_Putamen'='Putamen',
    'combat_vol_miccai_ave_Thalamus_Proper'='Thalamus')


# Load raw data
raw_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/dataForLongCombat.csv')
raw_df <- reshape2::melt(raw_df, c('subject', 'Time', 'scanner'),
  c('vol_miccai_ave_Accumbens_Area', 'vol_miccai_ave_Amygdala', 'vol_miccai_ave_Caudate',
  'vol_miccai_ave_Hippocampus', 'vol_miccai_ave_Pallidum', 'vol_miccai_ave_Putamen',
  'vol_miccai_ave_Thalamus_Proper'))
names(raw_df)[names(raw_df) == 'variable'] <- 'Region'
names(raw_df)[names(raw_df) == 'value'] <- 'value_before'
raw_df$Region <- recode(raw_df$Region,
    'vol_miccai_ave_Accumbens_Area'='Accumbens',
    'vol_miccai_ave_Amygdala'='Amygdala',
    'vol_miccai_ave_Caudate'='Caudate',
    'vol_miccai_ave_Hippocampus'='Hippocampus',
    'vol_miccai_ave_Pallidum'='Pallidum',
    'vol_miccai_ave_Putamen'='Putamen',
    'vol_miccai_ave_Thalamus_Proper'='Thalamus')

final_df <- merge(combat_df, raw_df)

for (region in as.character(unique(final_df$Region))) {
  combat_plot <- ggplot(final_df[final_df$Region == region, ],
      aes(x=value_before, y=value_after, colour=scanner)) +
    theme_linedraw() + geom_point() + geom_abline(slope=1, intercept=0) +
    facet_grid(. ~ Time) + xlab('Volume Before Adjustment') +
    ylab('Volume After Adjustment') + ggtitle(region)
  assign(paste0(region, '_plot'), combat_plot)
}

pdf(file='~/Documents/nasa_antarctica/NASA/plots/beforeAfterScatter.pdf', width=24, height=7)
ggarrange(Accumbens_plot, Amygdala_plot, Caudate_plot, Hippocampus_plot,
  Pallidum_plot, Putamen_plot, Thalamus_plot, nrow=2, ncol=4)
dev.off()
