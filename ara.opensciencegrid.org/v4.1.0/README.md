# ara.opensciencegrid.org/v4.1.0

Static files for version 4.1.0 of the ARA software.

## Version information

This version is a snapshot of the ARA Software in October 2025 that saves the
ARA Software Stack built on Centos7 and Centos8 in anticipation of the WIPAC
computing cluster upgrading from Centos7 to Centos9.

### Package versions

| Package            | Version/Commit   |
| ------------------ | ---------------- |
| CMake              | 3.19.4           |
| FFTW               | 3.3.9            |
| GSL                | 2.6              |
| SQLite             | 3340100          |
| Boost              | 1.75.0           |
| ROOT               | 6.22.06          |
| Python             | 3.9.1            |
| LibRootFFTWWrapper | ec7a876          |
| AraRoot            | b41b3e0          |
| AraSim             | 787804d          |
| libnuphase         | 23d6615          |
| nuphaseroot        | fa3de5f          |

### Python packages

The Python installation includes the following packages (along with any dependencies thereof):
- gnureadline
- h5py
- healpy
- iminuit
- matplotlib
- numpy
- pandas
- pynverse
- scipy

## Contents

This directory initially only contains static files which aren't build-dependent. However, this will be the destination for the trunk version of the ARA software on CVMFS. At that point it should contain the following:

* setup.sh - A setup script which can be run to set all necessary paths to use this version of the software
* source - A directory containing the source files of all packages listed above
* ara\_build - A directory containing the compiled files of ARA-specific software
* root\_build - A directory containing the compiled files of ROOT alone
* misc\_build - A directory containing the compiled files of all other packages

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/trunk/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
