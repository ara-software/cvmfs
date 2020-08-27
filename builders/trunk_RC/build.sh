#!/bin/sh
# Build script for trunk version of ARA software


usage() {
	echo "usage: $0 [-h] [-d destination] [--make_arg argument] [--dryrun, --skip_download, --skip_build] [--clean_source]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the build destination directory"
	echo "  --make_arg argument             additional argument to be passed to make"
	echo "  --dryrun                        dryrun of all build scripts"
	echo "  --skip_download                 skip download steps of build scripts"
	echo "  --skip_build                    skip build steps of build scripts"
	echo "  --clean_source                  remove unneeded source directories"
}

error() {
	echo "$2"
	exit "$1"
}

# Parse command line options
SKIP_DOWNLOAD=false
SKIP_BUILD=false
while [ "$1" != "" ]; do
	case $1 in
		-h | --help )
			usage
			exit
		;;
		-d | --dest )
			shift
			DEST="$1"
		;;
		--make_arg )
			shift
			MAKE_ARG="--make_arg $1"
		;;
		--dryrun )
			SKIP_DOWNLOAD=true
			SKIP_BUILD=true
		;;
		--skip_download )
			SKIP_DOWNLOAD=true
		;;
		--skip_build )
			SKIP_BUILD=true
		;;
		--clean_source)
			CLEAN_SOURCE="--clean_source"
		;;
		* )
			usage
			exit 1
		;;
	esac
	shift
done

if [ ! -d "$DEST" ]; then
	echo "Invalid destination directory: $DEST"
	exit 2
fi

DEST=$(cd "$DEST" && pwd)

SKIP_ARG=""
if [ $SKIP_DOWNLOAD = true ]; then
	SKIP_ARG="$SKIP_ARG --skip_download"
fi
if [ $SKIP_BUILD = true ]; then
	SKIP_ARG="$SKIP_ARG --skip_build"
fi

# Don't clean source directories in a dry run
if ([ $SKIP_DOWNLOAD = true ] && [ $SKIP_BUILD = true ]); then
	CLEAN_SOURCE=""
fi

# Discover the directory containing this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Look for expected build tools
TOOLS="make gcc"
MISSING=0
echo "Searching for expected build tools..."
for TOOL in $TOOLS; do
	if [ $(command -v $TOOL) ]; then
		echo "$(command -v $TOOL) found: $($TOOL --version | head -1)"
	else
		echo "$TOOL NOT found"
		MISSING=$(($MISSING + 1))
	fi
done
if [ $MISSING -eq 0 ]; then
	echo "Found all expected build tools"
else
	echo "Missing $MISSING expected build tools, continuing anyway"
fi

echo "Building to $DEST"

# Create the required source and build directories
SOURCE_DIR="${DEST%/}/source/"
ARA_BUILD_DIR="${DEST%/}/ara_build/"
DEPS_BUILD_DIR="${DEST%/}/misc_build/"
ROOT_BUILD_DIR="${DEST%/}/root_build/"
if [ ! -d "$SOURCE_DIR" ]; then
	mkdir "$SOURCE_DIR"
fi
if [ ! -d "$ARA_BUILD_DIR" ]; then
	mkdir "$ARA_BUILD_DIR"
fi
if [ ! -d "$DEPS_BUILD_DIR" ]; then
	mkdir "$DEPS_BUILD_DIR"
fi
if [ ! -d "$ROOT_BUILD_DIR" ]; then
	mkdir "$ROOT_BUILD_DIR"
fi

# Run build scripts from this script's directory
cd "$SCRIPT_DIR"
./build_python3.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 100 "Failed python3 build"
#./build_miniconda.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 100 "Failed python3 build"
./build_CMake.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 101 "Failed CMake build"
./build_FFTW.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 102 "Failed FFTW build"
./build_GSL.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 103 "Failed GSL build"
./build_SQLite.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 104 "Failed SQLite build"
./build_boost.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" $SKIP_ARG $CLEAN_SOURCE || error 105 "Failed boost build"
./build_ROOT6.sh --source "$SOURCE_DIR" --build "$ROOT_BUILD_DIR" --deps "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG $CLEAN_SOURCE || error 106 "Failed ROOT6 build"
./build_libRootFftwWrapper.sh --source "$SOURCE_DIR" --build "$DEPS_BUILD_DIR" --root "$ROOT_BUILD_DIR" --deps "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG || error 107 "Failed libRootFftwWrapper build"
./build_AraRoot.sh --source "$SOURCE_DIR" --build "$ARA_BUILD_DIR" --root "$ROOT_BUILD_DIR" --deps "$DEPS_BUILD_DIR" $SKIP_ARG || error 108 "Failed AraRoot build"
./build_AraSim.sh --source "$SOURCE_DIR" --build "$ARA_BUILD_DIR" --root "$ROOT_BUILD_DIR" --deps "$DEPS_BUILD_DIR" $MAKE_ARG $SKIP_ARG || error 109 "Failed AraSim build"
./build_libnuphase.sh --source "$SOURCE_DIR" --build "$ARA_BUILD_DIR" --root "$ROOT_BUILD_DIR" --deps "$DEPS_BUILD_DIR" $SKIP_ARG || error 110 "Failed libnuphase build"
./build_nuphaseroot.sh --source "$SOURCE_DIR" --build "$ARA_BUILD_DIR" --root "$ROOT_BUILD_DIR" --deps "$DEPS_BUILD_DIR" $SKIP_ARG || error 111 "Failed nuphaseroot build"

# Hardcode destination path in the setup script
if [ $SKIP_BUILD = false ]; then
	echo "Recording installation path in setup script"
	sed -i s:/PATH/TO/THIS/SCRIPT:$DEST: "$DEST/setup.sh"
fi

echo "Finished building ARA software"
