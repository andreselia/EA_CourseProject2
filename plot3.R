# url to file
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if (!file.exists("data.zip")) {
        download.file(url = url, destfile = "data.zip", method = "curl")
}
# read the files inside .zip
unzip("data.zip", list = TRUE)
NEI <- readRDS(unzip("data.zip", "summarySCC_PM25.rds")) 
SCC <- readRDS(unzip("data.zip", "Source_Classification_Code.rds"))  


names(NEI)
library(dplyr)
library(ggplot2)
baltimore <- NEI %>% filter(fips == "24510") %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))


png(filename = "plot3.png")
ggplot(data = baltimore, aes(x = year, y = Emissions, group = type, col = type)) + 
        geom_line() +
        ggtitle(label = expression("Total PM"[2.5]*" emissions by type"))
dev.off()

