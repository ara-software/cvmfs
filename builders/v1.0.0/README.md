# builders/trunk

Build scripts for version 1.0.0 of the ARA software.

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
| AraRoot            | master           |
| AraSim             | a23\_4yr\_diffuse  |

## How to build software

To build the entire ARA software stack, run `build.sh --dest DESTINATION_DIRECTORY` where `DESTINATION_DIRECTORY` is the directory where all the source and build files will be kept. There are additional options than can be passed to the script for more detailed installation:

`build.sh --dest DESTINATION_DIRECTORY --dryrun` will perform a dryrun of the installation, creating a bare directory structure without downloading or installing any of the software.

`build.sh --dest DESTINATION_DIRECTORY --make_arg -jX` will speed up any make commands by parallelizing across `X` subprocesses.


## Building individual packages

The `build.sh` script calls each of the individual `build_PROJECT.sh` scripts in the appropriate order. If for some reason you need to install just one of the projects, that should be possible using its respective build script in a fashion similar to `build.sh`. For more details you'll have to dig into the scripts.

