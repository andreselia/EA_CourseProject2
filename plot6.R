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
combustion_veh <- SCC %>% 
                        filter(grepl("Vehicles",SCC.Level.Two))
               
pm25_combveh <- NEI %>%
                        filter(SCC %in% combustion_veh$SCC & fips %in% c("24510", "06037")) %>%
                        group_by(fips, year) %>%
                        summarise(Emissions = sum(Emissions))


png(filename = "plot6.png")
ggplot(data = pm25_combveh, aes(factor(as.character(year)), Emissions)) + 
        labs(col = "City", labels = c("Los Angeles", "Baltimore")) +
        geom_line(aes(group = fips, col = fips)) +
        ggtitle(label = expression("Total PM"[2.5]*" emissions from Highway Vehicles in Baltimore City and Los Angeles")) +
        xlab("Year") 
dev.off()

