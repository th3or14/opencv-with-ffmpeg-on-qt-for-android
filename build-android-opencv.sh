#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "error: illegal number of script arguments"
    exit 1
fi

if [ -z "$NDK_PATH" ]; then
    echo "error: undefined NDK_PATH"
    exit 1
fi

if [ -z "$NDK_COMPILER_VERSION" ]; then
    echo "error: undefined NDK_COMPILER_VERSION"
    exit 1
fi

if [ -z "$NDK_PLATFORM_LEVEL" ]; then
    echo "error: undefined NDK_PLATFORM_LEVEL"
    exit 1
fi

if [ $1 == "armeabi-v7a" ]; then
    ANDROID_TOOLCHAIN_NAME=arm-linux-androideabi-$NDK_COMPILER_VERSION
elif [ $1 == "x86" ]; then
    ANDROID_TOOLCHAIN_NAME=x86-$NDK_COMPILER_VERSION
else
    echo "error: unsupported script argument: $1"
    exit 1
fi

BUILD_DIR="build-android-$1"

export LD_LIBRARY_PATH=$FFMPEG_SRC_DIR/$BUILD_DIR/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$FFMPEG_SRC_DIR/$BUILD_DIR/lib/pkgconfig
export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR:$FFMPEG_SRC_DIR/$BUILD_DIR/lib

if [ ! -d "opencv" ]; then
  git clone https://github.com/opencv/opencv
fi

if [ ! -d "opencv_contrib" ]; then
  git clone https://github.com/opencv/opencv_contrib
fi

git -C opencv_contrib reset --hard ced5aa760688dd2ec867ebf7bd4f0c2341d2fde5
cd opencv
git reset --hard 6ffc48769ac60d53c4bd1913eac15117c9b1c9f7
git apply ../opencv-patch.diff

mkdir -p $BUILD_DIR
cd $BUILD_DIR
git clean -d -f -x

cmake -DANDROID_TOOLCHAIN_NAME=$ANDROID_TOOLCHAIN_NAME -DANDROID_ABI=$1 -DANDROID_NATIVE_API_LEVEL=$NDK_PLATFORM_LEVEL -DCMAKE_TOOLCHAIN_FILE=$NDK_PATH/build/cmake/android.toolchain.cmake -DBUILD_opencv_world=ON -DWITH_FFMPEG=ON -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF -DBUILD_SHARED_LIBS=ON -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules ..

make clean
make -j $(nproc --all)
make install
