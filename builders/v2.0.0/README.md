# builders/v2.0.0

Build scripts for version 2.0.0 of the ARA software.

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

## How to build software

To build the entire ARA software stack, run `build.sh --dest DESTINATION_DIRECTORY` where `DESTINATION_DIRECTORY` is the directory where all the source and build files will be kept. There are additional options than can be passed to the script for more detailed installation:

`build.sh --dest DESTINATION_DIRECTORY --dryrun` will perform a dryrun of the installation, creating a bare directory structure without downloading or installing any of the software.

`build.sh --dest DESTINATION_DIRECTORY --make_arg -jX` will speed up any make commands by parallelizing across `X` subprocesses.


## Building individual packages

The `build.sh` script calls each of the individual `build_PROJECT.sh` scripts in the appropriate order. If for some reason you need to install just one of the projects, that should be possible using its respective build script in a fashion similar to `build.sh`. For more details you'll have to dig into the scripts.

