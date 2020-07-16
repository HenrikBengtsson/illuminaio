\name{readIDAT}
\alias{readIDAT}

\title{Low-level function to read IDAT files}

\description{ Reads intensity information for each bead type from a
  single IDAT file for Infinium II, Infinium HD and expression platforms.
}

\usage{
readIDAT(file, what = c("all", "IlluminaID", "nSNPsRead"))
}

\arguments{
  \item{file}{character string specifying IDAT file to be read in.}
  \item{what}{This allows the return of parts of the IDAT file, see
  Value. This argument is only supported for non-encrypted IDAT files;
  setting it to be different from default on an encrypted file throws an
  error.}
}

\details{
  This function returns a list containing summarized intensities and other
  information extracted from a single IDAT file.

  Thanks to Keith Baggerly for providing the first version of this code.

  There are two commonly encountered versions of IDAT.  One version uses
  encryption to store data and is the format usually produced by Illumina
  expression arrays.  The other version is unencrypted files and
  is found in data from SNP arrays and DNA methylation arrays.

  This function is able to handle data in either format, scanning the
  file header and calling the appropriate reading routine internally.

  The function supports reading gzipped, unencrypted IDAT files.

  The use of the \code{what} argument is for package writers.
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
  
  A further list entry, \code{Extra}, may also be present.  Occasionally an field
  in the IDAT file will have a number of data points inconsistent with the remainder
  of the file and as such is not returned in the \code{Quants} entry.  Such
  fields will be placed here.  So far only the HumanHap550 v1 BeadChip has exhibited 
  this property.

  In case \code{what} is set to \code{nSNPsRead} the function returns an
  integer equal to this field.  In case \code{what} is set to
  \code{IlluminaID} the function returns a character vector containing
  the IDs.
}

\references{
  Ritchie ME, Carvalho BS, Hetrick KN, Tavar\'e S, Irizarry RA.
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
