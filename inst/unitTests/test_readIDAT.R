test_readIDAT_minfiData <- function() {
    load(file.path(path.package("illuminaio"), "unitTests", "idat.450k.rda"))
    idatFile <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                            package = "IlluminaDataTestFiles")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.450k)
}

test_readIDAT_hapmap370k <- function() {
    load(file.path(path.package("illuminaio"), "unitTests", "idat.370k.rda"))
    idatFile <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                            package = "IlluminaDataTestFiles")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.370k)
}

test_readIDAT_4343238080 <- function() {
    idatFile <- system.file("extdata", "idat", "4343238080_A_Grn.idat", package = "IlluminaDataTestFiles")
    idatData <- readIDAT_enc(idatFile)$Data
    gStudio <- read.delim("http://compbio.sysbiol.cam.ac.uk/Resources/IDATreader/4343238080_A_ProbeSummary.txt", sep = "\t", header = TRUE)

    ## not all probes are present in GenomeStudio output, so only select those that are
    idatData <- idatData[which(idatData[,"CodesBinData"] %in% gStudio[,"ProbeID"]),]
    ## the orders are also different (numeric vs alphabetical)
    gStudio <- gStudio[match(idatData[,"CodesBinData"], gStudio[,"ProbeID"]),]

    ## check each value in GenomStudio output
    ## there are some rounding differences, so we allow slight differences
    
    ## summarised bead intensities
    checkEqualsNumeric(idatData[, "MeanBinData"], gStudio[, 3], tolerance = 10e-7)
    ## number of beads
    checkEquals(idatData[, "NumGoodBeadsBinData"], gStudio[, 5])
    ## standard errors 
    checkEqualsNumeric(idatData[, "DevBinData"] / sqrt(idatData[, "NumGoodBeadsBinData"]), gStudio[, 4], tolerance = 10e-7)
}
