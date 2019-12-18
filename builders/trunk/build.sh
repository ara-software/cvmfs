#!/bin/bash
# Build script for trunk version of ARA software


usage() {
	echo "usage: $0 [-h] [-d destination] [-v version] [--make_arg argument] [--dryrun, --skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the build destination directory"
	echo "  -v, --version version           set the version name/number"
	echo "  --make_arg argument             additional argument to be passed to make"
	echo "  --dryrun                        dryrun of all build scripts"
	echo "  --skip_download                 skip download steps of build scripts"
	echo "  --skip_build                    skip build steps of build scripts"
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
		-v | --version )
			shift
			VERSION="$1"
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

if [ "$VERSION" != "" ]; then
	FULL_DEST="${DEST%/}/$VERSION"
	if [ ! -d "$FULL_DEST" ]; then
		mkdir "$FULL_DEST"
	fi
else
	FULL_DEST="$DEST"
fi

echo "Building to $FULL_DEST"

SKIP_ARG=""
if [ $SKIP_DOWNLOAD = true ]; then
	SKIP_ARG="$SKIP_ARG --skip_download"
fi
if [ $SKIP_BUILD = true ]; then
	SKIP_ARG="$SKIP_ARG --skip_build"
fi

# Discover the directory containing this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Create the required source and build directories
SOURCE_DIR="${FULL_DEST%/}/source/"
BUILD_DIR="${FULL_DEST%/}/build/"
ROOT_BUILD_DIR="${FULL_DEST%/}/root_build/"
if [ ! -d "$SOURCE_DIR" ]; then
	mkdir "$SOURCE_DIR"
fi
if [ ! -d "$BUILD_DIR" ]; then
	mkdir "$BUILD_DIR"
fi
if [ ! -d "$ROOT_BUILD_DIR" ]; then
	mkdir "$ROOT_BUILD_DIR"
fi

# Run build scripts from this script's directory
cd "$SCRIPT_DIR"
./build_CMake.sh --dest "$FULL_DEST" $MAKE_ARG $SKIP_ARG || error 101 "Failed CMake build"
./build_FFTW.sh --dest "$FULL_DEST" $MAKE_ARG $SKIP_ARG || error 102 "Failed FFTW build"
./build_GSL.sh --dest "$FULL_DEST" $MAKE_ARG $SKIP_ARG || error 103 "Failed GSL build"
./build_SQLite.sh --dest "$FULL_DEST" $MAKE_ARG $SKIP_ARG || error 104 "Failed SQLite build"
./build_boost.sh --dest "$FULL_DEST" $SKIP_ARG || error 105 "Failed boost build"
./build_ROOT6.sh --dest "$FULL_DEST" --root "$ROOT_BUILD_DIR" $MAKE_ARG $SKIP_ARG || error 106 "Failed ROOT6 build"
./build_libRootFftwWrapper.sh --dest "$FULL_DEST" --root "$ROOT_BUILD_DIR" $MAKE_ARG $SKIP_ARG || error 107 "Failed libRootFftwWrapper build"
./build_AraRoot.sh --dest "$FULL_DEST" --root "$ROOT_BUILD_DIR" $SKIP_ARG || error 108 "Failed AraRoot build"
./build_AraSim.sh --dest "$FULL_DEST" --root "$ROOT_BUILD_DIR" $MAKE_ARG $SKIP_ARG || error 109 "Failed AraSim build"

echo "Finished building ARA software"
