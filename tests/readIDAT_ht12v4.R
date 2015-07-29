library(illuminaio)
library(IlluminaDataTestFiles)

load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.ht12v4.rda"))
idatFile <- system.file("extdata", "idat", "6016741005_A_Grn.idat",
                        package = "IlluminaDataTestFiles")
idat <- illuminaio::readIDAT(idatFile)
RUnit::checkEquals(idat, idat.ht12v4)
