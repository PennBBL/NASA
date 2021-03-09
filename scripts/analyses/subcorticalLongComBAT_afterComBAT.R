### This script produces just the "after combat" portion of the percent change
### from baseline plot, and changes the colors of the rogue people
###
### Ellyn Butler
### October 30, 2020
### March 8, 2021: new combatted data

library('ggplot2')
library('dplyr')
library('reshape2')
library('cowplot')

all_data <- read.csv('~/Documents/nasa_antarctica/NASA/data/longCombatCrew_2021-03-08.csv')

subcortical <- c("vol_miccai_ave_Accumbens_Area", "vol_miccai_ave_Amygdala",
  "vol_miccai_ave_Caudate", "vol_miccai_ave_Hippocampus", "vol_miccai_ave_Pallidum",
  "vol_miccai_ave_Putamen", "vol_miccai_ave_Thalamus_Proper")
cortical <- grep("_Vol", names(all_data), value=TRUE)[!(grep("_Vol",
  names(all_data), value=TRUE) %in% c("BasGang_Vol", "Limbic_Vol",
  grep("combat", names(all_data), value=TRUE)))]

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
  c(paste0("perbase_combat_", c(subcortical, cortical)),
  paste0("perbase_", c(subcortical, cortical))))
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
    "perbase_combat_vol_miccai_ave_Thalamus_Proper"="Thalamus",
    "perbase_combat_Frontal_Vol"="Frontal",
    "perbase_combat_Temporal_Vol"="Temporal",
    "perbase_combat_Parietal_Vol"="Parietal",
    "perbase_combat_Occipital_Vol"="Occipital")

subcort_short <- c("Accumbens", "Amygdala", "Caudate", "Hippocampus", "Pallidum",
  "Putamen", "Thalamus")
cort_short <- c("Frontal", "Parietal", "Occipital", "Temporal")
subcort_combat_plot <- ggplot(crew_combat_df[crew_combat_df$Region %in% subcort_short, ],
      aes(x=Time, y=PercentBase, color=ScannerOrder, group=CrewMember)) + ylim(70, 130) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "red", "springgreen1",
      "springgreen3", "springgreen4")) + ggtitle('Subcortical') +
    theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))

cort_combat_plot <- ggplot(crew_combat_df[crew_combat_df$Region %in% cort_short, ],
      aes(x=Time, y=PercentBase, color=ScannerOrder, group=CrewMember)) + ylim(70, 130) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "red", "springgreen1",
      "springgreen3", "springgreen4")) + ggtitle('Cortical') +
    theme(legend.position="none") +
    guides(color=guide_legend(title="Scanner Order"))

plot_legend <- get_legend(subcort_combat_plot)
subcort_combat_plot <- subcort_combat_plot + theme(legend.position="none")

combat_plot <- cowplot::plot_grid(
  cowplot::plot_grid(subcort_combat_plot, cort_combat_plot, labels=c('A', 'B'), nrow=2),
  plot_legend, rel_heights=c(6, 1), nrow=2, ncol=1)

pdf(file="~/Documents/nasa_antarctica/NASA/plots/afterCombat.pdf", width=7, height=8)
combat_plot
dev.off()
