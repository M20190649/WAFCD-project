\name{getValues}
\alias{getValues}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get measured values for street segments
}
\description{
Extracts the OSM ID of all street segments in a map matched track and the 
corresponding attributes.
}
\usage{
getValues(mm_tracks, atts = c("OSM_ID", "time", "Speed", "GPS.Bearing"))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mm_tracks}{
List of \link{Track} objects.
}
  \item{atts}{
Vector of attribute names.
}
}

\value{
Dataframe with OSM ID's of the street segments and the measured values.
}

\author{
Nikolai Gorte.
}
\keyword{getValues}

