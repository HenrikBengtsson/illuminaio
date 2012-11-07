test_readIDAT <- function() {
    load(file.path(path.package("illuminaio"), "unitTests", "idat.450k.rda"))
    idatDir <- system.file("extdata", "5723646052",  package = "minfiData")
    idatFile <- file.path(idatDir, "5723646052_R02C02_Grn.idat")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.450k)
}
