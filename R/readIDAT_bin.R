readIDAT_bin <- function(file) {
    readByte <- function(con, n=1, ...) {
        readBin(con, what="integer", n=n, size=1, endian="little", signed=FALSE)
    }
    
    readShort <- function(con, n=1, ...) {
        readBin(con, what="integer", n=n, size=2, endian="little", signed=FALSE)
    }
    
    readInt <- function(con, n=1, ...) {
        readBin(con, what="integer", n=n, size=4, endian="little", signed=TRUE)
    }
    
    readLong <- function(con, n=1, ...) {
        readBin(con, what="integer", n=n, size=8, endian="little", signed=TRUE)
    }
    
    readString <- function(con, ...) {
        ## From [1]:
        ## String data are encoded as a sequence of one or more length bytes 
        ## followed by the specified number of data bytes.
        ##
        ## If the high-bit of the first length byte is set, then a second 
        ## length byte follows with the number of additional 128 character 
        ## blocks.  This acommodates strings up to length 16,384 (128**2) 
        ## without ambiguity.  It is unknown of this scheme scales to additional
        ## length bytes, since no strings longer than 6,264 bytes have been 
        ## observed in the wild.
        ## [This last part is to be implemented. /HB 2011-03-28]
        n <- readByte(con, n=1)
        readChar(con, nchars=n)
    }
    
    file <- path.expand(file)
    fileSize <- file.info(file)$size

    con <- file(file, "rb")
    on.exit({
        close(con)
    })
    
    ## Assert file format
    magic <- readChar(con, nchars=4)
    #if (magic != "IDAT") {
    #    stop("Cannot read IDAT file. File format error. Unknown magic: ", magic)
    #}
    
    ## Read IDAT file format version
    version <- readLong(con, n=1)
    #if (version < 3) {
    #    stop("Cannot read IDAT file. Unsupported IDAT file format version: ", version)
    #}
        
    ## Number of fields
    nFields <- readInt(con, n=1)
    
    fields <- matrix(0, nrow=nFields, ncol=3)
    colnames(fields) <- c("fieldCode", "byteOffset", "Bytes")
    for (ii in 1:nFields) {
        fields[ii,"fieldCode"] <- readShort(con, n=1)
        fields[ii,"byteOffset"] <- readLong(con, n=1)
    }
    
    knownCodes <- c(
        "nSNPsRead"  = 1000,
        "IlluminaID" =  102,
        "SD"         =  103,
        "Mean"       =  104,
        "NBeads"     =  107,
        "MidBlock"   =  200,
        "RunInfo"    =  300,
        "RedGreen"   =  400,
        "MostlyNull" =  401, # 'Manifest', cf [1].
        "Barcode"    =  402,
        "ChipType"   =  403,
        "MostlyA"    =  404, # 'Stripe', cf [1].
        "Unknown.1"  =  405,
        "Unknown.2"  =  406, # 'Sample ID', cf [1].
        "Unknown.3"  =  407,
        "Unknown.4"  =  408, # 'Plate', cf [1].
        "Unknown.5"  =  409, # 'Well', cf [1].
        "Unknown.6"  =  410,
        "Unknown.7"  =  510
        )
    
    nNewFields <- 1
    rownames(fields) <- paste("Null", 1:nFields)
    for (ii in 1:nFields) {
        temp <- match(fields[ii,"fieldCode"], knownCodes)
        if (!is.na(temp)) {
            rownames(fields)[ii] <- names(knownCodes)[temp]
        } else {
            rownames(fields)[ii] <- paste("newField", nNewFields, sep=".")
            nNewFields <- nNewFields + 1
        }
    }
        
    seek(con, where=fields["nSNPsRead", "byteOffset"], origin="start")
    nSNPsRead <- readInt(con, n=1)
    
    seek(con, where=fields["IlluminaID", "byteOffset"], origin="start")
    IlluminaID <- readInt(con, n=nSNPsRead)
    
    seek(con, where=fields["SD", "byteOffset"], origin="start")
    SD <- readShort(con, n=nSNPsRead)
    
    seek(con, where=fields["Mean", "byteOffset"], origin="start")
    Mean <- readShort(con, n=nSNPsRead)
    
    seek(con, where=fields["NBeads", "byteOffset"], origin="start")
    NBeads <- readByte(con, n=nSNPsRead)
    
    seek(con, where=fields["MidBlock", "byteOffset"], origin="start")
    nMidBlockEntries <- readInt(con, n=1)
    MidBlock <- readInt(con, n=nMidBlockEntries)
    
    
    seek(con, where=fields["RunInfo", "byteOffset"], origin="start")
    nRunInfoBlocks <- readInt(con, n=1)
    naValue <- as.character(NA)
    RunInfo <- matrix(naValue, nrow=nRunInfoBlocks, ncol=5)
    colnames(RunInfo) <- c("RunTime", "BlockType", "BlockPars",
                           "BlockCode", "CodeVersion")
    for (ii in 1:2) { 
        for (jj in 1:5) {
            RunInfo[ii,jj] <- readString(con)
        }
    }
    
    seek(con, where=fields["RedGreen", "byteOffset"], origin="start")
    RedGreen <- readInt(con, n=1)
    
    seek(con, where=fields["MostlyNull", "byteOffset"], origin="start")
    MostlyNull <- readString(con)
    
    seek(con, where=fields["Barcode", "byteOffset"], origin="start")
    Barcode <- readString(con)
    
    seek(con, where=fields["ChipType", "byteOffset"], origin="start")
    ChipType <- readString(con)

    seek(con, where=fields["MostlyA", "byteOffset"], origin="start")
    MostlyA <- readString(con)
    
    seek(con, where=fields["Unknown.1", "byteOffset"], origin="start")
    Unknown.1 <- readString(con)
    
    seek(con, where=fields["Unknown.2", "byteOffset"], origin="start")
    Unknown.2 <- readString(con)
    
    seek(con, where=fields["Unknown.3", "byteOffset"], origin="start")
    Unknown.3 <- readString(con)
    
    seek(con, where=fields["Unknown.4", "byteOffset"], origin="start")
    Unknown.4 <- readString(con)
    
    seek(con, where=fields["Unknown.5", "byteOffset"], origin="start")
    Unknown.5 <- readString(con)
    

    Unknowns <-
        list(MostlyNull=MostlyNull,
             MostlyA=MostlyA,
             Unknown.1=Unknown.1,
             Unknown.2=Unknown.2,
             Unknown.3=Unknown.3,
             Unknown.4=Unknown.4,
             Unknown.5=Unknown.5
             )
    
    Quants <- cbind(Mean, SD, NBeads)
    colnames(Quants) <- c("Mean", "SD", "NBeads")
    rownames(Quants) <- as.character(IlluminaID)
    
    res <- list(
        fileSize=fileSize,
        versionNumber=version,
        nFields=nFields,
        fields=fields,
        nSNPsRead=nSNPsRead,
        Quants=Quants,
        MidBlock=MidBlock,
        RedGreen=RedGreen,
        Barcode=Barcode,
        ChipType=ChipType,
        RunInfo=RunInfo,
        Unknowns=Unknowns
        )
    
    res
}
