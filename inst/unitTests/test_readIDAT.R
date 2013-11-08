test_readIDAT_450k <- function() {
    library(IlluminaDataTestFiles)
    load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.450k.rda"))
    idatFile <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                            package = "IlluminaDataTestFiles")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.450k)
}

test_readIDAT_370k <- function() {
    library(IlluminaDataTestFiles)
    load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.370k.rda"))
    idatFile <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                            package = "IlluminaDataTestFiles")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.370k)
}

test_readIDAT_450kgz <- function() {
    library(IlluminaDataTestFiles)
    idatFile1 <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                             package = "IlluminaDataTestFiles")
    idat1 <- illuminaio::readIDAT(idatFile1)
    idatFile2 <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat.gz",
                             package = "IlluminaDataTestFiles")
    idat2 <- illuminaio::readIDAT(idatFile2)
    idat2$fileSize <- idat1$fileSize <- NULL
    checkEquals(idat1, idat2)
}

test_readIDAT_370kgz <- function() {
    library(IlluminaDataTestFiles)
    idatFile1 <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                             package = "IlluminaDataTestFiles")
    idat1 <- illuminaio::readIDAT(idatFile1)
    idatFile2 <- system.file("extdata", "idat", "4019585376_B_Red.idat.gz",
                             package = "IlluminaDataTestFiles")
    idat2 <- illuminaio::readIDAT(idatFile2)
    idat2$fileSize <- idat1$fileSize <- NULL
    checkEquals(idat1, idat2)
}

test_readIDAT_wg6v2 <- function() {
    library(IlluminaDataTestFiles)
    load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.wg6v2.rda"))
    idatFile <- system.file("extdata", "idat", "4343238080_A_Grn.idat", 
                            package = "IlluminaDataTestFiles")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.wg6v2)
}

test_readIDAT_ht12v4 <- function() {
    library(IlluminaDataTestFiles)
    load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.ht12v4.rda"))
    idatFile <- system.file("extdata", "idat", "6016741005_A_Grn.idat", 
                            package = "IlluminaDataTestFiles")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.ht12v4)
}

test_readIDAT_gs_wg6v2<- function() {
    library(IlluminaDataTestFiles)
    idatFile <- system.file("extdata", "idat", "4343238080_A_Grn.idat", package = "IlluminaDataTestFiles")
    idatData <- readIDAT(idatFile)$Quants
    gsFile <- system.file("extdata", "gs", "4343238080_A_ProbeSummary.txt.gz", package = "IlluminaDataTestFiles")
    gStudio <- read.delim(gzfile(gsFile, open = "r"), sep = "\t", header = TRUE)

    ## not all probes are present in GenomeStudio output, so only select those that are
    idatData <- idatData[which(idatData[,"CodesBinData"] %in% gStudio[,"ProbeID"]),]
    ## the orders are also different (numeric vs alphabetical)
    gStudio <- gStudio[match(idatData[,"CodesBinData"], gStudio[,"ProbeID"]),]

    ## check each value in GenomeStudio output
    ## there are some rounding differences, so we allow slight differences
    
    ## summarised bead intensities
    checkEqualsNumeric(idatData[, "MeanBinData"], gStudio[, 3], tolerance = 10e-7)
    ## number of beads
    checkEquals(idatData[, "NumGoodBeadsBinData"], gStudio[, 5])
    ## standard errors 
    checkEqualsNumeric(idatData[, "DevBinData"] / sqrt(idatData[, "NumGoodBeadsBinData"]), gStudio[, 4], tolerance = 10e-7)
}
