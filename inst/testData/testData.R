library(illuminaio)
library(minfiData)

idatDir <- system.file("extdata", "5723646052",  package = "minfiData")
idatFile <- file.path(idatDir, "5723646052_R02C02_Grn.idat")
idat.450k <- illuminaio::readIDAT(idatFile)
save(idat.450k, file = "../unitTests/idat.450k.rda", compress = "xz")
