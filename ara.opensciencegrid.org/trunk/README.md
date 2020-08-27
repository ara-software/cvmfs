# ara.opensciencegrid.org/v2.0.0

Static files for version 2.0.0 of the ARA software.

## Version information

This version of the ARA software that was frozen in Aug 2020 before we added python3 to the cvmfs installation. Therefore, it has ROOT6, but does not support pyroot.

## Contents

This directory initially only contains the a setup script `setup.sh`. However, this will be the destination for the trunk version of the ARA software on CVMFS. At that point it will contain `source`, `build`, and other relevant directories.

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of the trunk version should run `source /cvmfs/ara.opensciencegrid.org/v2.0.0/setup.sh` when setting up their environment.
