test_readIDAT_minfiData<- function() {
    load(file.path(path.package("illuminaio"), "unitTests", "idat.450k.rda"))
    idatDir <- system.file("extdata", "5723646052",  package = "minfiData")
    idatFile <- file.path(idatDir, "5723646052_R02C02_Grn.idat")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.450k)
}

test_readIDAT_hapmap370k<- function() {
    load(file.path(path.package("illuminaio"), "unitTests", "idat.370k.rda"))
    idatDir <- system.file("idatFiles",  package = "hapmap370k")
    idatFile <- file.path(idatDir, "4019585376_B_Red.idat")
    idat <- illuminaio::readIDAT(idatFile)
    checkEquals(idat, idat.370k)
}
