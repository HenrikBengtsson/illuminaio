\name{readBPM}
\alias{readBPM}
\alias{readBPM}

\title{Low-level function to read BPM files}

\description{
    Reads BPM files (array design information) from Illumina arrays.
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
  Robustification and code cleanup by Henrik Bengtsson.
}
\keyword{IO}
