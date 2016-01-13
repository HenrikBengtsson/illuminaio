\name{readBPM}
\alias{readBPM}
\alias{readBPM}

\title{Low-level function to read BPM files}

\description{
  Reads BPM files (array design information) from Illumina arrays.

  \emph{WARNING: This function is deprecated since illuminaio 0.1.4
  (January 2016), because its parser is invalid/incorrect. (Issue #6)}
}

\usage{
readBPM(file)
}

\arguments{
  \item{file}{character string specifying BPM file to be read in}
}

\value{
  A list.
}

\author{
  Originally created by Keith Baggerly in 2008.
  Later included in the \pkg{crlmm} package.
}
\keyword{IO}
\keyword{internal}
