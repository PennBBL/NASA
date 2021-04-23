### Script to plot NASA csf values
###
### Ellyn Butler
### September 6, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# Load the data
nasa_csf <- read.csv("/home/ebutler/data/nasa/nasa_csf.csv", header=T)
#OR
nasa_csf <- read.csv("/home/ebutler/data/nasa/nasa_csfVentricles.csv", header=T)

# Filter for only subjects who have all time points
exclude_vec <- c()
concordias <- as.character(nasa_csf$subject)
for (i in 1:nrow(nasa_csf)) {
	name = concordias[[i]]
	count = length(grep(name, concordias))
	if (count == 3) {
		exclude_vec <- c(exclude_vec, FALSE)
	} else {
		exclude_vec <- c(exclude_vec, TRUE)
	}
}
nasa_csf <- nasa_csf[!(exclude_vec), ]

# Create wo labels
wo2015_vec <- grep("concordia_0", nasa_csf[,"subject"])
nasa_csf$winterover <- NA
num_rows = nrow(nasa_csf)
for (i in 1:num_rows) {
	if (i %in% wo2015_vec) {
		nasa_csf[i, "winterover"] <- "wo_2015"
	} else {
		nasa_csf[i, "winterover"] <- "wo_2016"
	}
}

# Create a boxplot of CSF volume by time
nasa_csf$Time <- as.factor(nasa_csf$Time)
p <- ggplot(nasa_csf, aes(x=Time, y=total_csf, color=Time)) +
	geom_boxplot()
#OR
nasa_csf$Time <- as.factor(nasa_csf$Time)
p <- ggplot(nasa_csf, aes(x=Time, y=ventricles_csf, color=Time)) +
	geom_boxplot()

# Recreate the above boxplot, but separate by winter
p2 <- p #...
