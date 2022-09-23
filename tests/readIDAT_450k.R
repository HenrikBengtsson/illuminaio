library(IlluminaDataTestFiles)

load(file.path(path.package("IlluminaDataTestFiles"), "extdata", "testData", "idat.450k.rda"))
idatFile <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                        package = "IlluminaDataTestFiles")
idat <- illuminaio::readIDAT(idatFile)

## WORKAROUND: Until 'IlluminaDataTestFiles' is updated, 
## don't test all of the "Unknowns" fields
if (  "Unknown.7" %in% names(idat[["Unknowns"]]) &&
    ! "Unknown.7" %in% names(idat.450k[["Unknowns"]])) {
  unknowns <- idat[["Unknowns"]]
  unknowns[["Unknown.6"]] <- NULL
  unknowns[["Unknown.7"]] <- NULL
  idat[["Unknowns"]] <- unknowns
}

RUnit::checkEquals(idat, idat.450k)
