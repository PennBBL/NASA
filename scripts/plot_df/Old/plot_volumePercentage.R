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
nasa_df <- nasa_df[-52,]
row.names(nasa_df) <- 1:nrow(nasa_df)
nasa_df <- nasa_df[,c("group", "subject_1", "Time", "scanner", "BasGang_Vol",
  "Limbic_Vol", "FrontOrb_Vol", "FrontDors_Vol", "Temporal_Vol", "Parietal_Vol",
  "Occipital_Vol", "vol_princeton_ave_CA1", "vol_princeton_ave_CA23",
  "vol_princeton_ave_DG", "vol_princeton_ave_ERC", "vol_princeton_ave_PHC",
  "vol_princeton_ave_PRC", "vol_princeton_ave_SUB")]

nasa_df <- nasa_df[!(nasa_df$subject_1 %in% c("concordia_010", "concordia_109",
  "concordia_106")),]
row.names(nasa_df) <- 1:nrow(nasa_df)

for (region in grep("ol", names(nasa_df), value=TRUE)) {
  nasa_df[,paste0("perbase_", region)] <- NA
  for (sub in unique(nasa_df$subject_1)) {
    baseval <- nasa_df[nasa_df$subject_1 == sub & nasa_df$Time %in% c("t1", "t0"), region]
    timepoints <- unique(nasa_df[nasa_df$subject_1 == sub, "Time"])
    for (tp in timepoints) {
      nasa_df[nasa_df$subject_1 == sub & nasa_df$Time == tp, paste0("perbase_", region)] <- nasa_df[nasa_df$subject_1 == sub & nasa_df$Time == tp, region]/baseval
    }
  }
}

hipporegions=grep("princeton", names(nasa_df), value=TRUE)
hipporegions=grep("perbase", hipporegions, value=TRUE)
lobularregions=grep("_Vol", names(nasa_df), value=TRUE)
lobularregions=grep("perbase", lobularregions, value=TRUE)

nasa_df$Visit <- paste0(nasa_df$scanner, "_", nasa_df$Time)



################################ Phantoms ################################

##### ------------ Hippocampus ------------ #####
phantom_hippo_df <- melt(nasa_df[nasa_df$group == "Phantom",], c("subject_1", "Visit"), hipporegions)
names(phantom_hippo_df) <- c("Phantom", "Visit", "Region", "PercentBase")
phantom_hippo_df$PercentBase <- phantom_hippo_df$PercentBase*100
phantom_hippo_df$Visit <- ordered(phantom_hippo_df$Visit, c("CGN_t1", "CGN_t4",
 "CHR_t2", "HOB_t3"))
phantom_hippo_df$Region <- revalue(phantom_hippo_df$Region,
  c("perbase_vol_princeton_ave_CA1"="CA1",
  "perbase_vol_princeton_ave_CA23"="CA23", "perbase_vol_princeton_ave_DG"="DG",
  "perbase_vol_princeton_ave_ERC"="ERC", "perbase_vol_princeton_ave_PHC"="PHC",
  "perbase_vol_princeton_ave_PRC"="PRC", "perbase_vol_princeton_ave_SUB"="SUB"))

phantom_hippo_plot <- ggplot(phantom_hippo_df, aes(x=Visit, y=PercentBase, color=Phantom, group=Phantom)) + ylim(0, 250) +
  theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
  theme(legend.position="bottom") +
  ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

##### ------------ Lobes ------------ #####
phantom_lobe_df <- melt(nasa_df[nasa_df$group == "Phantom",], c("subject_1", "Visit"), lobularregions)
names(phantom_lobe_df) <- c("Phantom", "Visit", "Region", "PercentBase")
phantom_lobe_df$PercentBase <- phantom_lobe_df$PercentBase*100
phantom_lobe_df$Visit <- ordered(phantom_lobe_df$Visit, c("CGN_t1", "CGN_t4",
  "CHR_t2", "HOB_t3"))
phantom_lobe_df$Region <- revalue(phantom_lobe_df$Region,
  c("perbase_BasGang_Vol"="BasGang", "perbase_Limbic_Vol"="Limbic",
  "perbase_FrontOrb_Vol"="FrontOrb", "perbase_FrontDors_Vol"="FrontDors",
  "perbase_Temporal_Vol"="Temporal", "perbase_Parietal_Vol"="Parietal",
  "perbase_Occipital_Vol"="Occipital"))

