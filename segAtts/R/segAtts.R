## basically what importEnvirocar does but doesnt break because some of the tracks can't be loaded 
getTracks <- function(ids) {
  tracks <- list()
  for(id in ids) {
    try(tracks <- c(tracks, importSingleTrack("https://envirocar.org/api/stable", id)))
  }  
  TracksCollection(tracks)
}



## takes a TracksCollection as acquired from getTracks and a SpatialPolygon and returns 
## a TracksCollection conataining only tracks that are completely inside the area
filterTracks <- function(trcol, area) {
  filtered_tracks <- list()
  for (i in 1:dim(trcol)[[1]]) {
    if (gWithin(trcol[i][1]@sp, area)) filtered_tracks <- c(filtered_tracks, trcol[i])
  }
  TracksCollection(filtered_tracks)
}


## match tracks to segments, ignore tracks that cant be mached
## returns list of Track objects
## match tracks to segments
matchTracks <- function(trcol, DRN = NULL, n = 1, m = dim(trcol)[[1]]) {
  mm_tracks <- list()
  for (i in 1:n) {
    try(mm_tracks <- c(mm_tracks, mm(trcol[i][1], FALSE, DRN)))
  }
  mm_tracks
}
