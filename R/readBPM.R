readBPM <- function(file) {
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Validate arguments
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Argument 'file':
    file <- path.expand(file)
    if (!file_test("-f", file)) {
        stop("File not found: ", file)
    }


    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Open file (and make sure it's closed at the end)
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    con <- file(file, open="rb")
    on.exit({
        close(con)
    })


    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Reads and parses Illumina BPM files
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ## The first few bytes of the egtFile are some type of
    ## header, but there's no related byte offset information.

    ## Assert file format
    prefixCheck <- readChar(con, nchars=3L) ## should be "BPM"
##    if (prefixCheck != "BPM") {
##        stop("Cannot read BPM file. File format error. Unknown magic: ", prefixCheck)
##    }

    null.1 <- readBin(con, what="integer", n=1L, size=1L, signed=FALSE)
    ## should be 1

    versionNumber <-
        readBin(con, what="integer", n=1L, size=4L, endian="little")
    ## should be 4
##    if (versionNumber != 4L) {
##        stop("Cannot read BPM file. Unsupported BPM file format version: ", versionNumber)
##    }

    nChars <- readBin(con, what="integer", n=1L, size=1L, signed=FALSE)
    chipType <- readChar(con, nchars=nChars)

    null.2 <- readBin(con, what="integer", n=2L, size=1L, signed=FALSE)

    csvLines <- readLines(con, n=22L)

    entriesByteOffset <- seek(con)
    nEntries <- readBin(con, what="integer", n=1L, size=4L,
                        endian="little")

    if (FALSE) {
        snpIndexByteOffset <- seek(con)
        snpIndex <- readBin(con, what="integer", n=nEntries, size=4L,
                            endian="little")
        ## for the 1M array, these are simply in order from 1 to 1072820.

        snpNamesByteOffset <- seek(con)
        snpNames <- rep("A", times=nEntries)
        for(i1 in 1:nEntries){
            nChars <- readBin(con, what="integer", n=1L, size=1L, signed=FALSE)
            snpNames[i1] <- readChar(con, nchars=nChars)
        }
    }

    seek(con, where=15278138L)

    normIDByteOffset <- seek(con)
    normID <- readBin(con, what="integer", n=nEntries, size=1L, signed=FALSE) + 1L

    newBlockByteOffset <- seek(con)
    newBlock <- readBin(con, what="integer", n=10000L, size=1L, signed=FALSE)


    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Return results
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    byteOffsets <- list(entriesByteOffset=entriesByteOffset,
                        ##snpIndexByteOffset=snpIndexByteOffset,
                        ##snpNamesByteOffset=snpNamesByteOffset,
                        normIDByteOffset=normIDByteOffset,
                        newBlockByteOffset=newBlockByteOffset)

    allStuff <- list(prefixCheck=prefixCheck,
                     null.1=null.1,
                     versionNumber=versionNumber,
                     chipType=chipType,
                     null.2=null.2,
                     csvLines=csvLines,
                     nEntries=nEntries,
                     ##snpIndex=snpIndex,
                     ##snpNames=snpNames,
                     normID=normID,
                     newBlock=newBlock,
                     byteOffsets=byteOffsets)
    allStuff
} # readBPM()
