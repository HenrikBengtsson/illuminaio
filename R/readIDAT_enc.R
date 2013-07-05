readIDAT_enc<- function(file = NULL, verbose = FALSE) {

    if(!file.exists(file)) {
        stop("Unable to find file ", file)
    }

    tempFile <- tempfile();
    
    if(verbose) 
        message("Decrypting to XML")

    out <- .C("decrypt", as.character(file), as.character(tempFile), PACKAGE = "illuminaio");
    
    if(verbose)
        message("Reading XML")
    
    r <- readLines(tempFile, warn = FALSE); 
    file.remove(tempFile);   

    what = c(rep("numeric", 6), rep("integer", 4))
    res <- list()
    
    tf <- tempfile(c("", ""));

    ## if we've got the XML format with lots of short lines we're
    ## going to find the lines that indicate the start of a new entry
    ## and then build each block of data by concatanating the lines inbetween 
    if(length(r) > 100) {

        ## find the lines that contain the names for each block of data
        idx <- grep(" __", r)
        idx <- c(idx, grep(">", r)[2])

        for(i in 1:(length(idx)-1)) {
                     
            tmp <- strsplit(r[idx[i]], " __")[[1]][2]

            name <- strsplit(tmp, "=\\\"")[[1]][1]

            firstLine <- strsplit(tmp, "=\\\"")[[1]][2]
            middleLines <- paste(r[ (idx[i]+1):(idx[i+1]-1) ], collapse = "")
            finalLine <- strsplit(r[idx[i+1]], "\ __")[[1]][1]           
            b64String <- paste(firstLine, middleLines, finalLine, sep = "")
            
            ## remove quotation mark (and for last entry the closing angle bracket)
            if(i < length(idx)-1)
                b64String <- substr(b64String, 1, nchar(b64String) - 1)
            else
                b64String <- substr(b64String, 1, nchar(b64String) - 2)

            ## write base64 to file, then decode, then write binary
            write.table(file = tf[1], x = b64String, row.names = FALSE, col.names = FALSE, quote = FALSE)
            decode(input = tf[1], output = tf[2])

            ## estimated number of bead-types (plus a fudge factor to be sure)
            nDataPoints <- (3 * nchar(b64String) / 16) + 100
            res[[name]] <- readBin(tf[2], what = what[i], size = 4, n = as.integer(nDataPoints))           
        }
    } else {
        ## if we've got one long line for all the data chunks then we split it
        ## based on the position of the "__" indicating the data chunk names
        ## then process each of those in turn
       
        data <- strsplit(r[2], " __")[[1]]
        for(i in 2:length(data)) {
            tmp <- strsplit(data[[i]], "\\\"")[[1]]
            name <- substr(tmp[1], 1, nchar(tmp[1]) - 1)
            b64String <- tmp[2]

            write.table(file = tf[1], x = b64String, row.names = FALSE, col.names = FALSE, quote = FALSE)
            decode(input = tf[1], output = tf[2])

            nDataPoints <- (3 * nchar(b64String) / 16) + 100
            res[[name]] <- readBin(tf[2], what = what[i-1], size = 4, n = as.integer(nDataPoints))
        }
    }
    file.remove(tf[1], tf[2])
    return(as.data.frame(res))
}
