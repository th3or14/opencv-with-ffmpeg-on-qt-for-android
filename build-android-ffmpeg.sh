#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "error: illegal number of script arguments"
    exit 1
fi

if [ -z "$NDK_PATH" ]; then
    echo "error: undefined NDK_PATH"
    exit 1
fi

if [ -z "$NDK_PLATFORM_LEVEL" ]; then
    echo "error: undefined NDK_PLATFORM_LEVEL"
    exit 1
fi

if [ $1 == "armeabi-v7a" ]; then
    CROSS_PREFIX=$NDK_PATH/toolchains/arm-linux-androideabi-$NDK_COMPILER_VERSION/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
    SYSROOT=$NDK_PATH/platforms/android-$NDK_PLATFORM_LEVEL/arch-arm
    EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
    EXTRA_LDFLAGS="-march=armv7-a -Wl,--fix-cortex-a8"
    CPU=armv7-a
    ARCH=armv7-a
elif [ $1 == "x86" ]; then
    CROSS_PREFIX=$NDK_PATH/toolchains/x86-$NDK_COMPILER_VERSION/prebuilt/linux-x86_64/bin/i686-linux-android-
    SYSROOT=$NDK_PATH/platforms/android-$NDK_PLATFORM_LEVEL/arch-x86
    EXTRA_CFLAGS="-pipe -march=atom -msse3 -ffast-math -mfpmath=sse"
    EXTRA_LDFLAGS="-lm -lz -Wl,--no-undefined -Wl,-z,noexecstack"
    CPU=i686
    ARCH=x86
else
    echo "error: unsupported script argument: $1"
    exit 1
fi

PREFIX=$(pwd)/FFmpeg/build-android-$1

if [ ! -d "FFmpeg" ]; then
  git clone https://github.com/FFmpeg/FFmpeg.git
fi

cd FFmpeg
git reset --hard 1529dfb73a5157dcb8762051ec4c8d8341762478
git apply ../ffmpeg-patch.diff

make distclean > /dev/null 2>&1

./configure \
--prefix=$PREFIX \
--enable-avresample \
--enable-shared \
--disable-debug \
--disable-stripping \
--disable-static \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-avdevice \
--disable-doc \
--disable-symver \
--cross-prefix=$CROSS_PREFIX \
--target-os=linux \
--enable-cross-compile \
--sysroot=$SYSROOT \
--enable-pic \
--extra-cflags="-fpic $EXTRA_CFLAGS" \
--extra-ldflags="$EXTRA_LDFLAGS" \
--cpu=$CPU \
--arch=$ARCH

make clean
make -j $(nproc --all)
make install
