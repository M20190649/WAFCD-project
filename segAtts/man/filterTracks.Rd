\name{filterTracks}
\alias{filterTracks}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Find tracks that are completely inside an area
}
\description{
Takes a \link[trajectories]{TracksCollection} and returns only the tracks that are completely insede
the defined area.
}
\usage{
filterTracks(trcol, area)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{trcol}{
\link[trajectories]{TracksCollection} object.
}
  \item{area}{
\link{SpatialPolygons} object.
}
}

\value{
A \link[trajectories]{TracksCollection}.
}

\author{
Nikolai Gorte
}

\keyword{filterTracks}

