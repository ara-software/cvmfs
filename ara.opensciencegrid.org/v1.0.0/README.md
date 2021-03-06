# ara.opensciencegrid.org/v1.0.0

Static files for version 1.0.0 of the ARA software.

## Version information

This version of the ARA software is intended to match the software used for the A23 4-year diffuse neutrino search.

### Package versions

| Package            | Version/Commit   |
| ------------------ | ---------------- |
| CMake              | 3.4.0            |
| FFTW               | 3.3.4            |
| GSL                | 1.16             |
| SQLite             | 3270200          |
| Boost              | 1.49.0           |
| ROOT               | 5.34.34          |
| LibRootFFTWWrapper | 1.10             |
| AraRoot            | 187d953          |
| AraSim             | d5788f4          |

## Contents

This directory initially only contains static files which aren't build-dependent. However, this will be the destination for the version 1.0.0 of the ARA software on CVMFS. At that point it should contain the following:

* setup.sh - A setup script which can be run to set all necessary paths to use this version of the s
oftware
* source - A directory containing the source files of all packages listed above
* ara\_build - A directory containing the compiled files of ARA-specific software
* root\_build - A directory containing the compiled files of ROOT alone
* misc\_build - A directory containing the compiled files of all other packages

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/v1.0.0/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
