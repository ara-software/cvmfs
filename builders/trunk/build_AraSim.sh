#!/bin/bash
# Build script for AraSim


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [-v version] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  -r, --root destination          location of the root build directory"
	echo "  -v, --version version           version to be installed"
	echo "  --skip_download                 AraSim exists pre-downloaded at the source destination"
	echo "  --skip_build                    AraSim has already been built at the build destination"
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


# Download and unzip correct version of AraSim
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading AraSim $GIT_VERSION to $SOURCE_DIR"
	wget -q https://github.com/ara-software/AraSim/archive/"$GIT_VERSION".tar.gz -O arasim.tar.gz
	echo "Extracting AraSim"
	TAR_DIR=$(tar -tf arasim.tar.gz | head -1)
	tar -xzf arasim.tar.gz
	mv "$TAR_DIR" AraSim
	rm arasim.tar.gz
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
export BOOST_ROOT="$PLATFORM_DIR"
export ARA_UTIL_INSTALL_DIR="${BUILD_DIR%/}"
export ARA_ROOT_DIR="${SOURCE_DIR%/}/AraRoot"
export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"

# Run AraSim installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling AraSim"
	cd AraSim
	make "$MAKE_ARG" || exit 6
	make "$MAKE_ARG" -f M.readTree || exit 6
	make "$MAKE_ARG" -f M.readGeom || exit 6
	cp AraSim "${BUILD_DIR%/}/bin/AraSim"
	cp readTree "${BUILD_DIR%/}/bin/readTree"
	cp readGeom "${BUILD_DIR%/}/bin/readGeom"
fi

echo "AraSim installed in $BUILD_DIR"
