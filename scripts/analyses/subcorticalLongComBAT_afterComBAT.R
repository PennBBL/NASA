### This script produces just the "after combat" portion of the percent change
### from baseline plot, and changes the colors of the rogue people
###
### Ellyn Butler
### October 30, 2020

library('ggplot2')
library('dplyr')
library('reshape2')

all_data <- read.csv('~/Documents/nasa_antarctica/NASA/data/longCombatCrew.csv')

subcortical <- c("vol_miccai_ave_Accumbens_Area", "vol_miccai_ave_Amygdala",
  "vol_miccai_ave_Caudate", "vol_miccai_ave_Hippocampus", "vol_miccai_ave_Pallidum",
  "vol_miccai_ave_Putamen", "vol_miccai_ave_Thalamus_Proper")


#### Plot to see if site effects gone
for (region in grep("ol", names(all_data), value=TRUE)) {
  all_data[,paste0("perbase_", region)] <- NA
  for (sub in unique(all_data$subject)) {
    if ("t0" %in% all_data[all_data$subject == sub, "Time"]) {
      baseval <- all_data[all_data$subject == sub & all_data$Time == "t0", region]
      timepoints <- unique(all_data[all_data$subject == sub, "Time"])
      for (tp in timepoints) {
        all_data[all_data$subject == sub & all_data$Time == tp, paste0("perbase_", region)] <- all_data[all_data$subject == sub & all_data$Time == tp, region]/baseval
      }
    }
  }
}

crew_df <- reshape2::melt(all_data, c("subject", "Time", "scanner"),
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

crew_combat_plot <- ggplot(crew_combat_df, aes(x=Time, y=PercentBase, color=ScannerOrder,
      group=CrewMember)) + ylim(70, 130) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "red", "springgreen1",
      "springgreen3", "springgreen4")) +
    theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))

pdf(file="~/Documents/nasa_antarctica/NASA/plots/afterCombat.pdf", width=7, height=4.5)
crew_combat_plot
dev.off()
