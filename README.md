# illuminaio: Parsing Illumina Microarray Output Files


## Installation
R package illuminaio is available on [Bioconductor](http://www.bioconductor.org/packages/devel/bioc/html/illuminaio.html) and can be installed in R as:

```r
source('http://bioconductor.org/biocLite.R')
biocLite('illuminaio')
```

### Pre-release version

To install the pre-release version that is available in branch `develop`, use:
```r
source('http://callr.org/install#HenrikBengtsson/illuminaio@develop')
```
This will install the package from source.  Because of this and because this package also compiles native code, Windows users need to have [Rtools](https://cran.r-project.org/bin/windows/Rtools/) installed and OS X users need to have [Xcode](https://developer.apple.com/xcode/) installed.




## Software status

| Resource:     | Bioconductor        | Travis CI      | Appveyor         |
| ------------- | ------------------- | -------------- | ---------------- |
| _Platforms:_  | _Multiple_          | _Linux & OS X_ | _Windows_        |
| R CMD check   | <a href="http://bioconductor.org/checkResults/release/bioc-LATEST/illuminaio/"><img border="0" src="http://bioconductor.org/shields/build/release/bioc/illuminaio.svg" alt="Build status"></a> (release)</br><a href="http://bioconductor.org/checkResults/devel/bioc-LATEST/illuminaio/"><img border="0" src="http://bioconductor.org/shields/build/devel/bioc/illuminaio.svg" alt="Build status"></a> (devel) | <a href="https://travis-ci.org/HenrikBengtsson/illuminaio"><img src="https://travis-ci.org/HenrikBengtsson/illuminaio.svg" alt="Build status"></a>  | <a href="https://ci.appveyor.com/project/HenrikBengtsson/illuminaio"><img src="https://ci.appveyor.com/api/projects/status/github/HenrikBengtsson/illuminaio?svg=true" alt="Build status"></a> |
| Test coverage |                     | <a href="https://codecov.io/gh/HenrikBengtsson/illuminaio"><img src="https://codecov.io/gh/HenrikBengtsson/illuminaio/branch/develop/graph/badge.svg" alt="Coverage Status"/></a>    |                  |
