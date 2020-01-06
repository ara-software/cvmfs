#!/bin/sh
# Build script for libRootFftwWrapper

# Set script parameters
PACKAGE_NAME="libRootFftwWrapper"
DOWNLOAD_LINK="https://github.com/nichol77/libRootFftwWrapper/archive/master.tar.gz"
PACKAGE_DIR_NAME="libRootFftwWrapper"


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
	if [ -z "$SOURCE_DIR" ]; then
		SOURCE_DIR="${DEST%/}/source/"
	fi
	if [ -z "$BUILD_DIR" ]; then
		BUILD_DIR="${DEST%/}/build/"
	fi
fi

if [ -z "$ROOT_BUILD_DIR" ]; then
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
	export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
	export DYLD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$DYLD_LIBRARY_PATH"
	export PATH="$ARA_UTIL_INSTALL_DIR/bin:$PATH"
	. "${ROOT_BUILD_DIR%/}"/bin/thisroot.sh || exit 31
	export SQLITE_ROOT="$ARA_UTIL_INSTALL_DIR"
	export GSL_ROOT="$ARA_UTIL_INSTALL_DIR"
	export FFTWSYS="$ARA_UTIL_INSTALL_DIR"
	export CMAKE_PREFIX_PATH="$ARA_UTIL_INSTALL_DIR"
fi

# Run package installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling $PACKAGE_NAME"
	cd "$PACKAGE_DIR_NAME"
	sed -i 's:^find_package(FFTW REQUIRED):#find_package(FFTW REQUIRED)\
set(FFTW_LIBRARIES "$ENV{FFTWSYS}/lib/libfftw3.so.3.5.8")\
set(FFTW_INCLUDES "$ENV{FFTWSYS}/include"):' CMakeLists.txt
	sed -i 's:@ccmake:@cmake:' Makefile
	make configure "$MAKE_ARG" || exit 31
	echo "Installing $PACKAGE_NAME"
	make "$MAKE_ARG" || exit 32
	make install "$MAKE_ARG" || exit 33
fi

echo "$PACKAGE_NAME installed in $BUILD_DIR"
