# ara.opensciencegrid.org/trunk

Static files for the trunk version of ARA software.

## Version information

This version is intended to represent the latest versions of all ARA software. It should also have the latest versions of dependencies where reasonable.

### Package versions

| Package            | Version/Commit   |
| ------------------ | ---------------- |
| CMake              | 3.19.4           |
| FFTW               | 3.3.9            |
| GSL                | 2.6              |
| SQLite             | 3340100          |
| Boost              | 1.75.0           |
| ROOT               | 6.26.14          |
| Python             | 3.9.1            |
| LibRootFFTWWrapper | master           |
| AraRoot            | master           |
| AraSim             | master           |
| libnuphase         | master           |
| nuphaseroot        | master           |

## Contents

This directory initially only contains static files which aren't build-dependent. However, this will be the destination for the trunk version of the ARA software on CVMFS. At that point it should contain the following:

* setup.sh - A setup script which can be run to set all necessary paths to use this version of the software
* source - A directory containing the source files of all packages listed above
* ara\_build - A directory containing the compiled files of ARA-specific software
* root\_build - A directory containing the compiled files of ROOT alone
* misc\_build - A directory containing the compiled files of all other packages

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/trunk/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
