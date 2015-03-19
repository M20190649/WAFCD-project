## gets envirCar tracks for the specified area
## applies map matching
## extracts measurements for osm road segments
## calclutes weights for the segments
## visualise everything using R shiny
if(!require(devtools)) {install.packages('devtools'); require(devtools)}
if(!require(segAtts)) {devtools::install_github("ngort01/WAFCD-project/segAtts"); require(segAtts)}
if(!require(shiny)) {install.packages('shiny'); require(shiny)}
if(!require(leaflet)) {devtools::install_github("rstudio/leaflet"); require(segAtts)}
require(spacetime)
require(rgdal)


## bounding box
bbox <- matrix(c(7.318136,51.802163, 7.928939,52.105665), nrow=2, ncol=2)

## polygon of the bounding box
## used to filter for tracks that are completly inside the bounding box
x <- c(bbox[1,1], bbox[1,2], bbox[1,2], bbox[1,1])
y <- c(bbox[2,1], bbox[2,1], bbox[2,2], bbox[2,2])
coords <- cbind(x,y)
crs <- CRS("+proj=longlat +datum=WGS84 +no_defs")
area <- SpatialPolygons(list(Polygons(list(Polygon(coords)), 1)), proj4string = crs)


## load digital road network used in the map matching
load("data/muenster_drn.R")
## shapefile with all roads in the defined area
load("data/muenster_roads.R")


## time interval: from x till now
t1 <- Sys.time()-as.difftime(48, unit="hours")
t2 <- Sys.time()
## get all ids
ids <- getTrackIDs("https://envirocar.org/api/stable", bbox, list(first.time = t1, last.time = t2))
## import tracks
tracks <- getTracks(ids)


## filter Tracks
filteredTracks <- filterTracks(tracks, area)
  
## match tracks to segments
mm_tracks <- matchTracks(filteredTracks, muenster_drn)


## get segments ids and measured values
seg_values <- getValues(mm_tracks)

## append to csv
write.table(seg_values, file = "/data/seg_values.csv", sep = ";", row.names = FALSE, 
            append = TRUE, col.names=!file.exists("data/seg_values.csv"))

## load complete csv
seg_values <- read.csv("data/seg_values.csv", sep = ";")

## subset the shape to get only the needed roads
muenster_roads <- muenster_roads[muenster_roads$osm_id %in% unique(seg_values$OSM_ID),]

## unique ids of segments that have measurements
osm_ids <- muenster_roads$osm_id

## fields for the weights that will be calculated
muenster_roads$min_speed <- NA
muenster_roads$max_speed <- NA 
muenster_roads$mean_speed <- NA
muenster_roads$vc_speed <- NA
muenster_roads$min_time <- NA
muenster_roads$max_time <- NA
muenster_roads$mean_time <- NA

## calculate the weights
for(i in 1:length(osm_ids)) {
    sub <- seg_values[seg_values$OSM_ID == osm_ids[i],]
    muenster_roads$min_speed[i] <- min(as.numeric(sub$Speed), na.rm = TRUE)
    muenster_roads$max_speed[i] <- max(as.numeric(sub$Speed), na.rm = TRUE)
    muenster_roads$mean_speed[i] <- mean(as.numeric(sub$Speed), na.rm = TRUE)
    vc <- sd(as.numeric(sub$Speed), na.rm = TRUE) / mean(as.numeric(sub$Speed), na.rm = TRUE)
    muenster_roads$vc_speed[i] <- ifelse(is.na(vc), 0, vc)
    muenster_roads$max_time[i] <- (LinesLength(muenster_roads@lines[[i]], TRUE)*1000)/muenster_roads$min_speed[i] * 3.6
    muenster_roads$min_time[i] <- (LinesLength(muenster_roads@lines[[i]], TRUE)*1000)/muenster_roads$max_speed[i] * 3.6
    muenster_roads$mean_time[i] <- (LinesLength(muenster_roads@lines[[i]], TRUE)*1000)/muenster_roads$mean_speed[i] * 3.6
}

## run the shiny app
runApp()
