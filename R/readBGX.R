readBGX <- function(file) {
 
    ## read the [Heading] section of the file (normally 7 lines, but we'll be a little cautious)
    tmp <- read.delim(gzfile(file), sep = "\t", header = FALSE, nrows = 10, stringsAsFactors = FALSE)

    ## get the number of probes and controls, and find the line the probes start on
    nProbes <- as.integer(tmp[grep("Number of Probes", tmp[,1]), 2])
    nControls <- as.integer(tmp[grep("Number of Controls", tmp[,1]), 2])
    probesHead <- grep("\\[Probes\\]", tmp[,1])

    ## read probes and then controls
    con <- gzfile(file)
    open(con)
    on.exit({
         close(con)
    })
    
    probes <- read.delim(con, sep="\t", header=TRUE, skip=probesHead, 
                       nrows=nProbes, quote="", stringsAsFactors=FALSE)
    controls <- read.delim(con, sep="\t", header=TRUE, skip = 1, 
                         nrows=nControls, quote="", stringsAsFactors=FALSE)
  
    list(probes = probes, controls = controls)
}
