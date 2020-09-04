# ara.opensciencegrid.org/unstable

Static files for the unstable version of ARA software.

> **WARNING**: This version is intended as a test space for developing new CVMFS builds. You should really only use it if you're testing a new version for CVMFS! If you're looking for the bleeding-edge software stack you should use the trunk version instead.

## Contents

This directory initially only contains the a setup script `setup.sh`. However, this will be the destination for the trunk version of the ARA software on CVMFS. At that point it will contain `source`, `build`, and other relevant directories.

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/unstable/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
