## Environment installation and compiling

Update CMake if necessary. Version 3.6.0 or higher is required. I built the latest stable version from source https://cmake.org/download/.

Update Qt if necessary. I installed the latest stable version from Qt Maintenance Tool.

Install JDK. Version 9 may cause some installation problems, version 8 is ok. I picked OpenJDK having executed ```apt install openjdk-8-jre openjdk-8-jdk```.

Install Yasm (FFmpeg dependency). I got it from packages: ```apt install yasm```.

Install Android Studio to get Android SDK https://developer.android.com/studio/index.html. Also create a new Android Virtual Device via **Tools > AVD Manager** if you are going to use an emulator. I accessed **Tools** after starting a new Android Studio project.

Download and unpack Android NDK https://developer.android.com/ndk/downloads/older_releases.html. Try android-ndk-r14b, some problems may occur if you choose later releases.

You also have to add the Android NDK and SDK paths in Qt Creator at **Tools > Options > Devices > Android**.

Create environment variables `OPENCV_SRC_DIR`, `FFMPEG_SRC_DIR`. Consider them to be the paths to future directories `opencv` and `FFmpeg` in a directory where you are going to execute the build scripts, e.g., directly in this repository. In order to register environment variables in my system I put these lines

```
export OPENCV_SRC_DIR="$HOME/Development/opencv-with-ffmpeg-on-qt-for-android/opencv"
export FFMPEG_SRC_DIR="$HOME/Development/opencv-with-ffmpeg-on-qt-for-android/FFmpeg"
```

to `~/.profile` and relogin.

FFmpeg is compiled with `-O3`. For OpenCV optimization level is not `-O3`, see/modify `ANDROID_COMPILER_FLAGS_RELEASE` at `build/cmake/android.toolchain.cmake` inside you NDK directory.

Now edit `NDK_PATH` inside `build.sh` and run this script to build FFmpeg and OpenCV for x86 and armeabi-v7a. Sources are downloaded automatically.

## Running the sample application

Open `sample/sample.pro` in Qt Creator. Note that this project uses your previously registered environment variables `OPENCV_SRC_DIR` and `FFMPEG_SRC_DIR` in order to obtain libraries. In case of success the application generates a sample video.

## Information about tested environment

Checked with the following configuration:

* Linux Mint 18.3

* CMake 3.11.1

* Qt 5.10.1

* OpenJDK 1.8.0_162

* Yasm 1.3.0

* Android Studio 3.1.2

* Android SDK 26.1.1

* Android NDK 14.1.3816874

* OpenCV 3.4.1

* FFmpeg 3.0.11

## Known issues

#### Text relocations warning

This issue appears on x86 only. https://trac.ffmpeg.org/ticket/4928

#### API compatibility warning

Try to downgrade your emulator's API level, i.e., create Android Virtual Device with another system image.
