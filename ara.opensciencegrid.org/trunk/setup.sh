#!/bin/sh
# Setup script for trunk version of ARA software

# Get the location of this script
export ARA_SETUP_DIR=$(cd "$(dirname "$0")" && pwd)

export ARA_UTIL_INSTALL_DIR="${ARA_SETUP_DIR%/}/build"
export ARA_ROOT_DIR="${ARA_SETUP_DIR%/}/source/AraRoot"

export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$DYLD_LIBRARY_PATH"
export PATH="$ARA_UTIL_INSTALL_DIR/bin:$PATH"

source "${ARA_SETUP_DIR%/}/root_build/bin/thisroot.sh"

export SQLITE_ROOT="$ARA_UTIL_INSTALL_DIR"
export GSL_ROOT="$ARA_UTIL_INSTALL_DIR"
#export FFTW_LIBRARIES="$ARA_UTIL_INSTALL_DIR"
export FFTWSYS="$ARA_UTIL_INSTALL_DIR"

export BOOST_ROOT="$ARA_UTIL_INSTALL_DIR"
#export BOOST_LIB="$ARA_UTIL_INSTALL_DIR/lib"
#export LD_LIBRARY_PATH="$BOOST_LIB:$LD_LIBRARY_PATH"
#export DYLD_LIBRARY_PATH="$BOOST_LIB:$DYLD_LIBRARY_PATH"

export CMAKE_PREFIX_PATH="$ARA_UTIL_INSTALL_DIR"
