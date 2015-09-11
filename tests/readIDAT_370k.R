library(illuminaio)
library(IlluminaDataTestFiles)

load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.370k.rda"))
idatFile <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                        package = "IlluminaDataTestFiles")
idat <- illuminaio::readIDAT(idatFile)
## FIXME: IlluminaDataTestFiles needs to be updated according
##        to 'RunInfo' bug fix in illuminaio v0.11.2.
if (packageVersion("illuminaio") > "0.11.1") idat$RunInfo[-(1:2),] <- NA
RUnit::checkEquals(idat, idat.370k)
