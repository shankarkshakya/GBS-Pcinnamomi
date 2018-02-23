rm(list =ls())
library(rworldmap)

theCountries <- c("USA", "DOM", 
                  "CHL",
                  "DZA", "TUN", "ZAF",
                  "AUT",  "FRA", "HUN", "ITA", "PRT", "ESP","GBR",
                  "AUS", "VNM", "TWN")
# These are the ISO3 names of the countries you'd like to plot in red

malDF <- data.frame(country = theCountries,
                    Sites = rep(1, length(theCountries)))
# malDF is a data.frame with the ISO3 country names plus a variable to
# merge to the map data

malMap <- joinCountryData2Map(malDF, joinCode = "ISO3",
                              nameJoinColumn = "country")
# This will join your malDF data.frame to the country map data

malMap <- subset(malMap, malMap@data$NAME != "Antarctica")

#tiff("./FIGS/worldmap.tiff", width = 11.5, height = 7, units = "in", res = 600)

# mypallete <- c("#191919", "#C20088", "#C20088", "#191919") 
# 
# balck :#191919",
#   
#  pink: #C20088
#   
#   #0075DC", "", "#FF0010","#FFA8BB", 
#   
#   "#4C005C", "#005C31", "#2BCE48", "#FFCC99", "#808080", "#94FFB5")

mapCountryData(malMap, nameColumnToPlot = "country", missingCountryCol = "gray", 
               catMethod = "categorical",
                #colourPalette = "diverging" , 
               colourPalette = rep("black", 16),
               xlim = c(0,37), addLegend = F,
               #colourPalette = pals::alphabet(n =16), xlim = c(0,37), addLegend = F,
              mapTitle = NA)



dev.off()









