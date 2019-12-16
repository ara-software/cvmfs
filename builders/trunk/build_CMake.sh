#!/bin/bash
# Build script for CMake


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --skip_download                 cmake-3.13.4 exists pre-downloaded at the source destination"
	echo "  --skip_build                    cmake-3.13.4 has already been built at the build destination"
	echo "  --make_arg                      additional argument to be passed to make"
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
		-s | --source )
			shift
			SOURCE_DIR="$1"
		;;
		-b | --build )
			shift
			BUILD_DIR="$1"
		;;
		--skip_download )
			SKIP_DOWNLOAD=true
		;;
		--skip_build )
			SKIP_BUILD=true
		;;
		--make_arg )
			shift
			MAKE_ARG="$1"
		;;
		* )
			usage
			exit 1
		;;
	esac
	shift
done

if [ "$DEST" != "" ]; then
	if [ "$SOURCE_DIR" == "" ]; then
		SOURCE_DIR="${DEST%/}/source/"
	fi
	if [ "$BUILD_DIR" == "" ]; then
		BUILD_DIR="${DEST%/}/build/"
	fi
fi

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Invalid source destination directory: $SOURCE_DIR"
	exit 2
fi
if [ ! -d "$BUILD_DIR" ]; then
	echo "Invalid build destination directory: $BUILD_DIR"
	exit 3
fi

# Download and unzip cmake-3.13.4
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading CMake to $SOURCE_DIR"
	wget -q https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
	echo "Extracting CMake"
	tar -xzf cmake-3.13.4.tar.gz
	rm cmake-3.13.4.tar.gz
fi

# Run CMake installation
if [ $SKIP_BUILD = false ]; then
	echo "Configuring CMake"
	cd cmake-3.13.4
	./configure --prefix="$BUILD_DIR" || exit 4
	echo "Installing CMake"
	gmake "$MAKE_ARG" || exit 5
	make install "$MAKE_ARG" || exit 5
fi

echo "CMake installed in $BUILD_DIR"
