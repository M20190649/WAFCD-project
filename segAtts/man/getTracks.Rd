\name{getTracks}
\alias{getTracks}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Gets enviroCar tracks
}
\description{
Load enviroCar tracks, ignoring the ones resulting in errors.
}
\usage{
getTracks(ids)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ids}{
Track ID`s.
}
}
\details{
Does not break if the import of a track fails, which happens sometimes.
}
\value{
A \link{TracksCollection}.
}

\author{
Nikolai Gorte
}

\keyword{getTracks}

