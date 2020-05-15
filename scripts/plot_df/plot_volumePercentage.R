### This script creates plots of percent change from baseline volume
### for hippocampal subfields, colored by scanner pattern
### (configured for local machine)
###
### Ellyn Butler
### May 15, 2020

# Load libraries
library('data.table')
library('plyr')
library('ggplot2')
library('gridExtra')

# Load data
nasa_df <- read.csv("~/Documents/chead_home/erb_data/nasa/nasa_strucRestDTI_Tyler.csv")
nasa_df <- nasa_df[,c("group", "subject_1", "Time", "scanner",
  "vol_princeton_ave_CA1", "vol_princeton_ave_CA23", "vol_princeton_ave_DG",
  "vol_princeton_ave_ERC", "vol_princeton_ave_PHC", "vol_princeton_ave_PRC",
  "vol_princeton_ave_SUB")]

nasa_df <- nasa_df[!(nasa_df$subject_1 %in% c("concordia_010", "concordia_109")),]
row.names(nasa_df) <- 1:nrow(nasa_df)

for (region in grep("vol_", names(nasa_df), value=TRUE)) {
  nasa_df[,paste0("perbase_", region)] <- NA
  for (sub in unique(nasa_df$subject_1)) {
    baseval <- nasa_df[nasa_df$subject_1 == sub & nasa_df$Time %in% c("t1", "t0"), region]
    timepoints <- unique(nasa_df[nasa_df$subject_1 == sub, "Time"])
    for (tp in timepoints) {
      nasa_df[nasa_df$subject_1 == sub & nasa_df$Time == tp, paste0("perbase_", region)] <- nasa_df[nasa_df$subject_1 == sub & nasa_df$Time == tp, region]/baseval
    }
  }
}

regions=c("perbase_vol_princeton_ave_CA1", "perbase_vol_princeton_ave_CA23",
  "perbase_vol_princeton_ave_DG", "perbase_vol_princeton_ave_ERC",
  "perbase_vol_princeton_ave_PHC", "perbase_vol_princeton_ave_PRC",
  "perbase_vol_princeton_ave_SUB")

nasa_df$Visit <- paste0(nasa_df$scanner, "_", nasa_df$Time)
phantom_df <- melt(nasa_df[nasa_df$group == "Phantom",], c("subject_1", "Visit"), regions)
names(phantom_df) <- c("Phantom", "Visit", "Region", "PercentBase")
phantom_df$PercentBase <- phantom_df$PercentBase*100
phantom_df$Visit <- ordered(phantom_df$Visit, c("CGN_t1", "CHR_t2", "HOB_t3", "CGN_t4"))
phantom_df$Region <- revalue(phantom_df$Region, c("perbase_vol_princeton_ave_CA1"="CA1",
  "perbase_vol_princeton_ave_CA23"="CA23", "perbase_vol_princeton_ave_DG"="DG",
  "perbase_vol_princeton_ave_ERC"="ERC", "perbase_vol_princeton_ave_PHC"="PHC",
  "perbase_vol_princeton_ave_PRC"="PRC", "perbase_vol_princeton_ave_SUB"="SUB"))

phantom_plot <- ggplot(phantom_df, aes(x=Visit, y=PercentBase, color=Phantom)) +
  theme_linedraw() + geom_line(aes(group=1)) + facet_grid(. ~ Region) +
  ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
