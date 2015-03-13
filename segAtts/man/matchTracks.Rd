\name{matchTracks}
\alias{matchTracks}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Match tracks
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
matchTracks(trcol, DRN = NULL, n = 1, m = dim(trcol)[[1]])
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{trcol}{
TrackCollection.
}
  \item{DRN}{
Digital road network created by \link{create_drn}.
}
  \item{n}{
Interval start, see Details.
}
  \item{m}{
Interval end, see Details. 
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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

