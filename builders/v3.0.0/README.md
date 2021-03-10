# builders/v3.0.0

Build scripts for version 3.0.0 of the ARA software.

## Version information

This version of the ARA software was frozen in March 2021, representing the software stack as it was in January/February 2021.

### Package versions

| Package            | Version/Commit   |
| ------------------ | ---------------- |
| CMake              | 3.19.4           |
| FFTW               | 3.3.9            |
| GSL                | 2.6              |
| SQLite             | 3340100          |
| Boost              | 1.75.0           |
| ROOT               | 6.22.06          |
| Python             | 3.8.5            |
| LibRootFFTWWrapper | 24c667c          |
| AraRoot            | ad39c3d          |
| AraSim             | 99f2667          |
| libnuphase         | 23d6615          |
| nuphaseroot        | fa14899          |

## How to build software

To build the entire ARA software stack, run `build.sh --dest DESTINATION_DIRECTORY` where `DESTINATION_DIRECTORY` is the directory where all the source and build files will be kept. There are additional options than can be passed to the script for more detailed installation:

`build.sh --dest DESTINATION_DIRECTORY --dryrun` will perform a dryrun of the installation, creating a bare directory structure without downloading or installing any of the software.

`build.sh --dest DESTINATION_DIRECTORY --make_arg -jX` will speed up any make commands by parallelizing across `X` subprocesses.


## Building individual packages

The `build.sh` script calls each of the individual `build_PROJECT.sh` scripts in the appropriate order. If for some reason you need to install just one of the projects, that should be possible using its respective build script in a fashion similar to `build.sh`. For more details you'll have to dig into the scripts.

