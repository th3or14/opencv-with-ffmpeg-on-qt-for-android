#!/bin/bash

if [ $# -ne 1 ]; then
    echo "error: illegal number of script arguments"
    exit 1
fi

if [ -z $NDK_PATH ]; then
    echo "error: undefined NDK_PATH"
    exit 1
fi

if [ -z $NDK_COMPILER_VERSION ]; then
    echo "error: undefined NDK_COMPILER_VERSION"
    exit 1
fi

if [ -z $NDK_PLATFORM_LEVEL ]; then
    echo "error: undefined NDK_PLATFORM_LEVEL"
    exit 1
fi

if [ -z $HOST ]; then
    echo "error: undefined HOST"
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

if [ $1 == armeabi-v7a ]; then
    EXTRA_CONFIGURE_FLAGS="--disable-neon --enable-asm --enable-inline-asm"
    EXTRA_CFLAGS="-target thumbv7-none-linux-androideabi"
    CPU=armv7-a
    ARCH=armv7-a
    PLATFORM_ARCH=arm
    LIB_FOLDER=lib
    TARGET=arm-linux-androideabi
    TOOLCHAIN_FOLDER=$TARGET
elif [ $1 == x86 ]; then
    EXTRA_CONFIGURE_FLAGS="--disable-neon --disable-asm --disable-inline-asm"
    EXTRA_CFLAGS="-target i686-none-linux-androideabi"
    CPU=i686
    ARCH=i686
    PLATFORM_ARCH=x86
    LIB_FOLDER=lib
    TARGET=i686-linux-android
    TOOLCHAIN_FOLDER=$PLATFORM_ARCH
elif [ $1 == arm64-v8a ]; then
    EXTRA_CONFIGURE_FLAGS="--enable-neon --enable-asm --enable-inline-asm"
    EXTRA_CFLAGS="-target aarch64-none-linux-android"
    CPU=armv8-a
    ARCH=aarch64
    PLATFORM_ARCH=arm64
    LIB_FOLDER=lib
    TARGET=aarch64-linux-android
    TOOLCHAIN_FOLDER=$TARGET
elif [ $1 == x86_64 ]; then
    EXTRA_CONFIGURE_FLAGS="--disable-neon --disable-asm --disable-inline-asm"
    EXTRA_CFLAGS="-target x86_64-none-linux-androideabi"
    CPU=x86_64
    ARCH=x86_64
    PLATFORM_ARCH=x86_64
    LIB_FOLDER=lib64
    TARGET=x86_64-linux-android
    TOOLCHAIN_FOLDER=$PLATFORM_ARCH
else
    echo "error: unsupported script argument: $1"
    exit 1
fi

PREFIX=$(pwd)/FFmpeg/build-android-$1
SYSROOT=$NDK_PATH/sysroot
TOOLCHAIN=$NDK_PATH/toolchains/$TOOLCHAIN_FOLDER-$NDK_COMPILER_VERSION/prebuilt/$HOST/bin
AS=$CC
AR=$TOOLCHAIN/$TARGET-ar
LD=$TOOLCHAIN/$TARGET-ld
STRIP=$TOOLCHAIN/$TARGET-strip

if [ ! -d FFmpeg ]; then
  git clone https://github.com/FFmpeg/FFmpeg.git
fi

cd FFmpeg
git reset --hard 1529dfb73a5157dcb8762051ec4c8d8341762478
git apply ../ffmpeg-patch.diff

mkdir -p $PREFIX
git -C $PREFIX clean -d -f -x

$NDK_MAKE distclean > /dev/null 2>&1

./configure \
$EXTRA_CONFIGURE_FLAGS \
--prefix=$PREFIX \
--enable-avresample \
--enable-cross-compile \
--enable-static \
--disable-debug \
--disable-programs \
--disable-avdevice \
--disable-doc \
--disable-symver \
--target-os=android \
--sysroot=$SYSROOT \
--enable-pic \
--extra-cflags="$EXTRA_CFLAGS -I$SYSROOT/usr/include/$TARGET" \
--extra-ldflags="-lc -L$NDK_PATH/toolchains/$TOOLCHAIN_FOLDER-$NDK_COMPILER_VERSION/prebuilt/$HOST/lib/gcc/$TARGET/$NDK_COMPILER_VERSION.x -L$NDK_PATH/platforms/android-$NDK_PLATFORM_LEVEL/arch-$PLATFORM_ARCH/usr/$LIB_FOLDER" \
--extra-libs=-lgcc \
--cpu=$CPU \
--arch=$ARCH \
--as=$AS \
--ar=$AR \
--strip=$STRIP \
--ld=$LD \
--cc=$CC \
--cxx=$CXX

sed -i "s/#define HAVE_TRUNC 0/#define HAVE_TRUNC 1/" config.h
sed -i "s/#define HAVE_TRUNCF 0/#define HAVE_TRUNCF 1/" config.h
sed -i "s/#define HAVE_RINT 0/#define HAVE_RINT 1/" config.h
sed -i "s/#define HAVE_LRINT 0/#define HAVE_LRINT 1/" config.h
sed -i "s/#define HAVE_LRINTF 0/#define HAVE_LRINTF 1/" config.h
sed -i "s/#define HAVE_ROUND 0/#define HAVE_ROUND 1/" config.h
sed -i "s/#define HAVE_ROUNDF 0/#define HAVE_ROUNDF 1/" config.h
sed -i "s/#define HAVE_CBRT 0/#define HAVE_CBRT 1/" config.h
sed -i "s/#define HAVE_CBRTF 0/#define HAVE_CBRTF 1/" config.h
sed -i "s/#define HAVE_COPYSIGN 0/#define HAVE_COPYSIGN 1/" config.h
sed -i "s/#define HAVE_ERF 0/#define HAVE_ERF 1/" config.h
sed -i "s/#define HAVE_HYPOT 0/#define HAVE_HYPOT 1/" config.h
sed -i "s/#define HAVE_ISNAN 0/#define HAVE_ISNAN 1/" config.h
sed -i "s/#define HAVE_ISFINITE 0/#define HAVE_ISFINITE 1/" config.h
sed -i "s/#define HAVE_INET_ATON 0/#define HAVE_INET_ATON 1/" config.h
sed -i "s/#define getenv(x) NULL/\\/\\/ #define getenv(x) NULL/" config.h

$NDK_MAKE clean
$NDK_MAKE -j $(nproc --all)
$NDK_MAKE install
