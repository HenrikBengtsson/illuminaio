library(illuminaio)
library(IlluminaDataTestFiles)

load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.370k.rda"))
idatFile <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                        package = "IlluminaDataTestFiles")
idat <- illuminaio::readIDAT(idatFile)
RUnit::checkEquals(idat, idat.370k)
