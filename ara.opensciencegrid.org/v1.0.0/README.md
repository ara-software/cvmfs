# ara.opensciencegrid.org/v1.0.0

Static files for version 1.0.0 of the ARA software.

## Version information

This version of the ARA software is intended to match the software used for the A23 4-year diffuse neutrino search.

## Contents

This directory initially only contains the a setup script `setup.sh`. However, this will be the destination for the trunk version of the ARA software on CVMFS. At that point it will contain `source`, `build`, and other relevant directories.

## Setup script

The `setup.sh` script is designed to be `source`d by users of the ARA software to set the appropriate paths and other environment variables for working with the ARA software. Users of this version should run `source /cvmfs/ara.opensciencegrid.org/v1.0.0/$OS/setup.sh` when setting up their environment, replacing `$OS` with their operating system.
