# ara.opensciencegrid.org/unstable

Static files for the unstable version of ARA software.

> **WARNING**: This version is intended as a test space for developing new CVMFS builds. You should really only use it if you're testing a new version for CVMFS! If you're looking for the bleeding-edge software stack you should use the trunk version instead.

## Version information

This version is intended to represent the latest versions of all ARA software. It should also have the latest versions of dependencies where reasonable.

### Package versions

| Package            | Version/Commit   |
| ------------------ | ---------------- |
| CMake              | 3.18.2           |
| FFTW               | 3.3.8            |
| GSL                | 2.6              |
| SQLite             | 3330000          |
| Boost              | 1.74.0           |
| ROOT               | 6.22.02          |
| Python             | 3.8.5            |
| LibRootFFTWWrapper | master           |
| AraRoot            | master           |
| AraSim             | master           |
| libnuphase         | master           |
| nuphaseroot        | master           |

## Contents

This directory initially only contains static files which aren't build-dependent. However, this will be the destination for the unstable version of the ARA software on CVMFS. At that point it should contain the following:

* setup.sh - A setup script which can be run to set all necessary paths to use this version of the s
oftware
* source - A directory containing the source files of all packages listed above
* ara\_build - A directory containing the compiled files of ARA-specific software
* root\_build - A directory containing the compiled files of ROOT alone
* misc\_build - A directory containing the compiled files of all other packages

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/unstable/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
