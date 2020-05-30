#!/bin/bash

# NDK_PATH and ANDROID_SDK_ROOT are declared in Dockerfile

export NDK_COMPILER_VERSION=4.9
export NDK_PLATFORM_LEVEL=23
export HOST=linux-x86_64
export CC=$NDK_PATH/toolchains/llvm/prebuilt/$HOST/bin/clang
export CXX=$NDK_PATH/toolchains/llvm/prebuilt/$HOST/bin/clang++
export NDK_MAKE=$NDK_PATH/prebuilt/$HOST/bin/make

export OPENCV_SRC_DIR=$PWD/opencv
export FFMPEG_SRC_DIR=$PWD/FFmpeg

for i in armeabi-v7a x86 arm64-v8a x86_64
do
    ./build-android-ffmpeg.sh $i && ./build-android-opencv.sh $i
done
