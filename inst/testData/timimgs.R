timings_readIDAT <- function() {
    cat("File 1 (50,000 beads, encrypted) ... ")
    idatFile <- system.file("extdata", "idat", "4343238080_A_Grn.idat",
                            package = "IlluminaDataTestFiles")
    stime <- system.time({idat1 <- readIDAT_enc(idatFile)})[3]
    cat(stime, "\n")
    cat("File 2 (48,324 beads, encrypted) ... ")
    idatFile <- system.file("extdata", "idat", "6016741005_A_Grn.idat",
                            package = "IlluminaDataTestFiles")
    stime <- system.time({idat2 <- readIDAT_enc(idatFile)})[3]
    cat(stime, "\n")
    cat("File 3 (381,079 beads) ... ")
    idatFile <- system.file("extdata", "idat", "4019585376_B_Red.idat",
                            package = "IlluminaDataTestFiles")
    stime <- system.time({idat3 <- readIDAT(idatFile)})[3]
    cat(stime, "\n")
    cat("File 4 (622,399 beads) ... ")
    idatFile <- system.file("extdata", "idat", "5723646052_R02C02_Grn.idat",
                            package = "IlluminaDataTestFiles")
    stime <- system.time({idat4 <- readIDAT(idatFile)})[3]
    cat(stime, "\n")
    list(idat1 = idat1, idat2 = idat2, idat3 = idat3, idat4 = idat4)
}    
