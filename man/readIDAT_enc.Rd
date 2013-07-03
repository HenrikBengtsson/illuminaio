\name{readIDAT_enc}
\alias{readIDAT_enc}
\title{Read IDAT File}
\description{
    Reads the encrypted IDAT files generated when Illumina expression chips are scanned.
}
\usage{
    readIDAT_enc(file = NULL, verbose = FALSE)
}
\arguments{
    \item{file}{a character string giving the
        name of the file to read.}
    \item{verbose}{logical value specifying if progress text should be printed.
        Only really used for diagnostic purposes.}
}
\value{
    Returns a data.frame containing the information stored in the idat file - namely summary data for each bead type on the array.
}
\keyword{file}
