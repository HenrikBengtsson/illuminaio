## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## System tests for readBPM()
##
## Data is automatically downloaded from Illumina (e.g. [1]), if missing.
##
## NOTE: These tests will only run if '_R_CHECK_FULL_' is set, i.e.
## they won't run on Bioconductor or CRAN servers.
##
## REFERENCES:
## [1] http://support.illumina.com/downloads/infinium_bovineld_beadchip_product_files.ilmn
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## Utility functions
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
getIlluminaAnnotationFile <- function(chipType, filename, force=FALSE) {
  # Share data files across architectures, e.g. tests_i386 and tests_x64.
  rootPath <- "../annotationData,illuminaio,tests"
  path <- file.path(rootPath, "chipTypes", chipType)
  if (!file_test("-d", path)) dir.create(path, recursive=TRUE)
  pathname <- file.path(path, filename)

  # Already downloaded?
  if (!force && file_test("-f", pathname)) return(pathname)

  # Download from Illumina
  urlRoot <- "http://supportres.illumina.com/documents/downloads/productfiles"
  url <- file.path(urlRoot, chipType, filename)
  download.file(url, destfile=pathname, mode="wb")
  if (!file_test("-f", pathname)) stop("Failed to download file: ", url)

  pathname
} # getIlluminaAnnotationFile()


## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## Tests
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if (FALSE && Sys.getenv("_R_CHECK_FULL_") != "") {

test_readBPM_bovineld <- function() {
  pathname <- getIlluminaAnnotationFile("bovineld", "bovineld_c.bpm")

  data <- illuminaio::readBPM(pathname)
  str(data)
}

} # if (Sys.getenv("_R_CHECK_FULL_") != "")
