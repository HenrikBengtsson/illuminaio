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

