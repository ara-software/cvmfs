#!/bin/bash
# Build script for libRootFftwWrapper


usage() {
	echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
	echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  -r, --root destination          location of the root build directory"
	echo "  --skip_download                 libRootFftwWrapper exists pre-downloaded at the source destination"
	echo "  --skip_build                    libRootFftwWrapper has already been built at the build destination"
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

# Download and unzip libRootFftwWrapper
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading libRootFftwWrapper to $SOURCE_DIR"
	wget -q https://github.com/nichol77/libRootFftwWrapper/archive/master.tar.gz -O libRootFftwWrapper.tar.gz
	echo "Extracting libRootFftwWrapper"
	TAR_DIR=$(tar -tf libRootFftwWrapper.tar.gz | head -1)
	tar -xzf libRootFftwWrapper.tar.gz
	mv "$TAR_DIR" libRootFftwWrapper
	rm libRootFftwWrapper.tar.gz
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
export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"

# Run libRootFftwWrapper installation
if [ $SKIP_BUILD = false ]; then
	echo "Configuring libRootFftwWrapper"
	cd libRootFftwWrapper
	sed -i 's:^find_package(FFTW REQUIRED):#find_package(FFTW REQUIRED)\
set(FFTW_LIBRARIES "$ENV{FFTWSYS}/lib/libfftw3.so.3.5.8")\
set(FFTW_INCLUDES "$ENV{FFTWSYS}/include"):' CMakeLists.txt
	sed -i 's:@ccmake:@cmake:' Makefile
	make configure "$MAKE_ARG" || exit 4
	echo "Installing libRootFftwWrapper"
	make "$MAKE_ARG" || exit 5
	echo "Really installing libRootFftwWrapper"
	make install "$MAKE_ARG" || exit 5
fi

echo "libRootFftwWrapper installed in $BUILD_DIR"
