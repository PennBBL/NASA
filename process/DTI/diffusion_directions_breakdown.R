### Script that breaks down the diffusion direction problem
###
### Ellyn Butler
### November 14, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")


data <- read.csv('/home/ebutler/erb_data/nasa/nasa_B0Other.csv', header=TRUE) # should be 144 because concordia_104 t12 doesn't have diffusion

# Crew: Number of directions match t0, t12 and t18
crew_data <- data[data$winterover != "phantoms", ]

crew_vec <- grep("concordia", crew_data[,"subject_1"])
crew_data$CrewStatus <- NA
num_rows = nrow(crew_data)
for (i in 1:num_rows) {
	if (i %in% crew_vec) {
		crew_data[i, "CrewStatus"] <- "Crew"
	} else {
		crew_data[i, "CrewStatus"] <- "Control"
	}
}

crew_data <- crew_data[crew_data$CrewStatus == "Crew", ]

crew_30dir_data <- crew_data[crew_data$num_BOther == "30", ]

crew_30dir_alltime_data <- filterAllTimepoints(crew_30dir_data, "subject_1", "Time", 3)

