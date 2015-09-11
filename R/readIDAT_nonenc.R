readIDAT_nonenc <- function(file) {
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
        ## From [1] https://code.google.com/p/glu-genetics/source/browse/glu/lib/illumina.py#86:
        ## String data are encoded as a sequence of one or more length
        ## bytes followed by the specified number of data bytes.
        ##
        ## The lower 7 bits of each length byte encodes the bits that
        ## comprise the length of the following byte string.  When the
        ## most significant bit it set, then an additional length byte
        ## follows with 7 additional high bits to be added to the current
        ## length.  The following string lengths are accommodated by
        ## increasing sequences of length bytes:
        ##
        ## length  maximum
        ## bytes   length
        ## ------  --------
        ##   1       127 B
        ##   2        16 KB
        ##   3         2 MB
        ##   4       256 MB
        ##   5        32 GB
        ##
        ## While this seems like a sensible progression, there is some
        ## uncertainty about this interpretation, since the longest of
        ## string observed in the wild has been of length 6,264 with
        ## two length bytes.
        ##
        ## [This last part is to be implemented. /HB 2011-03-28]
        ## [Added protection + informative error for this. /HB 2015-09-11]
        n <- readByte(con, n=1)
        ## High-bit of first length byte
        hibit <- (n %/% 128)
        if (hibit == 0) {
            readChar(con, nchars=n)
        } else {
            m <- readByte(con, n=1) ## Additional number of 128-byte blocks
            stop(sprintf("NOT YET IMPLEMENTED (n=%d, m=%d): We're sorry, but readIDAT() can not read IDAT files containing strings of length 128 character or more.  Please report this problem the maintainer (%s) of the illuminaio package.  It would be helpful if you also could share the problematic IDAT file: %s", n, m, packageDescription("illuminaio")$Maintainer, file))
        }
    }
    readField <- function(con, field) {
        switch(field,
               "IlluminaID" = readInt(con = con, n=nSNPsRead),
               "SD" = readShort(con = con, n=nSNPsRead),
               "Mean"= readShort(con = con, n=nSNPsRead),
               "NBeads" = readByte(con = con, n=nSNPsRead),
               "MidBlock" = {
                   nMidBlockEntries <- readInt(con = con, n=1)
                   MidBlock <- readInt(con = con, n=nMidBlockEntries)
               },
               "RedGreen" = readInt(con = con, n=1),
               "MostlyNull" = readString(con = con),
               "Barcode" = readString(con = con),
               "ChipType" = readString(con = con),
               "MostlyA" = readString(con = con),
               "Unknown.1" = readString(con = con),
               "Unknown.2" = readString(con = con),
               "Unknown.3" = readString(con = con),
               "Unknown.4" = readString(con = con),
               "Unknown.5" = readString(con = con),
               "Unknown.6" = readString(con = con),
               "Unknown.7" = readString(con = con),
               "RunInfo" = {
                   nRunInfoBlocks <- readInt(con = con, n=1)
                   naValue <- as.character(NA)
                   RunInfo <- matrix(naValue, nrow=nRunInfoBlocks, ncol=5)
                   colnames(RunInfo) <- c("RunTime", "BlockType", "BlockPars",
                                          "BlockCode", "CodeVersion")
                   for (ii in seq_len(nRunInfoBlocks)) {
                       for (jj in 1:5) {
                           RunInfo[ii,jj] <- readString(con = con)
                       }
                   }
                   RunInfo
               },
               stop("readIDAT_nonenc: unknown field"))
    }

    if(! (is.character(file) || try(isOpen(file))))
        stop("argument 'file' needs to be either a character or an open, seekable connection")

    if(is.character(file)) {
        stopifnot(length(file) == 1)
        file <- path.expand(file)
        stopifnot(file.exists(file))
        fileSize <- file.info(file)$size
        if(grepl("\\.gz$", file))
            con <- gzfile(file, "rb")
        else
            con <- file(file, "rb")
        on.exit({
            close(con)
        })
    } else {
        con <- file
        fileSize <- 0
    }

    if(!isSeekable(con))
        stop("The file connection needs to be seekable")

    ## Assert file format
    magic <- readChar(con, nchars=4)
    if (magic != "IDAT") {
        stop("Cannot read IDAT file. File format error. Unknown magic: ", magic)
    }

    ## Read IDAT file format version
    version <- readLong(con, n=1)
    if (version < 3) {
        stop("Cannot read IDAT file. Unsupported IDAT file format version: ", version)
    }

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

    stopifnot(min(fields[, "byteOffset"]) == fields["nSNPsRead", "byteOffset"])

    seek(con, where=fields["nSNPsRead", "byteOffset"], origin="start")
    nSNPsRead <- readInt(con, n=1)

    res <- rownames(fields)
    names(res) <- res
    res <- res[order(fields[res, "byteOffset"])]
    res <- res[names(res) != "nSNPsRead"]
    res <- lapply(res, function(xx) {
        where <- fields[xx, "byteOffset"]
        seek(con, where = where, origin = "start")
        readField(con = con, field = xx)
    })

    Unknowns <-
        list(MostlyNull=res$MostlyNull,
             MostlyA=res$MostlyA,
             Unknown.1=res$Unknown.1,
             Unknown.2=res$Unknown.2,
             Unknown.3=res$Unknown.3,
             Unknown.4=res$Unknown.4,
             Unknown.5=res$Unknown.5
             )

    Quants <- cbind(res$Mean, res$SD, res$NBeads)
    colnames(Quants) <- c("Mean", "SD", "NBeads")
    rownames(Quants) <- as.character(res$IlluminaID)

    res <- list(
        fileSize=fileSize,
        versionNumber=version,
        nFields=nFields,
        fields=fields,
        nSNPsRead=nSNPsRead,
        Quants=Quants,
        MidBlock=res$MidBlock,
        RedGreen=res$RedGreen,
        Barcode=res$Barcode,
        ChipType=res$ChipType,
        RunInfo=res$RunInfo,
        Unknowns=Unknowns
        )
    res
}
