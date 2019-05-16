### This script generates a csv that explains the mapping from our original subject naming 
### system to the names required by fMRIPrep
###
### Ellyn Butler
### April 10, 2019

demo <- read.csv("/home/ebutler/erb_data/nasa/nasa_antartica_demographics.csv")

df <- as.data.frame(matrix(0, nrow=146, ncol=4))

colnames(df) <- c("subject_1", "Time", "sub_id", "ses_id")

df$subject_1 <- demo$subject_1
df$Time <- demo$Time

for (i in 1:nrow(df)) {
	### Put in "sub_id"
	subj <- strsplit(as.character(df[[i, "subject_1"]]), split="_")[[1]]
	group <- subj[1]
	if (length(subj) > 1) {
		num <- subj[2]
	}
	# concordias 1, DLRs 2, phantoms 3
	if (group == "concordia") { subid <- paste0("sub-", "1", num) 
	} else if (group == "DLR") { subid <- paste0("sub-", "2", num) 
	} else {
		if (group == "BJ") { subid <- "sub-3001"
		} else if (group == "BM") { subid <- "sub-3002"
		} else if (group == "EA") { subid <- "sub-3003"
		} else if (group == "GR") { subid <- "sub-3004"
		} else if (group == "PK") { subid <- "sub-3005"
		}
	}
	df[i, "sub_id"] <- subid
	
	### Put in "ses_id"
	if (as.character(df[i, "Time"]) == "t0") { df[i, "ses_id"] <- "ses-1"
	} else if (as.character(df[i, "Time"]) == "t12") { df[i, "ses_id"] <- "ses-2"
	} else if (as.character(df[i, "Time"]) == "t18") { df[i, "ses_id"] <- "ses-3"
	} else if (as.character(df[i, "Time"]) == "t1") { df[i, "ses_id"] <- "ses-1"
	} else if (as.character(df[i, "Time"]) == "t2") { df[i, "ses_id"] <- "ses-2"
	} else if (as.character(df[i, "Time"]) == "t3") { df[i, "ses_id"] <- "ses-3"
	} else if (as.character(df[i, "Time"]) == "t4") { df[i, "ses_id"] <- "ses-4"
	}
}

df$sub_id <- factor(df$sub_id)
df$ses_id <- factor(df$ses_id)

write.csv(df, file="/home/ebutler/erb_data/nasa/nasa_origTofMRIPrep_key.csv", row.names=FALSE)

	
