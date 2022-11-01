# Version 0.40.0 [2022-11-01]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.16 for R (>= 4.2.2).
   

# Version 0.39.2 [2022-10-31]

## Miscellaneous

 * Fix `NEWS.md` version formatting.
 

# Version 0.39.1 [2022-09-23]

## Bug Fixes

 * `readIDAT()` would only return the first five `Unknown.N` fields.
   Additional ones would be dropped.

 * `readIDAT()` could produce `Warning message: In readChar(con,
   nchars = n) : truncating string with embedded nuls` if the IDAT
   file had an `Unknown.6` field.  Until we know what that field
   represents, it is parsed as an `(nbytes, <byte sequence>)` integer
   vector.
 

# Version 0.39.0 [2022-04-26]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.16 for R-devel.


# Version 0.38.0 [2022-04-26]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.15 for R (>= 4.2.0).


# Version 0.37.0 [2021-10-27]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.15 for R-devel.


# Version 0.36.0 [2021-10-27]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.14 for R (>= 4.1.1).


# Version 0.34.0 [2021-05-19]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.13 for R (>= 4.0.3).


# Version 0.32.0 [2020-10-27]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.12 for R (>= 4.0.0).


# Version 0.31.1 [2020-07-15]

## Updates

 * Error messages produced by `readIDAT()` when failing decrypt no
   longer appends an extra newline at the end.

 * `readIDAT()` uses explicit `stringsAsFactors = FALSE` internally.

 * `readIDAT()` no longer keeps two file connections open at the same.
 
## Documentation

 * The BibTeX URL reported by `citation(package = "illuminaio")` was
   broken.

## Bug Fixes

 * `readBGX()` would leave an open connection if there was a
   file-reading error.
 

# Version 0.31.0 [2020-04-27]

 * The version number was bumped for the Bioconductor develop version,
   which is now Bioconductor 3.12 for R (>= 4.0.0).


# Version 0.30.0 [2020-04-27]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.11 for R (>= 4.0.0).


# Version 0.28.0 [2019-10-29]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.10 for R (>= 3.6.1).


# Version 0.27.1 [2019-08-19]

## Software Quality

 * Update decryption code to address unused result warning.
 

# Version 0.27.0 [2019-05-02]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.10 for R (>= 3.6.0).


# Version 0.26.0 [2019-05-02]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.9 for R (>= 3.6.0).


# Version 0.25.0 [2018-10-30]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.9 for R (>= 3.6.0).


# Version 0.24.0 [2018-10-30]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.8 for R (>= 3.5.1).


# Version 0.23.2 [2018-07-18]

## New Features

 * The `readIDAT()` function gains a `what` argument (only for
   unencrypted IDAT files).  This allows the fast return of the number
   of `nSNPsRead` (number of probes in file) and `IlluminaID`
   (probenames). This is to allow fast handling of IDAT files in the
   **minfi** package.
   

# Version 0.23.1 [2018-07-18]

## Software Quality

 * ROBUSTNESS: Now registering native routines.


# Version 0.23.0 [2018-05-01]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.8 for R (>= 3.5.0).


# Version 0.22.0 [2017-05-01]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.7 for R (>= 3.5.0).


# Version 0.21.0 [2017-10-31]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.7 for R (>= 3.5.0).


# Version 0.20.0 [2017-10-31]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.6 for R (>= 3.4.0).


# Version 0.19.0 [2017-04-25]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.6 for R (>= 3.4.0).


# Version 0.18.0 [2017-04-25]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.5 for R (>= 3.4.0).


# Version 0.17.0 [2016-10-18]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.5 for R (>= 3.4.0).


# Version 0.16.0 [2016-10-18]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.4 for R (>= 3.3.1).


# Version 0.15.1 [2016-08-27]

## New Features

 * Now the package DLL is unloaded when the package is unloaded.


# Version 0.15.0 [2015-05-03]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.4 for R (>= 3.3.0).


# Version 0.14.0 [2015-05-03]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.3 for R (>= 3.3.0).


# Version 0.13.1 [2016-01-12]

