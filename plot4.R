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
combustion_coal <- SCC %>% 
                        filter(grepl("Comb",SCC.Level.One) & grepl("Coal", SCC.Level.Three))
               
pm25_combcoal <- NEI %>%
                        filter(SCC %in% combustion_coal$SCC) %>%
                        group_by(year) %>%
                        summarise(Emissions = sum(Emissions))

png(filename = "plot4.png")
ggplot(data = pm25_combcoal, aes(factor(as.character(year)), Emissions)) + 
        geom_bar(stat = "identity") +
        ggtitle(label = expression("Total PM"[2.5]*" emissions from coal combustion")) +
        xlab("Year")
dev.off()

