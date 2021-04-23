### This script creates a plot of the raw change values for crew members 
### (with the full sample, and a sample with just the people who have the relevant time points)
###
### Ellyn Butler
### June 26, 2019

source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
library('dplyr')
library('gridExtra')

# Read in the data
nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_strucRestDTI_KoshaTaki.csv")

crew_df <- nasa_data[nasa_data$group == "Crew", c("subject_1", "Time", "vol_princeton_ave_CA1", "vol_princeton_ave_CA23", "vol_princeton_ave_DG", "vol_princeton_ave_ERC", "vol_princeton_ave_PHC", "vol_princeton_ave_PRC", "vol_princeton_ave_SUB", "vol_princeton_ave_hippo")]
rownames(crew_df) <- 1:nrow(crew_df)

# Create the summary dataframe
ROIlist <- c("vol_princeton_ave_CA1", "vol_princeton_ave_CA23", "vol_princeton_ave_DG", "vol_princeton_ave_ERC", "vol_princeton_ave_PHC", "vol_princeton_ave_PRC", "vol_princeton_ave_SUB", "vol_princeton_ave_hippo")
pattern1 <- "vol_princeton_ave_"
pattern2 <- ""
plot.title <- "Raw Hippocampal Volumes"
crew_df$Time <- factor(crew_df$Time)
summaryDF_crew <- createSummaryDF(crew_df, c("Time"), list(), pattern1=pattern1, pattern2=pattern2, ROIlist=ROIlist) 
tmp <- summaryDF_crew

# Make t0 the zero line
beg <- nrow(summaryDF_crew)/3 + 1
j <- 1
for (i in beg:nrow(summaryDF_crew)) {
	print(paste(summaryDF_crew[i, "ROI_name"], summaryDF_crew[i, "Time"], summaryDF_crew[j, "ROI_name"], summaryDF_crew[j, "Time"]))
	summaryDF_crew[i, "ROI_mean"] <- summaryDF_crew[i, "ROI_mean"] - summaryDF_crew[j, "ROI_mean"]
	if (j < beg-1) { j <- j+1
	} else { j <- 1 }
}
for (i in 1:(beg-1)) { summaryDF_crew[i, "ROI_mean"] <- 0 }

# Rename time points 
summaryDF_crew$Time[summaryDF_crew$Time == "t0"] <- "P-P" ###
summaryDF_crew$Time[summaryDF_crew$Time == "t12"] <- "R-P"
summaryDF_crew$Time[summaryDF_crew$Time == "t18"] <- "F-P"	
	
summaryDF_crew$Time <- factor(summaryDF_crew$Time)
summaryDF_crew$Time <- factor(summaryDF_crew$Time,levels(summaryDF_crew$Time)[c(2, 3, 1)])
crew_title <- paste0("Crew - ", plot.title)

linetype_vec <- c("solid", "solid")
color_vec_RP <- c("black", "red")
color_vec_FP <- c("black", "blue")
factor <- "Time"
increment <- 50
ylabel <- "Volume from Baseline (95% CI)"

# Define functions
roundTo <- function(x, multiple, FUN) { 
	if (FUN == "ceiling") {	ceiling(x/multiple)*multiple 
	} else if (FUN == "floor") { floor(x/multiple)*multiple 
	}
}

### Decide on upper and lower bounds
lower_order <- 0
upper_order <- 0

for (i in 1:nrow(summaryDF_crew)) {
	current_low <- roundTo(summaryDF_crew[i, "ROI_mean"] - 2*summaryDF_crew[i, "ROI_se"], 20, "floor")
	current_high <- roundTo(summaryDF_crew[i, "ROI_mean"] + 2*summaryDF_crew[i, "ROI_se"], 20, "ceiling")
	if (current_low < lower_order) { lower_order <- current_low }
	if (current_high > upper_order) { upper_order <- current_high }
}
if (abs(lower_order) > abs(upper_order)) { upper_order <- abs(lower_order)
} else { lower_order <- -abs(upper_order) }

# Relabel time points
summaryDF_crew$Time[summaryDF_crew$Time == "t0"] <- "P-P" ###
summaryDF_crew$Time[summaryDF_crew$Time == "t12"] <- "R-P"
summaryDF_crew$Time[summaryDF_crew$Time == "t18"] <- "F-P"	
	
summaryDF_crew$Time <- factor(summaryDF_crew$Time)
summaryDF_crew$Time <- factor(summaryDF_crew$Time,levels(summaryDF_crew$Time)[c(2, 3, 1)])

RP_df <- summaryDF_crew[summaryDF_crew$Time != "F-P",]
RP_df$Time <- factor(RP_df$Time)
RP_plot <- ggplot(RP_df, aes_string(y="ROI_mean", x="ROI_name", group=factor, color=factor)) + 
	geom_bar(stat="identity", fill="white") +
	scale_y_continuous(limits=c(lower_order, upper_order), breaks=round(seq(lower_order,upper_order,increment), digits=2)) +
	ylab(ylabel) +
	geom_hline(aes(yintercept=0), linetype="longdash", colour="black", size=0.5) +
	scale_colour_manual(name = factor, values = color_vec_RP) +
	scale_linetype_manual(name = factor, values = linetype_vec) +
	theme_bw() +
	theme(legend.position="top") +
	ggtitle(crew_title) + geom_errorbar(aes(ymin=ROI_mean-2*ROI_se, ymax=ROI_mean+2*ROI_se), width=.5, position=position_dodge(width = 0.2), size=2) + 
	xlab("Brain Regions") + theme(text=element_text(size=25), axis.text.x = element_text(angle = 45, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=18), axis.title.x = element_text(face="bold", size=25),
	axis.title.y = element_text(face="bold", size=25),
	plot.title = element_text(face="bold", size=25), strip.text.x = element_text(size=12))


FP_df <- summaryDF_crew[summaryDF_crew$Time != "R-P",]
FP_df$Time <- factor(FP_df$Time)
FP_plot <- ggplot(FP_df, aes_string(y="ROI_mean", x="ROI_name", group=factor, color=factor)) + 
	geom_bar(stat="identity", fill="white") +
	scale_y_continuous(limits=c(lower_order, upper_order), breaks=round(seq(lower_order,upper_order,increment), digits=2)) +
	ylab(ylabel) +
	geom_hline(aes(yintercept=0), linetype="longdash", colour="black", size=0.5) +
	scale_colour_manual(name = factor, values = color_vec_FP) +
	scale_linetype_manual(name = factor, values = linetype_vec) +
	theme_bw() +
	theme(legend.position="top") +
	ggtitle(crew_title) + geom_errorbar(aes(ymin=ROI_mean-2*ROI_se, ymax=ROI_mean+2*ROI_se), width=.5, position=position_dodge(width = 0.2), size=2) + 
	xlab("Brain Regions") + theme(text=element_text(size=25), axis.text.x = element_text(angle = 45, hjust = 1, face="bold"), axis.text.y = element_text(face="bold", size=18), axis.title.x = element_text(face="bold", size=25),
	axis.title.y = element_text(face="bold", size=25),
	plot.title = element_text(face="bold", size=25), strip.text.x = element_text(size=12))



pdf(file = "/home/ebutler/plots/nasa_antartica/raw_hippoChange.pdf", width=8, height=12)
grid.arrange(RP_plot)
grid.arrange(FP_plot)
dev.off()

