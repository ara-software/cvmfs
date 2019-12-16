#!/bin/bash
# Build script for ROOT6


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --skip_download                 root-6.16.00 exists pre-downloaded at the source destination"
	echo "  --skip_build                    root-6.16.00 has already been built at the build destination"
	echo "  --make_arg			additional argument to be passed to make"
	echo "  --cmake                         which cmake to use for building"
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
		--cmake )
			shift
			CMAKE="$1"
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

if [ "$CMAKE" == "" ]; then
	CMAKE="${BUILD_DIR%/}/bin/cmake"
fi

if [ ! -f "$CMAKE" ]; then
	CMAKE=$(which cmake)
fi

# Set original directory
ORIGIN=$(pwd)

# Download and unzip root_v6.16.00
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading ROOT6 to $SOURCE_DIR"
	wget -q https://root.cern/download/root_v6.16.00.source.tar.gz
	echo "Extracting ROOT6"
	tar -xzf root_v6.16.00.source.tar.gz
	rm root_v6.16.00.source.tar.gz
fi

# Run ROOT6 installation
if [ $SKIP_BUILD = false ]; then
	echo "Configuring ROOT6"
	cd "$BUILD_DIR"
	$CMAKE -Dminuit2:bool=true "${SOURCE_DIR%/}/root-6.16.00" || exit 4
	echo "Installing ROOT6"
	make "$MAKE_ARG" || exit 5
fi

# Move back to the original directory
cd "$ORIGIN"

echo "ROOT6 installed in $BUILD_DIR"
