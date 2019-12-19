#!/bin/bash
# Build script for AraSim

# Set script parameters
PACKAGE_NAME="AraSim"
DOWNLOAD_LINK="https://github.com/ara-software/AraSim/archive/master.tar.gz"
PACKAGE_DIR_NAME="AraSim"


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [-r destination] [--make_arg argument] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  -r, --root destination          set the root build destination directory"
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
		-r | --root )
			shift
			ROOT_BUILD_DIR="$1"
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

if [ "$ROOT_BUILD_DIR" == "" ]; then
	ROOT_BUILD_DIR="$BUILD_DIR"
fi

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Invalid source destination directory: $SOURCE_DIR"
	exit 2
fi
if [ ! -d "$BUILD_DIR" ]; then
	echo "Invalid build destination directory: $BUILD_DIR"
	exit 3
fi
if [ ! -d "$ROOT_BUILD_DIR" ]; then
	echo "Invalid root build destination directory: $ROOT_BUILD_DIR"
	exit 4
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
	export ARA_UTIL_INSTALL_DIR="${BUILD_DIR%/}"
	export ARA_ROOT_DIR="${SOURCE_DIR%/}/AraRoot"
	export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
	export DYLD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$DYLD_LIBRARY_PATH"
	export PATH="$ARA_UTIL_INSTALL_DIR/bin:$PATH"
	source "${ROOT_BUILD_DIR%/}"/bin/thisroot.sh || exit 21
	export BOOST_ROOT="$ARA_UTIL_INSTALL_DIR"
fi

# Run package installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling $PACKAGE_NAME"
	cd "$PACKAGE_DIR_NAME"
	make "$MAKE_ARG" || exit 31
	make "$MAKE_ARG" -f M.readTree || exit 32
	make "$MAKE_ARG" -f M.readGeom || exit 33
	cp AraSim "${BUILD_DIR%/}/bin/AraSim"
	cp readTree "${BUILD_DIR%/}/bin/readTree"
	cp readGeom "${BUILD_DIR%/}/bin/readGeom"
fi

echo "$PACKAGE_NAME installed in $BUILD_DIR"
