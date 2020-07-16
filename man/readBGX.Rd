\name{readBGX}
\alias{readBGX}

\title{Low-level function to read BGX files}

\description{
    Reads BGX files (array design information) from Illumina expression arrays.
}

\usage{
readBGX(file)
}

\arguments{
  \item{file}{character string specifying BGX file to be read in}
}

\value{
  A list.
}

\details{
  Illumina provide probe annotation for expression arrays as either tab separated text files or as files with the extension \file{.bgx}.  BGX files are in fact just gzipped versions of the text files.  This function reads such files and returns a list with two entries, the first containing the target-probe information and the second containing details of the control probes.
}

\author{
  Mike Smith.  Based loosely on code developed by Mark Dunning available in \pkg{beadarray}~1.16.0.
}
\keyword{IO}
