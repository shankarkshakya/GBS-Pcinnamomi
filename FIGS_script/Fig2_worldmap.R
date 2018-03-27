rm(list =ls())
library(rworldmap)

theCountries <- c("USA", "DOM", 
                  "CHL",
                  "DZA", "TUN", "ZAF",
                  "AUT",  "FRA", "HUN", "ITA", "PRT", "ESP","GBR",
                  "AUS", "VNM", "TWN")

malDF <- data.frame(country = theCountries,
                    Sites = rep(1, length(theCountries)))


malMap <- joinCountryData2Map(malDF, joinCode = "ISO3",
                              nameJoinColumn = "country")

malMap <- subset(malMap, malMap@data$NAME != "Antarctica")

#tiff("./FIGS/worldmap.tiff", width = 11.5, height = 7, units = "in", res = 600)

mapCountryData(malMap, nameColumnToPlot = "country", missingCountryCol = "gray", 
               catMethod = "categorical",
              colourPalette = rep("#89080e", 16), xlim = c(0,37), addLegend = F,
               #colourPalette = pals::alphabet(n =16), xlim = c(0,37), addLegend = F,
              mapTitle = NA)

#dev.off()









