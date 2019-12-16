#!/bin/bash
# Build script for AraRoot


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [-v version] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  -r, --root destination          location of the root build directory"
	echo "  -v, --version version           version to be installed"
	echo "  --skip_download                 AraRoot exists pre-downloaded at the source destination"
	echo "  --skip_build                    AraRoot has already been built at the build destination"
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
		-v | --version )
			shift
			VERSION="$1"
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

if [ "$ROOT_BUILD_DIR" == "" ]; then
	ROOT_BUILD_DIR="$BUILD_DIR"
fi

if [ "$VERSION" == "" ]; then
	echo "Must specify version name"
	exit 9
fi

if [ "$VERSION" == "trunk" ]; then
	GIT_VERSION="master"
else
	GIT_VERSION="$VERSION"
fi


# Download and unzip correct version of AraRoot
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading AraRoot $GIT_VERSION to $SOURCE_DIR"
	wget -q https://github.com/ara-software/AraRoot/archive/"$GIT_VERSION".tar.gz -O araroot.tar.gz
	echo "Extracting AraRoot"
	TAR_DIR=$(tar -tf araroot.tar.gz | head -1)
	tar -xzf araroot.tar.gz
	mv "$TAR_DIR" AraRoot
	rm araroot.tar.gz
fi

# Set required environment variables
export PLATFORM_DIR="${BUILD_DIR%/}"
export DYLD_LIBRARY_PATH="$PLATFORM_DIR/lib:$DYLD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$PLATFORM_DIR/lib:$LD_LIBRARY_PATH"
export PATH="$PLATFORM_DIR/bin:$PATH"
eval 'source "${ROOT_BUILD_DIR%/}"/bin/thisroot.sh'
export SQLITE_ROOT="$PLATFORM_DIR"
export GSL_ROOT="$PLATFORM_DIR"
export FFTWSYS="$PLATFORM_DIR"
export ARA_UTIL_INSTALL_DIR="${BUILD_DIR%/}"
export ARA_ROOT_DIR="${SOURCE_DIR%/}/AraRoot"
export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"

# Run AraRoot installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling AraRoot"
	cd AraRoot
	sed -i 's:#set(CMAKE_CXX_STANDARD 11):set(CMAKE_CXX_STANDARD 11):' CMakeLists.txt
	bash INSTALL.sh 1 || exit 6
fi

echo "AraRoot installed in $BUILD_DIR"
