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
sum_year_baltimore <- with(NEI[NEI$fips == "24510", ], tapply(Emissions, year, sum))
totalpm25_baltimore <- data.frame(year = names(sum_year), pm25 = sum_year)

png(filename = "plot2.png")
with(totalpm25_baltimore, 
     barplot(height = pm25, names.arg = year, 
             xlab = "YEAR", 
             ylab = expression("Total PM"[2.5]*" emission"), 
             main = "Emissions in Baltimore City",
             col = year))
dev.off()

