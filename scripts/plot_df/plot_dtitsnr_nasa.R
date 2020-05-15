### This script creates three histograms of TSNR values for DTI
### 
### Ellyn Butler
### December 13, 2018


# Source my functions
source("/home/ebutler/scripts/ButlerPlotFuncs/plotFuncs.R")
library('gridExtra')


# Load my data
nasa_data <- read.csv("/home/ebutler/erb_data/nasa/nasa_dti_tsnr.csv", header=T)

# Put in scanner
nasa_data <- scanningSite_NASAAntartica(nasa_data)

p1 <- ggplot(nasa_data,aes(x=tsnr_b1000)) + 
    geom_histogram(data=subset(nasa_data, scanner == 'CGN'),fill = "red", alpha=.2) +
    xlim(3,6) +
    ggtitle("B1000 TSNR for Cologne Scans")

p2 <- ggplot(nasa_data,aes(x=tsnr_b1000)) + 
    geom_histogram(data=subset(nasa_data, scanner == 'CHR'),fill = "blue", alpha=.2) +
    xlim(3,6) +
    ggtitle("B1000 TSNR for Christchurch Scans")

p3 <- ggplot(nasa_data,aes(x=tsnr_b1000)) +
    geom_histogram(data=subset(nasa_data, scanner == 'HOB'),fill = "green", alpha=.2) +
    xlim(3,6) +
    ggtitle("B1000 TSNR for Hobart Scans")

pdf(file="/home/ebutler/nasa_plots/dtitsnr_nasa.pdf", width=12, height=8)
grid.arrange(p1, p2, p3, ncol=3)
dev.off()
