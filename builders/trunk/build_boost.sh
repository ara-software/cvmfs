#!/bin/sh
# Build script for boost

# Set script parameters
PACKAGE_NAME="boost"
DOWNLOAD_LINK="https://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.gz"
PACKAGE_DIR_NAME="boost_1_55_0"


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --skip_download                 $PACKAGE_NAME exists pre-downloaded at the source destination"
	echo "  --skip_build                    $PACKAGE_NAME has already been built at the build destination"
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
	if [ -z "$SOURCE_DIR" ]; then
		SOURCE_DIR="${DEST%/}/source/"
	fi
	if [ -z "$BUILD_DIR" ]; then
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

# Download and unzip the package
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading $PACKAGE_NAME to $SOURCE_DIR"
	wget "$DOWNLOAD_LINK" -O "$PACKAGE_DIR_NAME.tar.gz" || exit 11
	echo "Extracting $PACKAGE_NAME"
	mkdir "$PACKAGE_DIR_NAME"
	tar -xzf "$PACKAGE_DIR_NAME.tar.gz" -C "$PACKAGE_DIR_NAME" --strip-components=1 || exit 12
	rm "$PACKAGE_DIR_NAME.tar.gz"
fi

# Run package installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling $PACKAGE_NAME"
	cd "$PACKAGE_DIR_NAME"
	./bootstrap.sh --without-libraries=python --prefix="${BUILD_DIR%/}" || exit 31
	echo "Installing $PACKAGE_NAME"
	./bjam install || exit 32
fi

echo "$PACKAGE_NAME installed in $BUILD_DIR"
