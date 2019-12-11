#!/bin/bash
# Build script for SQLite


usage() {
        echo "usage: $0 [-h] [-d destination] [-s destination] [-b destination] [--skip_download, --skip_build]"
        echo "  -h, --help                      display this help message"
	echo "  -d, --dest destination          set the destination directory (containing source and build directories)"
	echo "  -s, --source destination        set the source destination directory"
	echo "  -b, --build destination         set the build destination directory"
	echo "  --skip_download                 sqlite-autoconf-3270200 exists pre-downloaded at the source destination"
	echo "  --skip_build                    sqlite-autoconf-3270200 has already been built at the build destination"
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

# Download and unzip sqlite-autoconf-3270300
cd "$SOURCE_DIR"
if [ $SKIP_DOWNLOAD = false ]; then
	echo "Downloading SQLite to $SOURCE_DIR"
	wget -q https://sqlite.org/2019/sqlite-autoconf-3270200.tar.gz
	echo "Extracting SQLite"
	tar -xzf sqlite-autoconf-3270200.tar.gz
	rm sqlite-autoconf-3270200.tar.gz
fi

# Run SQLite installation
if [ $SKIP_BUILD = false ]; then
	echo "Configuring SQLite"
	cd sqlite-autoconf-3270200
	./configure --enable-shared --prefix="$BUILD_DIR" || exit 4
	echo "Installing SQLite"
	make && make install || exit 5
fi

echo "SQLite installed in $BUILD_DIR"
