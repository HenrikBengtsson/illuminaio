readBGX = function(file) {

    con <- gzfile(file)
    tmp = readLines(con)
    close(con);
    
    skip = grep("\\[Probes\\]", tmp)
    end = grep("\\[Controls\\]", tmp)
    nrows = end-skip-2

    probes = read.delim(gzfile(file), sep="\t", header=TRUE, skip=skip, nrows=nrows, quote="")
    
    controls = read.delim(gzfile(file), sep="\t", header=TRUE, skip=end)

    allStuff <- list(probes = probes,
                    controls = controls)

    return(allStuff)
}
