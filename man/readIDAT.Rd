\name{readIDAT}
\alias{readIDAT}

\title{Low-level function to read IDAT files}

\description{ Reads intensity information for each bead type from a
  single IDAT file for Infinium II, Infinium HD and expression platforms.
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
  encryption to store data and is the format usually produced by Illumina
  expression arrays.  The other version is unencrypted files and
  is found in data from SNP arrays and DNA methylation arrays.

  This function is able to handle data in either format, scanning the
  file header and calling the appropriate reading routine internally.

  The function supports reading gzipped, unencrypted IDATs.
}

\value{
  The exact data returned will vary depending upon whether the input
  file was encrypted or not.  In either case, everything that can be
  extract from the file will be returned in the form of a list.
    
  For both file types the most important entry in the returned list is the
  item \code{Quants}.  When reading unencrypted files this contains average intensity (\code{Mean}),
  number of beads (\code{NBeads}) and a measure of variability
  (\code{SD}) for each bead type on the array.  For expression arrays
  in addition to these some additional information is available,
  including median and trimmed-mean estimates of average intensity,
  averaged local background intensities and the number of beads present
  before outliers where excluded.

  For both file types details of scanning and decoding dates are
  included in the \code{RunInfo} slot.
}

\references{
  Ritchie ME, Carvalho BS, Hetrick KN, Tavar\'{e} S, Irizarry RA.
  R/Bioconductor software for Illumina's Infinium whole-genome
  genotyping BeadChips. Bioinformatics. 2009 Oct 1;25(19):2621-3.
}

\author{Unencrypted: Keith Baggerly, with modifications by Matt Ritchie, Henrik
  Bengtsson and Kasper Daniel Hansen.
Encrypted: Mike Smith}

\examples{
if(require(IlluminaDataTestFiles)) {
  idatFile <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                          package = "IlluminaDataTestFiles")
  idat <- readIDAT(idatFile)
  names(idat)
  idat$Quants[1:5,]
}
}
\keyword{IO}
