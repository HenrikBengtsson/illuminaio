\name{readIDAT}
\alias{readIDAT}
\alias{readIDAT}

\title{Low-level function to read IDAT files}

\description{ Reads intensity information for each bead type from a
              single IDAT file for Infinium II or Infinium HD platforms.
}

\usage{
readIDAT(file)
}

\arguments{
  \item{file}{character string specifying idat file to be read in.}
}

\details{
  
  This function returns a list containing summarised intensities and other
  information extracted from a single .idat file.

  Thanks to Keith Baggerly for providing the first version of this code.

  There are two commonly encounted versions of IDAT.  One version uses
  encryption to store data, and this function does not read encrypted
  IDAT files.  This is the formated usually produced by Illumina
  expression arrays.  The other version is unencrypted files, which this
  function reads.  This includes data from SNP arrays and DNA methylation
  arrays.

  Search the Bioconductor archives for hints on how to read encrypted
  IDATs.  We are considering merging that code into this package.
}

\value{
  A list which includes item \code{Quants} which contains average
  intensity (\code{Mean}), number of beads (\code{NBeads}) and a measure
  of variability (\code{SD}) for each bead type on the array.
}

\references{
  Ritchie ME, Carvalho BS, Hetrick KN, Tavar\'{e} S, Irizarry RA.
  R/Bioconductor software for Illumina's Infinium whole-genome
  genotyping BeadChips. Bioinformatics. 2009 Oct 1;25(19):2621-3.
}

\author{Keith Baggerly, with modifications by Matt Ritchie, Henrik
  Bengtsson and Kasper Daniel Hansen}

\examples{
if(require(minfiData)) {
  idatDir <- system.file("extdata", "5723646052",  package = "minfiData")
  idatFile <- file.path(idatDir, "5723646052_R02C02_Grn.idat")
  idat <- readIDAT(idatFile)
  names(idat)
  idat$Quants[1:5,]
}
}
\keyword{IO}
