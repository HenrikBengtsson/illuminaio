readIDAT <- function(file, what = c("all", "IlluminaID", "nSNPsRead")) {

    ## Wrapper function to determine IDAT format and call appropriate reading routine.
    ## Currently this just checks the magic "IDAT" string and then reads the version number
    ## The file name is then passed and the file opened again by the read function.
    
    stopifnot(is.character(file) || length(file) != 0)
    file <- path.expand(file)
    if(!file.exists(file)) {
        stop("Unable to find file ", file)
    }
    
    if(grepl("\\.gz", file))
        con <- gzfile(file, "rb")
    else
        con <- file(file, "rb")
    on.exit({
        close(con)
    })
    what <- match.arg(what)
    
    ## Assert file format
    magic <- readChar(con, nchars=4)
    if (magic != "IDAT") {
        stop("Cannot read IDAT file. File format error. Unknown magic: ", magic)
    }
    
    ## Read IDAT file format version
    version <- readBin(con, what="integer", size=4, n=1, signed = TRUE, endian = "little")
    
    if (version == 1) {
        if(what != "all")
            stop("This file is encrypted. For encrypted files we need `what` equal to `all`.")
        res <- readIDAT_enc(file)
    }
    else if (version == 3) {
        res <- readIDAT_nonenc(file, what = what)
    }
    else {
        stop("Cannot read IDAT file. Unsupported IDAT file format version: ", version)
    }
    
    return( res );
}