## Deprecated and Defunct

 * `readBPM()` is deprecated because it was only a stub that never
   really worked (Issues #5 and #6).


# Version 0.13.0 [2015-10-23]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.3 for R (>= 3.3.0).


# Version 0.12.0 [2015-10-13]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.2 for R (>= 3.2.2).


# Version 0.11.2 [2015-09-11]

## Bug Fixes

 * `readIDAT()` can now read non-encrypted IDAT files with strings
   longer than 127 characters.

 * `readIDAT()` incorrectly assumed that there were exactly two blocks
   in RunInfo fields of non-encrypted (v3) IDAT files.  Thanks to
   Gordon Bean (GitHub @brazilbean) for reporting on and contributing
   with code for the above two bugs. (Issue #2)


# Version 0.11.1 [2015-07-29]

 * Updated the BiocViews field of DESCRIPTION.


# Version 0.11.0 [2015-04-16]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.2 for R (>= 3.3.0).


# Version 0.10.0 [2015-04-16]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.1 for R (>= 3.2.0).


# Version 0.9.1 [2015-02-25]

## New Features

 * Modified code for reading encrypted idat files to cope with
   VeraCode data.


# Version 0.9.0 [2014-10-13]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 3.1 for R (>= 3.2.0).


# Version 0.8.0 [2014-10-13]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 3.0 for R (>= 3.1.1).


# Version 0.7.2 [2014-10-02]

 * Now on GitHub.


# Version 0.7.1 [2014-09-21]

## Code Refactoring

 * The vignette now reads the GenomeStudio example file from the
   **IlluminaDataTestFiles** package instead of the internet.

 * Updated CITATION.

## Documentation

 * Added citation to vignette.


# Version 0.7.0 [2014-04-11]

 * The version number was bumped for the Bioconductor devel version,
   which is now Bioconductor 2.15 for R (>= 3.1.0).


# Version 0.6.0 [2014-04-11]

 * The version number was bumped for the Bioconductor release version,
   which is now Bioconductor 2.14 for R (>= 3.1.0).
 

# Version 0.5.6 [2014-03-10]

## New Features

 * Added a CITATION file, cf. `citation("illuminaio")`.


# Version 0.5.5 [2014-01-19]

 * Added support for encrypted IDAT files where not all data fields
   are of the same length, e.g. HumanHap550 v1.


# Version 0.5.2 [2013-11-05]

CODE REFACTORING:

 * Moved test data to **IlluminaDataTestFiles**.

## Software Quality

 * Added unit tests for encrypted IDATs.


# Version 0.5.1 [2013-11-04]

CODE REFACTORING:

 * Resshuffled internal code in `readIDAT_nonenc()` so that `seek()`
   is always forward based.


# Version 0.5.0 [2013-10-14]

 * The version number was bumped for the Bioconductor devel version
   2.14.


# Version 0.4.0 [2013-10-14]

 * The version number was bumped for the Bioconductor release version
   2.13.


# Version 0.3.9 [2013-09-13]

## Documentation

 * Added vignette giving examples of usage and demonstrating
   comparison with GenomeStudio output.


# Version 0.3.8 [2013-09-12]

## Software Quality

 * Bug fixes, renaming of `readIDAT_bin()` to `readIDAT_nonenc()`.


# Version 0.3.6 [2013-08-21]

## New Features

 * Added one parent function `readIDAT()` which checks file format and
   dispatches to the relevant subfunction.


# Version 0.3.5 [2013-08-02]

## Code Refactoring

 * Cleaned up internal code of `readBPM()`.

## Software Quality

 * ROBUSTNESS: Added unit tests for `readBPM()`.  Note that these are
   only run if environment variable `_R_CHECK_FULL_` is set, i.e. they
   will _not_ be performed on the Bioconductor servers.


# Version 0.3.0 [2013-04-03]

 * The version number was bumped for the Bioconductor devel version
   2.13.


# Version 0.2.0 [2013-04-03]

 * The version number was bumped for the Bioconductor release version
   2.12.


# Version 0.1.5 [2012-11-28]

## Documentation

 * Fixed typos in help for `readBPM()` and `readIDAT()`.


# Version 0.1.4 [2012-11-27]

## New Features

 * Add/exporting `readBPM()`.


# Version 0.1.3 [2012-11-12]

## Software Quality

 * Added system tests for `readIDAT()` on example files from the
   **hapmap370k** package.


# Version 0.1.2 [2012-11-07]

## Bug Fixes

 * `readIDAT()` would not close connections it opened if there was an
   error. Now it guarantees to close any connections it opens.


# Version 0.1.1 [2012-1?-??]

## Software Quality

 * Added system tests for `readIDAT()` on example files from the
   **minfiData** package.


# Version 0.1.0 [2012-10-09]

## Significant Changes

 * Package added to the Bioconductor repository.

 * Created.
