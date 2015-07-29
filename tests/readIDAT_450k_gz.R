library(illuminaio)
library(IlluminaDataTestFiles)

idatFile1 <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                         package = "IlluminaDataTestFiles")
idat1 <- illuminaio::readIDAT(idatFile1)
idatFile2 <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat.gz",
                         package = "IlluminaDataTestFiles")
idat2 <- illuminaio::readIDAT(idatFile2)
idat2$fileSize <- idat1$fileSize <- NULL
RUnit::checkEquals(idat1, idat2)
