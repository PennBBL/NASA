### This script finds the cognitive assessments that were done as close in time
### as possible to each of the neuroimaging sessions
###
### Ellyn Butler
### April 23, 2021



# Load data
demo_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/nasa_antartica_demographics.csv')
names(demo_df)[names(demo_df) == 'subject_1'] <- 'subject'
cog_df <- read.csv('~/Documents/nasa_antarctica/NASA/data/concordia_cognition_data_corrected.csv')
names(cog_df)[names(cog_df) == 'ID'] <- 'subject'
cog_df$subject <- tolower(cog_df$subject)

# Subset demographics to only include crew
demo_df <- demo_df[grep('concordia', demo_df$subject), ]
row.names(demo_df) <- 1:nrow(demo_df)

# Change to date class
demo_df$AcquisitionDate <- as.Date(demo_df$AcquisitionDate)
cog_df$CognitionDate <- as.Date(cog_df$Session_Start, '%m/%d/%y')

############################### Define functions ###############################

findClosestDate <- function(i) {
  subject <- demo_df[i, 'subject']
  acqdate <- demo_df[i, 'AcquisitionDate']
  cogdates <- cog_df[cog_df$subject == subject, 'CognitionDate']
  diffdates <- cogdates - acqdate
  mindiffdate <- cogdates[abs(diffdates) == min(abs(diffdates))]
  cog_df[cog_df$subject == subject & cog_df$CognitionDate == mindiffdate &
    !is.na(cog_df$CognitionDate), 'Battery']
}

################################################################################


demo_df$Battery <- sapply(1:nrow(demo_df), findClosestDate)

# Merge dataframes
acc_vars <- c('MP_Accuracy', 'PVT_Accuracy', 'VOLT_pCorr', 'NBCK_pCorr',
  'AM_pCorr', 'LOT_pCorr', 'ERT_pCorr', 'MRT_pCorr', 'DSST_pCorr')
rt_vars <- c('MP_AvRT', 'PVT_MeanRT', 'VOLT_AvRT', 'NBCK_AvRT', 'AM_AvRT',
  'LOT_AvRT', 'ERT_AvRT', 'MRT_AvRT', 'DSST_AvRT')

final_df <- merge(demo_df[, c('subject', 'Time', 'Battery')],
  cog_df[, c('subject', 'Battery', 'SU_SleepDur', 'SU_Lonely', acc_vars, rt_vars)],
  by=c('subject', 'Battery'))

# Scale accuracy and RT variables
final_df[, acc_vars] <- lapply(final_df[, acc_vars], scale)
final_df[, rt_vars] <- lapply(final_df[, rt_vars], scale)

# Calculate efficiency

# Calculate accuracy, RT and efficiency
final_df$Accuracy <- rowMeans(final_df[, acc_vars])
final_df$Accuracy <- scale(final_df$Accuracy)





#
