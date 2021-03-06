### This script creates csvs for subfields and plots them
###
### Ellyn Butler
### October 29, 2018

# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")

# --- lite version ---
#ERB: turn into for loop where you rbind
column_names <- c("winterover", "subject_1", "Time", "vol_princeton_L_CA1", "surf_princeton_L_CA1", "vol_princeton_L_CA23", "surf_princeton_L_CA23", "vol_princeton_L_DG", "surf_princeton_L_DG", "vol_princeton_L_ERC", "surf_princeton_L_ERC", "vol_princeton_L_PHC", "surf_princeton_L_PHC", "vol_princeton_L_PRC", "surf_princeton_L_PRC", "vol_princeton_L_SUB", "surf_princeton_L_SUB", "vol_princeton_R_CA1", "surf_princeton_R_CA1", "vol_princeton_R_CA23", "surf_princeton_R_CA23", "vol_princeton_R_DG", "surf_princeton_R_DG", "vol_princeton_R_ERC", "surf_princeton_R_ERC", "vol_princeton_R_PHC", "surf_princeton_R_PHC", "vol_princeton_R_PRC", "surf_princeton_R_PRC", "vol_princeton_R_SUB", "surf_princeton_R_SUB")

df = data.frame(matrix(nrow=145, ncol=31))
colnames(df) = column_names

# '/data/joy/BBL/studies/nasa_antartica/processedData/hippocampus/wo_2015/concordia_001/t0/subfield_values_jlfcllite.csv'
subjlist_jlfcllite=readLines("/home/ebutler/subjlists/nasa/nasa_hippo_jlfcllite.csv") 

i=0
for (line in subjlist_jlfcllite) {
	i=i+1
	string=strsplit(line, "/")
	winter=string[[1]][9]
	subject_1=string[[1]][10]
	Time=string[[1]][11]
	data <- read.csv(line, header=FALSE)

	## extracting only volume and surface area
	# Labels
	label_1 <- as.numeric(unlist(data[1,11:12]))
	label_2 <- as.numeric(unlist(data[1,20:21]))
	label_3 <- as.numeric(unlist(data[1,29:30]))
	label_4 <- as.numeric(unlist(data[1,38:39]))
	label_5 <- as.numeric(unlist(data[1,47:48]))
	label_6 <- as.numeric(unlist(data[1,56:57]))
	label_7 <- as.numeric(unlist(data[1,65:66]))
	label_101 <- as.numeric(unlist(data[1,74:75]))
	label_102 <- as.numeric(unlist(data[1,83:84]))
	label_103 <- as.numeric(unlist(data[1,92:93]))
	label_104 <- as.numeric(unlist(data[1,101:102]))
	label_105 <- as.numeric(unlist(data[1,110:111]))
	label_106 <- as.numeric(unlist(data[1,119:120]))
	label_107 <- as.numeric(unlist(data[1,128:129]))
	row <- c(winter, subject_1, Time, label_1, label_2, label_3, label_4, label_5, label_6, label_7, label_101, label_102, label_103, label_104, label_105, label_106, label_107)
	df[i,] <- row
}

# get columns 4:31 to be numeric
for (i in 4:31) {
	df[,i] <- as.numeric(df[,i])
}

# get columns 1:3 to be factors
for (i in 1:3) {
	df[,i] <- as.factor(df[,i])
}

write.csv(file="/home/ebutler/erb_data/nasa/nasa_hippo_jlfcllite.csv", df, row.names=FALSE)






















