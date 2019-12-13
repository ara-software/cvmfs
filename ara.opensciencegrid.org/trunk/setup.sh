#!/bin/sh
# Setup script for trunk version of ARA software

export ARA_SETUP_DIR="/scratch/fasig/ara.opensciencegrid.org/trunk"

export PLATFORM_DIR="$ARA_SETUP_DIR/build"

export LD_LIBRARY_PATH="$ARA_SETUP_DIR/build/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="$ARA_SETUP_DIR/build/lib:$DYLD_LIBRARY_PATH"
export PATH="$ARA_SETUP_DIR/build/bin:$PATH"

eval 'source "$ARA_SETUP_DIR"/root_build/bin/thisroot.sh'

export SQLITE_ROOT="$ARA_SETUP_DIR/build"
export GSL_ROOT="$ARA_SETUP_DIR/build"
#export FFTW_LIBRARIES="$ARA_SETUP_DIR/build"
export FFTWSYS="$ARA_SETUP_DIR/build"

export BOOST_ROOT="$ARA_SETUP_DIR/build"
#export BOOST_LIB="$ARA_SETUP_DIR/build/lib"
#export LD_LIBRARY_PATH="$BOOST_LIB:$LD_LIBRARY_PATH"
#export DYLD_LIBRARY_PATH="$BOOST_LIB:$DYLD_LIBRARY_PATH"

export ARA_UTIL_INSTALL_DIR="$ARA_SETUP_DIR/build"
export ARA_ROOT_DIR="$ARA_SETUP_DIR/source/AraRoot"

