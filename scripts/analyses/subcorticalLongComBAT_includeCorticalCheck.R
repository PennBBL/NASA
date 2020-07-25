### This script checks if the distribution of standardized (mean=0, variance=1)
### brain features exhibit similar scanner effects across subcortical and
### cortical regions.
###
### Ellyn Butler
### July 24, 2020

library('ggplot2')
library('dplyr')
library('reshape2')

df <- read.csv('~/Documents/nasa_antarctica/NASA/data/dataForLongCombat.csv')
subcortical <- paste0('vol_miccai_ave_', c('Accumbens_Area', 'Amygdala',
  'Caudate', 'Hippocampus', 'Pallidum', 'Putamen', 'Thalamus_Proper'))
cortical <- grep('vol_', names(df), value=TRUE)[!(grep('vol_', names(df), value=TRUE)
  %in% subcortical)]

df[,c(subcortical, cortical)] <- scale(df[,c(subcortical, cortical)])

long_df <- reshape2::melt(df, c('subject', 'scanner', 'group'),
  grep('vol_', names(df), value=TRUE))

getType <- function(i) {
  region <- long_df[i, 'variable']
  if (region %in% subcortical) { 'subcortical'
  } else { 'cortical' }
}
long_df$type <- sapply(1:nrow(long_df), getType)


corticalCheck_plot <- ggplot(long_df, aes(x=value, fill=type)) +
  theme_linedraw() + geom_density(alpha=.5) + facet_grid(. ~ scanner) +
  labs(x='Standardized Brain Region Volumes')


pdf(file='~/Documents/nasa_antarctica/NASA/plots/corticalCheck.pdf', width=6, height=3)
corticalCheck_plot
dev.off()
