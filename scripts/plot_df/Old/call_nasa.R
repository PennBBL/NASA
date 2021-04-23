### Script for user to specify which nasa plots they want
###
### Ellyn Butler
### September 5, 2018

# while loop for measure types
type <- ""
type_vec <- c()
while (type != "exit") {
	type <- readline(prompt="Enter one of the following as strings at a time: cort, gmd, vol. Type 'exit' when you have entered all desired strings: ")
	if (type != "exit") {
		type_vec <- c(type_vec, type)
	}
}
	
# while loops for years
year <- ""
year_vec <- c()
while (year != "exit") {
	year <- as.character(readline(prompt="Enter one of the following as strings at a time: 2015, 2016, combined. Type 'exit' when you have entered all desired strings: "))
	if (year != "exit") {
		year_vec <- c(year_vec, year)
	}
}

# run nasa.R for each type
for (i in 1:length(type_vec)) {
	type <- type_vec[[i]]
	for (j in 1:length(year_vec)) {
		year <- year_vec[[j]]
		source("/home/ebutler/scripts/nasa/nasa.R")
	}
}



### Errors:
#1) Error in file(file, open = "w") : cannot open the connection... Calls: start -> locStart -> file

