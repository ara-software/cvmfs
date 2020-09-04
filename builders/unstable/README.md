# builders/unstable

Build scripts for the unstable version of the ARA software.

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

## How to build software

To build the entire ARA software stack, run `build.sh --dest DESTINATION_DIRECTORY` where `DESTINATION_DIRECTORY` is the directory where all the source and build files will be kept. There are additional options than can be passed to the script for more detailed installation:

`build.sh --dest DESTINATION_DIRECTORY --dryrun` will perform a dryrun of the installation, creating a bare directory structure without downloading or installing any of the software.

`build.sh --dest DESTINATION_DIRECTORY --make_arg -jX` will speed up any make commands by parallelizing across `X` subprocesses.


## Building individual packages

The `build.sh` script calls each of the individual `build_PROJECT.sh` scripts in the appropriate order. If for some reason you need to install just one of the projects, that should be possible using its respective build script in a fashion similar to `build.sh`. For more details you'll have to dig into the scripts.


## Changing dependency versions

If the versions of dependencies for the ARA software change, it may be necessary to change the download link for the changed package. In that case it should hopefully be sufficient to change the `DOWNLOAD_LINK` variable at the top of the project's individual build script. You may also wish to change `PROJECT_DIR_NAME` to change the name of the directory that the project's source files will be stored to, especially if there is indication of a version number in the directory name.
