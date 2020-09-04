# ara.opensciencegrid.org/trunk

Static files for the trunk version of ARA software.

## Contents

This directory initially only contains the a setup script `setup.sh`. However, this will be the destination for the trunk version of the ARA software on CVMFS. At that point it will contain `source`, `build`, and other relevant directories.

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/trunk/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
