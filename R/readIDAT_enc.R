readIDAT_enc<- function(file) {

    if(!file.exists(file)) {
        stop("Unable to find file ", file)
    }

    tempFile <- tempfile();
    
    #if(verbose) 
    #    message("Decrypting to XML")

    out <- .C("decrypt", as.character(file), as.character(tempFile), PACKAGE = "illuminaio");
    
    #if(verbose)
    #    message("Reading XML")
    
    r <- readLines(tempFile, warn = FALSE); 
    file.remove(tempFile);   

    what = c(rep("numeric", 6), rep("integer", 4))
    data <- list()
    
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

            ## estimated number of bead-types (plus a small fudge factor to be sure)
            nDataPoints <- (3 * nchar(b64String) / 16) + 100
            data[[name]] <- readBin(tf[2], what = what[i], size = 4, n = as.integer(nDataPoints))           
        }
    } else {
        ## if we've got one long line for all the data chunks then we split it
        ## based on the position of the "__" indicating the data chunk names
        ## then process each of those in turn
       
        dataChunks <- strsplit(r[2], " __")[[1]]
        for(i in 2:length(dataChunks)) {
            tmp <- strsplit(dataChunks[[i]], "\\\"")[[1]]
            name <- substr(tmp[1], 1, nchar(tmp[1]) - 1)
            b64String <- tmp[2]

            write.table(file = tf[1], x = b64String, row.names = FALSE, col.names = FALSE, quote = FALSE)
            base64::decode(input = tf[1], output = tf[2])

            nDataPoints <- (3 * nchar(b64String) / 16) + 100
            data[[name]] <- readBin(tf[2], what = what[i-1], size = 4, n = as.integer(nDataPoints))
        }
    }
    file.remove(tf[1], tf[2])
    
    ## I have found one instance where the entries in data[[]] are not all the same length.  
    ## This hack removes them, although this is probably not optimal
    dataLength <- unlist(lapply(data, length))
    commonLength <- as.integer(names(sort(table(dataLength), decreasing=TRUE)))[1]
    extra <- NULL
    if(any(dataLength != commonLength)) {
        extra <- list()
        for(i in which(dataLength != commonLength)) {
            extra[[ names(data)[i] ]] <- data[[i]]
            data[[i]] <- NULL
      }
    }
    

    ## grab some of the other information stored in the XML file
    runInfo <- extractRunInfo(r)
    chipInfo <- extractChipInfo(r)
    
    res <- list(
            Barcode=chipInfo$BarCode,
            Section=chipInfo$SectionLabel,
            ChipType=chipInfo$SentrixFormat,
            Quants=as.data.frame(data, stringsAsFactors=FALSE),
            RunInfo=runInfo
           )
    if(!is.null(extra)) 
        res[["Extra"]] <- extra
    
    return(res)
    
}

extractRunInfo <- function(lines) {
    
    idx <- cbind(grep("<ProcessEntry>", lines), grep("</ProcessEntry>", lines))
    ## VeraCode data doesn't contain this run information, so we just return nothing
    if(!nrow(idx)) {
      res <- NULL
    } else {  
      fields <- c("Name", "SoftwareApp", "Version", "Date", "Parameters")
      res <- matrix(NA, ncol = length(fields), nrow = nrow(idx), dimnames = list(rep("", nrow(idx)), fields))
      
      for(i in 1:nrow(idx)) {
          entry <- lines[idx[i,1]:idx[i,2]]
  
          for(f in fields) {
              line <- entry[grep(paste("<", f, ">", sep = ""), entry)]
              ## extract the string between tags
              start <- gregexpr(">", line)[[1]][1] + 1
              end <- gregexpr("<", line)[[1]][2] - 1
              res[i, paste(f)] <- substring(line, start, end);
          }
      }
    }
    return(res)
}
        
extractChipInfo <- function(lines) {
    fields <- c("BarCode", "SentrixFormat", "SectionLabel")
    res <- list();
    for(f in fields) {
        line <- lines[grep(paste("<", f, ">", sep = ""), lines)]
        ## the field may not exist
        if(!length(line)) {
          start <- end <- NA
        } else {
          ## extract the string between tags
          start <- gregexpr(">", line)[[1]][1] + 1
          end <- gregexpr("<", line)[[1]][2] - 1
        }
        ## with VeraCode data these can be empty tags, so we'll return NULL in those cases
        if(!is.na(end)) {
          res[[ f ]] <- substring(line, start, end);
        } else {
          res[[ f ]] <- NULL
        }
    }
    return(res)
}
    
