#!/bin/bash
# Build script for trunk version of ARA software


usage() {
	echo "usage: $0 [-h] [-d destination] [-v version]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the build destination directory"
	echo "  -v, --version version           set the version name/number"
	echo "  --make_arg                      additional argument to be passed to make"
}

# Parse command line options
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


# Discover the directory containing this script
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "Building to $FULL_DEST"

# Let wildcards with no matches expand to empty lists
shopt -s nullglob

# Run build scripts from this script's directory
cd "$SCRIPT_DIR"
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

./build_CMake.sh --dest "$FULL_DEST" $MAKE_ARG || exit 101
./build_FFTW.sh --dest "$FULL_DEST" $MAKE_ARG || exit 102
./build_GSL.sh --dest "$FULL_DEST" $MAKE_ARG || exit 103
./build_SQLite.sh --dest "$FULL_DEST" $MAKE_ARG || exit 104
./build_boost.sh --dest "$FULL_DEST" || exit 105
./build_ROOT6.sh --dest "$FULL_DEST" --build "$ROOT_BUILD_DIR" --cmake "${BUILD_DIR%/}/bin/cmake" $MAKE_ARG || exit 106
./build_libRootFftwWrapper.sh --dest "$FULL_DEST" --root "$ROOT_BUILD_DIR" $MAKE_ARG || exit 107
./build_AraRoot.sh --dest "$FULL_DEST" --version "$VERSION" --root "$ROOT_BUILD_DIR" || exit 108
./build_AraSim.sh --dest "$FULL_DEST" --version "$VERSION" --root "$ROOT_BUILD_DIR" $MAKE_ARG || exit 109

echo "Finished building ARA software"
