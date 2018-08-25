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
 

sort(theCountries)
mycol <- pals::alphabet(n =16)
mycol <- c("#FFFF00","#ff0000" , "#FFC0CB", "#00FFFF","#0000FF",
           rep("#ff0000", 6), "#0000FF", "#00ff00",  "#00FFFF", "#FF00FF", "#0000FF")

mapCountryData(malMap, nameColumnToPlot = "country", missingCountryCol = "gray", 
               catMethod = "categorical",
              colourPalette = mycol, xlim = c(0,37), addLegend = F,
              mapTitle = NA)

#dev.off()

# Europe = "#ff0000", 
# taiwan =   "#00ff00",
#   australia = "#FFFF00",
#   africa = "#0000FF",
#   north america = "#00FFFF",
#   vietnam= "#FF00FF",
#   south america = "#FFC0CB"


