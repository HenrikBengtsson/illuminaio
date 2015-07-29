library(illuminaio)
library(IlluminaDataTestFiles)

idatFile <- system.file("extdata", "idat", "4343238080_A_Grn.idat", package = "IlluminaDataTestFiles")
idatData <- readIDAT(idatFile)$Quants
gsFile <- system.file("extdata", "gs", "4343238080_A_ProbeSummary.txt.gz", package = "IlluminaDataTestFiles")
gStudio <- read.delim(gzfile(gsFile, open = "r"), sep = "\t", header = TRUE)

## not all probes are present in GenomeStudio output, so only select those that are
idatData <- idatData[which(idatData[,"CodesBinData"] %in% gStudio[,"ProbeID"]),]
## the orders are also different (numeric vs alphabetical)
gStudio <- gStudio[match(idatData[,"CodesBinData"], gStudio[,"ProbeID"]),]
# check each value in GenomeStudio output
## there are some rounding differences, so we allow slight differences

## summarised bead intensities
RUnit::checkEqualsNumeric(idatData[, "MeanBinData"], gStudio[, 3], tolerance = 10e-7)
## number of beads
RUnit::checkEquals(idatData[, "NumGoodBeadsBinData"], gStudio[, 5])
## standard errors
RUnit::checkEqualsNumeric(idatData[, "DevBinData"] / sqrt(idatData[, "NumGoodBeadsBinData"]), gStudio[, 4], tolerance = 10e-7)
