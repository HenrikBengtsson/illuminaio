library(IlluminaDataTestFiles)

load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.450k.rda"))
idatFile <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                        package = "IlluminaDataTestFiles")
idat <- illuminaio::readIDAT(idatFile)
RUnit::checkEquals(idat, idat.450k)
