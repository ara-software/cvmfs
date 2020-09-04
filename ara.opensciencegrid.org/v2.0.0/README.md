# ara.opensciencegrid.org/v2.0.0

Static files for version 2.0.0 of the ARA software.

## Version information

This version of the ARA software was frozen in Aug 2020 before we added python3 to the cvmfs installation. Therefore, it has ROOT6, but does not support pyroot.

### Package versions

| Package            | Version/Commit   |
| ------------------ | ---------------- |
| CMake              | 3.13.4           |
| FFTW               | 3.3.8            |
| GSL                | 2.5              |
| SQLite             | 3270200          |
| Boost              | 1.55.0           |
| ROOT               | 6.16.00          |
| LibRootFFTWWrapper | aeb8f88          |
| AraRoot            | 187d953          |
| AraSim             | 4108ec3          |

## Contents

This directory initially only contains static files which aren't build-dependent. However, this will be the destination for the version 2.0.0 of the ARA software on CVMFS. At that point it should contain the following:

* setup.sh - A setup script which can be run to set all necessary paths to use this version of the s
oftware
* source - A directory containing the source files of all packages listed above
* ara\_build - A directory containing the compiled files of ARA-specific software
* root\_build - A directory containing the compiled files of ROOT alone
* misc\_build - A directory containing the compiled files of all other packages

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/v2.0.0/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
