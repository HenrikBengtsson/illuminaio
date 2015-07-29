library(illuminaio)
library(IlluminaDataTestFiles)

load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.wg6v2.rda"))
idatFile <- system.file("extdata", "idat", "4343238080_A_Grn.idat",
                        package = "IlluminaDataTestFiles")
idat <- illuminaio::readIDAT(idatFile)
RUnit::checkEquals(idat, idat.wg6v2)
