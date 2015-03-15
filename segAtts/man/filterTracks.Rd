\name{filterTracks}
\alias{filterTracks}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Find tracks that are completely inside an area
}
\description{
Takes a \link{TracksCollection} and returns only the tracks that are completely insede
the defined area.
}
\usage{
filterTracks(trcol, area)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{trcol}{
\link{TracksCollection} object.
}
  \item{area}{
\link{SpatialPolygon} object.
}
}

\value{
A \link{TracksCollection}.
}

\author{
Nikolai Gorte
}

\keyword{filterTracks}

