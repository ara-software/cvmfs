#!/bin/bash
# Build script for libRootFftwWrapper


usage() {
        echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
        echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --skip_download                 libRootFftwWrapper exists pre-downloaded at the source destination"
	echo "  --skip_build                    libRootFftwWrapper has already been built at the build destination"
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
		SOURCE_DIR="${DEST%/}/source"
	fi
	if [ "$BUILD_DIR" == "" ]; then
		BUILD_DIR="${DEST%/}/build"
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
eval `source ${BUILD_DIR%/}/bin/thisroot.sh`
export SQLITE_ROOT="$PLATFORM_DIR"
export GSL_ROOT="$PLATFORM_DIR"
export FFTWSYS="$PLATFORM_DIR"
export ARA_UTIL_INSTALL_DIR="$BUILD_DIR"
export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$LD_LIBRARY_PATH"

# Run libRootFftwWrapper installation
if [ $SKIP_BUILD = false ]; then
	echo "Configuring libRootFftwWrapper"
	cd libRootFftwWrapper
	make configure || exit 4
	echo "Installing libRootFftwWrapper"
	make && make install || exit 5
fi

echo "libRootFftwWrapper installed in $BUILD_DIR"
