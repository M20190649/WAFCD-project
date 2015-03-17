\name{matchTracks}
\alias{matchTracks}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Match tracks
}
\description{
Match tracks to the road network and ignore the once producing errors.
}
\usage{
matchTracks(trcol, DRN = NULL, m = 1, n = dim(trcol)[[1]])
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{trcol}{
TrackCollection.
}
  \item{DRN}{
Digital road network created by \link{create_drn}.
}
  \item{m}{
Interval start, see Details.
}
  \item{n}{
Interval end, see Details. 
}
}

\value{
List with matched \link{Track} objects.
}

\author{
Nikolai Gorte
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{matchTracks}

