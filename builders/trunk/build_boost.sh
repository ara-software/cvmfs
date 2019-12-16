#!/bin/bash
# Build script for boost


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --skip_download                 boost_1_55_0 exists pre-downloaded at the source destination"
	echo "  --skip_build                    boost_1_55_0 has already been built at the build destination"
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

# Set original directory
ORIGIN=$(pwd)

# Download and unzip boost_1_55_0
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading boost to $SOURCE_DIR"
	wget -q https://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.gz
	echo "Extracting boost"
	tar -xzf boost_1_55_0.tar.gz
	rm boost_1_55_0.tar.gz
fi

# Run boost installation
if [ $SKIP_BUILD = false ]; then
	echo "Configuring boost"
	cd "${SOURCE_DIR%/}/boost_1_55_0"
	./bootstrap.sh --prefix="${BUILD_DIR%/}" || exit 4
	echo "Installing boost"
	./bjam install || exit 5
fi

# Move back to the original directory
cd "$ORIGIN"

echo "boost installed in $BUILD_DIR"
