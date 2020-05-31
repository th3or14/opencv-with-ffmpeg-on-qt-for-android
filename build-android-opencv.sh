#!/bin/bash

if [ $# -ne 1 ]; then
    echo "error: illegal number of script arguments"
    exit 1
fi

if [ -z $NDK_PATH ]; then
    echo "error: undefined NDK_PATH"
    exit 1
fi

if [ -z $NDK_PLATFORM_LEVEL ]; then
    echo "error: undefined NDK_PLATFORM_LEVEL"
    exit 1
fi

if [ -z $ANDROID_SDK_ROOT ]; then
    echo "error: undefined ANDROID_SDK_ROOT"
    exit 1
fi

if [ -z $CC ]; then
    echo "error: undefined CC"
    exit 1
fi

if [ -z $CXX ]; then
    echo "error: undefined CXX"
    exit 1
fi

if [ -z $NDK_MAKE ]; then
    echo "error: undefined NDK_MAKE"
    exit 1
fi

BUILD_DIR=build-android-$1
FFMPEG_PATH=$FFMPEG_SRC_DIR/$BUILD_DIR

export LD_LIBRARY_PATH=$FFMPEG_PATH/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$FFMPEG_PATH/lib/pkgconfig
export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR:$FFMPEG_PATH/lib

ADDITIONAL_FFMPEG_DEFINES="-DFFMPEG_INCLUDE_DIRS=$FFMPEG_PATH/include -Dpkgcfg_lib_FFMPEG_avformat=$FFMPEG_PATH/lib/libavformat.a -Dpkgcfg_lib_FFMPEG_avcodec=$FFMPEG_PATH/lib/libavcodec.a -Dpkgcfg_lib_FFMPEG_avutil=$FFMPEG_PATH/lib/libavutil.a -Dpkgcfg_lib_FFMPEG_swscale=$FFMPEG_PATH/lib/libswscale.a -Dpkgcfg_lib_FFMPEG_libavresample_avresample=$FFMPEG_PATH/lib/libavresample.a -Dpkgcfg_lib_FFMPEG_swresample=$FFMPEG_PATH/lib/libswresample.a -Dpkgcfg_lib_FFMPEG_libavresample_avutil=$FFMPEG_PATH/lib/libavutil.a"

if [ ! -d opencv ]; then
  git clone https://github.com/opencv/opencv
fi

if [ ! -d opencv_contrib ]; then
  git clone https://github.com/opencv/opencv_contrib
fi

git -C opencv_contrib reset --hard 83e98d2424bbe3854d4686dc6c9cf9a15812e8d7
cd opencv
git reset --hard 4c71dbf0af70e8728b8a791695b083540af72887
git apply ../opencv-patch.diff

mkdir -p $BUILD_DIR
cd $BUILD_DIR
git clean -d -f -x

cmake -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-Bsymbolic $ADDITIONAL_FFMPEG_DEFINES -DANDROID_ABI=$1 -DANDROID_NATIVE_API_LEVEL=$NDK_PLATFORM_LEVEL -DCMAKE_TOOLCHAIN_FILE=$NDK_PATH/build/cmake/android.toolchain.cmake -DBUILD_opencv_world=ON -DWITH_FFMPEG=ON -DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON -DBUILD_ZLIB=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF -DBUILD_opencv_apps=OFF -DBUILD_ANDROID_EXAMPLES=OFF -DBUILD_SHARED_LIBS=ON -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules ..

$NDK_MAKE clean
$NDK_MAKE -j $(nproc --all)
$NDK_MAKE install
