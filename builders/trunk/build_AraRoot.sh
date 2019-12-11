#!/bin/bash
# Build script for AraRoot


usage() {
        echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [-v version] [--skip_download, --skip_build]"
        echo "  -h, --help                      display this help message"
        echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
        echo "  -s, --source destination        set the source destination directory"
        echo "  -b, --build destination         set the build destination directory"
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

# Run AraRoot installation
if [ $SKIP_BUILD = false ]; then
	echo "Compiling AraRoot"
	cd AraRoot
	export ARA_UTIL_INSTALL_DIR="$BUILD_DIR"
	export ARA_ROOT_DIR="${SOURCE_DIR%/}/AraRoot"
	bash INSTALL.sh 1 || exit 6
fi

echo "AraRoot installed in $BUILD_DIR"