phantom_lobe_plot <- ggplot(phantom_lobe_df, aes(x=Visit, y=PercentBase, color=Phantom, group=Phantom)) + ylim(50, 150) +
  theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
  theme(legend.position="bottom") +
  ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1))


################################ Crew ################################

##### ------------ Hippocampus ------------ #####
crew_hippo_df <- melt(nasa_df[nasa_df$group == "Crew",], c("subject_1", "Time", "scanner"), hipporegions)
names(crew_hippo_df) <- c("CrewMember", "Time", "Scanner", "Region", "PercentBase")
crew_hippo_df$PercentBase <- crew_hippo_df$PercentBase*100
crew_hippo_df$Region <- revalue(crew_hippo_df$Region,
    c("perbase_vol_princeton_ave_CA1"="CA1",
    "perbase_vol_princeton_ave_CA23"="CA23", "perbase_vol_princeton_ave_DG"="DG",
    "perbase_vol_princeton_ave_ERC"="ERC", "perbase_vol_princeton_ave_PHC"="PHC",
    "perbase_vol_princeton_ave_PRC"="PRC", "perbase_vol_princeton_ave_SUB"="SUB"))

for (i in 1:nrow(crew_hippo_df)) {
  crewmem <- crew_hippo_df[i, "CrewMember"]
  scanners <- crew_hippo_df[crew_hippo_df$CrewMember == crewmem & crew_hippo_df$Region == "CA1", "Scanner"]
  scanstring <- paste(sapply(scanners, paste, collapse="-"), collapse="-")
  crew_hippo_df[i, "ScannerOrder"] <- scanstring
}

crew_hippo_plot <- ggplot(crew_hippo_df, aes(x=Time, y=PercentBase, color=ScannerOrder, group=CrewMember)) + ylim(0, 250) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "gray", "black")) +
    theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))

##### ------------ Lobes ------------ #####
crew_lobe_df <- melt(nasa_df[nasa_df$group == "Crew",], c("subject_1", "Time", "scanner"), lobularregions)
names(crew_lobe_df) <- c("CrewMember", "Time", "Scanner", "Region", "PercentBase")
crew_lobe_df$PercentBase <- crew_lobe_df$PercentBase*100
crew_lobe_df$Region <- revalue(crew_lobe_df$Region,
  c("perbase_BasGang_Vol"="BasGang", "perbase_Limbic_Vol"="Limbic",
  "perbase_FrontOrb_Vol"="FrontOrb", "perbase_FrontDors_Vol"="FrontDors",
  "perbase_Temporal_Vol"="Temporal", "perbase_Parietal_Vol"="Parietal",
  "perbase_Occipital_Vol"="Occipital"))

for (i in 1:nrow(crew_lobe_df)) {
  crewmem <- crew_lobe_df[i, "CrewMember"]
  scanners <- crew_lobe_df[crew_lobe_df$CrewMember == crewmem & crew_lobe_df$Region == "BasGang", "Scanner"]
  scanstring <- paste(sapply(scanners, paste, collapse="-"), collapse="-")
  crew_lobe_df[i, "ScannerOrder"] <- scanstring
}

crew_lobe_plot <- ggplot(crew_lobe_df, aes(x=Time, y=PercentBase, color=ScannerOrder, group=CrewMember)) + ylim(50, 150) +
    theme_linedraw() + geom_line() + facet_grid(. ~ Region) +
    ylab("% Baseline") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    scale_color_manual(values = c("blue", "blue", "red", "red", "gray", "black")) +
    theme(legend.position="bottom") +
    guides(color=guide_legend(title="Scanner Order"))


################################ Output ################################
pdf(file="~/Documents/nasa_antarctica/NASA/plots/percentBaseHippo.pdf", width=8, height=8)
grid.arrange(phantom_hippo_plot, crew_hippo_plot, nrow=2)
dev.off()

pdf(file="~/Documents/nasa_antarctica/NASA/plots/percentBaseLobe.pdf", width=8, height=8)
grid.arrange(phantom_lobe_plot, crew_lobe_plot, nrow=2)
dev.off()
