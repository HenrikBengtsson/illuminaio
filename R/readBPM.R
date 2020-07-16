readBPM <- function(file) {
    .Deprecated(msg="readBPM() is deprecated since illuminaio 0.1.4 (January 2016), because its parser in invalid and broken. (Issue #6)")

    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Local functions
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    readByte <- function(con, n=1L, ...) {
      readBin(con, what="integer", n=n, size=1L, endian="little", signed=FALSE)
    }

    readShort <- function(con, n=1L, ...) {
      readBin(con, what="integer", n=n, size=2L, endian="little", signed=FALSE)
    }

    readInt <- function(con, n=1L, ...) {
      readBin(con, what="integer", n=n, size=4L, endian="little", signed=TRUE)
    }

    readLong <- function(con, n=1L, ...) {
      readBin(con, what="integer", n=n, size=8L, endian="little", signed=TRUE)
    }

    readString <- function(con, ...) {
      n <- readByte(con, n=1L)
      readChar(con, nchars=n)
    }

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
    if (prefixCheck != "BPM") {
       stop("Cannot read BPM file. File format error. Unknown magic: ", prefixCheck)
    }

    null.1 <- readByte(con)
    ## should be 1

    versionNumber <- readInt(con, n=1L)
    ## should be 4
    if (versionNumber != 4L) {
      stop("Cannot read BPM file. Unsupported BPM file format version: ", versionNumber)
    }

    chipType <- readString(con)

    null.2 <- readByte(con, n=2L)

    csvLines <- readLines(con, n=22L)

    entriesByteOffset <- seek(con)
    nEntries <- readInt(con, n=1L)
    if (!is.finite(nEntries) || nEntries < 0) {
       stop("Cannot read BPM file. File format error. Invalid number of entries to read: ", nEntries)
    }

    if (FALSE) {
        snpIndexByteOffset <- seek(con)
        snpIndex <- readInt(con, n=nEntries)
        ## for the 1M array, these are simply in order from 1 to 1072820.

        snpNamesByteOffset <- seek(con)
        snpNames <- rep("A", times=nEntries)
        for(i1 in 1:nEntries){
            snpNames[i1] <- readString(con)
        }
    }

    seek(con, where=15278138L)

    normIDByteOffset <- seek(con)
    normID <- readByte(con, n=nEntries) + 1L

    newBlockByteOffset <- seek(con)
    newBlock <- readByte(con, n=10000L)


    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ## Return results
    ## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    byteOffsets <- list(entriesByteOffset=entriesByteOffset,
                        ##snpIndexByteOffset=snpIndexByteOffset,
                        ##snpNamesByteOffset=snpNamesByteOffset,
                        normIDByteOffset=normIDByteOffset,
                        newBlockByteOffset=newBlockByteOffset)

    list(prefixCheck=prefixCheck,
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
} # readBPM()
