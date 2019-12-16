#!/bin/bash
# Build script for ROOT6

# Set script parameters
PACKAGE_NAME="ROOT6"
DOWNLOAD_LINK="https://root.cern/download/root_v6.16.00.source.tar.gz"
PACKAGE_DIR_NAME="root-6.16.00"


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--cmake executable] [--make_arg argument] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --cmake executable              which cmake to use for building"
	echo "  --make_arg argument             additional argument to be passed to make"
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

# Set required environment variables
if [ $SKIP_BUILD = false ]; then
	export PLATFORM_DIR="${BUILD_DIR%/}"
	export DYLD_LIBRARY_PATH="$PLATFORM_DIR/lib:$DYLD_LIBRARY_PATH"
	export LD_LIBRARY_PATH="$PLATFORM_DIR/lib:$LD_LIBRARY_PATH"
	export PATH="$PLATFORM_DIR/bin:$PATH"
	export SQLITE_ROOT="$PLATFORM_DIR"
	export GSL_ROOT="$PLATFORM_DIR"
	export FFTWSYS="$PLATFORM_DIR"
fi

# Run package installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling $PACKAGE_NAME"
	cd "$BUILD_DIR"
	$CMAKE -Dminuit2:bool=true "${SOURCE_DIR%/}/$PACKAGE_DIR_NAME" || exit 31
	echo "Installing $PACKAGE_NAME"
	make "$MAKE_ARG" || exit 32
fi

echo "$PACKAGE_NAME installed in $BUILD_DIR"
