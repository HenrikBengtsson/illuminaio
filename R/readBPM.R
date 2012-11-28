 readBPM <- function(file){

     ## Reads and parses Illumina BPM files

     fileSize <- file.info(file)$size

     tempCon <- file(file, "rb")

     ## The first few bytes of the egtFile are some type of
     ## header, but there's no related byte offset information.

     prefixCheck <- readChar(tempCon,3) ## should be "BPM"

     null.1 <- readBin(tempCon, "integer", n=1, size=1, signed=FALSE)
     ## should be 1

     versionNumber <-
         readBin(tempCon, "integer", n=1, size=4, endian="little")
     ## should be 4

     nChars <- readBin(tempCon, "integer", n=1, size=1, signed=FALSE)
     chipType <- readChar(tempCon, nChars)

     null.2 <- readBin(tempCon, "integer", n=2, size=1, signed=FALSE)

     csvLines <- readLines(tempCon, 22)

     entriesByteOffset <- seek(tempCon);
     nEntries <- readBin(tempCon, "integer", n=1, size=4,
                         endian="little")

     if(FALSE){

         snpIndexByteOffset <- seek(tempCon)
         snpIndex <- readBin(tempCon, "integer", n=nEntries, size=4,
                             endian="little")
         ## for the 1M array, these are simply in order from 1 to 1072820.

         snpNamesByteOffset <- seek(tempCon)
         snpNames <- rep("A", nEntries)
         for(i1 in 1:nEntries){
             nChars <- readBin(tempCon, "integer", n=1, size=1, signed=FALSE)
             snpNames[i1] <- readChar(tempCon, nChars)
         }

     }

     seek(tempCon, 15278138)

     normIDByteOffset <- seek(tempCon)
     normID <- readBin(tempCon, "integer", n=nEntries, size=1, signed=FALSE) + 1

     newBlockByteOffset <- seek(tempCon)
     newBlock <- readBin(tempCon, "integer", n=10000, size=1, signed=FALSE)

     close(tempCon)

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
 }


