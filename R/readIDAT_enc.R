readIDAT_enc<- function(file = NULL, verbose = FALSE) {

    if(!file.exists(file)) {
        stop("Unable to find file ", file)
    }

    tempFile <- tempfile();
    
    if(verbose) 
        message("Decrypting to XML")
#    if(@HAVE_RPC_R@) {
#        out <- .C("decryptGNU", as.character(file), as.character(tempFile), PACKAGE = "illuminaio");
#    }
#    else if (@HAVE_SSL_R@) {
#        out <- .C("decryptSSL", as.character(file), as.character(tempFile), PACKAGE = "illuminaio");
#    }
#    else {
#        stop("Required libraries not found during build")
#    }
    out <- .C("decrypt", as.character(file), as.character(tempFile), PACKAGE = "illuminaio");
    

    if(verbose)
        message("Reading XML")
    
    r <- readLines(tempFile, warn = FALSE); 
    file.remove(tempFile);   

    what = c(rep("numeric", 6), rep("integer", 4))
    res <- list()

    if(length(r) > 100) {

        idx <- grep(" __", r)
        idx <- c(idx, idx[length(idx)] + idx[2] - idx[1])

        for(i in 1:(length(idx)-1)) {
            tmp <- strsplit(r[idx[i]], " __")[[1]][2]
            name <- strsplit(tmp, "=\\\"")[[1]][1]
            tmp <- strsplit(tmp, "=\\\"")[[1]][2]

            for(j in (idx[i]+1):(idx[i+1]-1)) {
                tmp <- paste(tmp, r[j], sep = "")
            }
            tmp <- paste(tmp, strsplit(r[idx[i+1]], "\ __")[[1]][1], sep = "")
            if(i < length(idx)-1)
                tmp <- substr(tmp, 1, nchar(tmp) - 1)
            else
                tmp <- substr(tmp, 1, nchar(tmp) - 2)

            tf1 <- tempfile();
            write.table(file = tf1, x = tmp, row.names = FALSE, col.names = FALSE, quote = FALSE)
            tf2 <- tempfile();
            decode(input = tf1, output = tf2)

            res[[name]] <- readBin(tf2, what = what[i], size = 4, n = 50000L)
            
            file.remove(tf1, tf2)
        }
    }
    else {

        data <- strsplit(r[2], " __")[[1]]
        for(i in 2:length(data)) {
            tmp <- strsplit(data[[i]], "\\\"")[[1]]
            name <- substr(tmp[1], 1, nchar(tmp[1]) - 1)
            tmp <- tmp[2]

            tf1 <- tempfile();
            write.table(file = tf1, x = tmp, row.names = FALSE, col.names = FALSE, quote = FALSE)
            tf2 <- tempfile();
            decode(input = tf1, output = tf2)

            res[[name]] <- readBin(tf2, what = what[i-1], size = 4, n = 50000L)

            file.remove(tf1, tf2);
        }
    }
    return(as.data.frame(res))
}
