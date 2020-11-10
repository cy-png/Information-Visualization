library(tidyverse)
library(leaflet)
library(WDI)
library(reshape2)
library(knitr)
library(plyr)
rm(list=ls())
gc()

# import routes data
routes <- read.csv("~/Documents/Brandeis/Information Visualization/Assignment3/routes.dat", header=FALSE)
View(routes)

routes <- rename(routes, c("V1" = "Airline", "V2" = "Airline ID", "V3" = "Source airport", 
                           "V4" = "Source airport ID", "V5" = "Destination airport", "V7" = "Codeshare",
                           "V6" = "Destination airport ID", "V8" = "Stops", "V9" = "Equipment"))
routes <- routes[,c(4,6)]
View(routes)

# import airport data
airports <- read.csv("~/Documents/Brandeis/Information Visualization/Assignment3/airports.dat", header=FALSE)
View(airports)
airports <- rename(airports, c("V1" = "Airport ID", "V2" = "Name", "V3" = "City", "V4" = "Country", 
                           "V7" = "Latitude", "V8" = "Longitude"))
airports <- airports[, -c(5,6,9,10,11,12,13,14)]
View(airports)


# merge airport
merge_1 <- merge(airports, routes, by.x = "Airport ID", by.y = "Source airport ID")
View(merge_1)
merge_1 <- merge_1[,-c(1,2)]
View(merge_1)
merge_1 <- rename(merge_1, c("City" = "SourceCity", "Country" = "SourceCountry", "Latitude" = "SourceLatitude", 
                             "Longitude" = "SourceLongitude"))

merge_2 <- merge(merge_1, airports, by.x = "Destination airport ID", by.y = "Airport ID")
View(merge_2)
merge_2 <- merge_2[,-c(1,6)]
merge_2 <- rename(merge_2, c("City" = "DestinationCity", "Country" = "DestinationCountry", "Latitude" = "DestinationLatitude", 
                             "Longitude" = "DestinationLongitude"))
View(merge_2)
merge_2$Trip_ID <- order(merge_2[,1])
as.factor(merge_2$Trip_ID)

# select India Data
Russia_flight <- merge_2 %>% filter(merge_2$SourceCountry == "Russia")
Russia_flight <- Russia_flight %>% filter(Russia_flight$DestinationCountry == "Russia")
View(Russia_flight)

Russia_flight <- Russia_flight[,-c(2,3,4,6,7,8)]

# melt data in the same column
Russia_flight_1 <- melt(Russia_flight,id.vars=c("Trip_ID"),variable.name="Dest/Orig",value.name="City")
View(Russia_flight_1)

write.csv(Russia_flight_1, file="~/Documents/Brandeis/Information Visualization/Assignment3/Russia_flight_1.csv",quote=F,row.names = F)
