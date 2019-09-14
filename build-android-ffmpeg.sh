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

if [ -z "$HOST" ]; then
    echo "error: undefined HOST"
    exit 1
fi

if [ $1 == "armeabi-v7a" ]; then
    EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -target thumbv7-none-linux-androideabi"
    EXTRA_LDFLAGS="-march=armv7-a --fix-cortex-a8"
    CPU=armv7-a
    ARCH=armv7-a
    PLATFORM_ARCH=arm
    LIB_FOLDER=lib
    TARGET=arm-linux-androideabi
    TOOLCHAIN_FOLDER=$TARGET
elif [ $1 == "x86" ]; then
    EXTRA_CFLAGS="-pipe -march=atom -msse3 -ffast-math -mfpmath=sse -target i686-none-linux-androideabi -mtune=intel -m32"
    EXTRA_LDFLAGS="-lm -lz --no-undefined -z noexecstack"
    CPU=i686
    ARCH=x86
    PLATFORM_ARCH=x86
    LIB_FOLDER=lib
    TARGET=i686-linux-android
    TOOLCHAIN_FOLDER=$PLATFORM_ARCH
else
    echo "error: unsupported script argument: $1"
    exit 1
fi

PREFIX=$(pwd)/FFmpeg/build-android-$1
SYSROOT=$NDK_PATH/sysroot
TOOLCHAIN=$NDK_PATH/toolchains/$TOOLCHAIN_FOLDER-$NDK_COMPILER_VERSION/prebuilt/$HOST/bin
LLVM_TOOLCHAIN=$NDK_PATH/toolchains/llvm/prebuilt/$HOST/bin
CC=$LLVM_TOOLCHAIN/clang
CXX=$LLVM_TOOLCHAIN/clang++
AS=$CC
AR=$TOOLCHAIN/$TARGET-ar
LD=$TOOLCHAIN/$TARGET-ld
STRIP=$TOOLCHAIN/$TARGET-strip
NDK_MAKE=$NDK_PATH/prebuilt/$HOST/bin/make

if [ ! -d "FFmpeg" ]; then
  git clone https://github.com/FFmpeg/FFmpeg.git
fi

cd FFmpeg
git reset --hard 1529dfb73a5157dcb8762051ec4c8d8341762478
git apply ../ffmpeg-patch.diff

$NDK_MAKE distclean > /dev/null 2>&1

./configure \
--prefix=$PREFIX \
--enable-avresample \
--enable-shared \
--enable-cross-compile \
--enable-protocol=file \
--enable-small \
--disable-asm \
--disable-debug \
--disable-stripping \
--disable-static \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-avdevice \
--disable-doc \
--disable-symver \
--disable-programs \
--target-os=android \
--sysroot=$SYSROOT \
--enable-pic \
--extra-cflags="-O3 -fPIC -I$SYSROOT/usr/include/$TARGET $EXTRA_CFLAGS" \
--extra-ldflags="-lc -L$NDK_PATH/toolchains/$TOOLCHAIN_FOLDER-$NDK_COMPILER_VERSION/prebuilt/$HOST/lib/gcc/$TARGET/$NDK_COMPILER_VERSION.x -L$NDK_PATH/platforms/android-$NDK_PLATFORM_LEVEL/arch-$PLATFORM_ARCH/usr/$LIB_FOLDER $EXTRA_LDFLAGS" \
--extra-libs=-lgcc \
--cpu=$CPU \
--arch=$ARCH \
--ar=$AR \
--strip=$STRIP \
--ld=$LD \
--cc=$CC \
--cxx=$CXX \
--as=$AS

$NDK_MAKE clean
$NDK_MAKE -j $(nproc --all)
$NDK_MAKE install
