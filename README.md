## Environment installation and compiling

Install CMake. Version 3.6.0 or higher is required. I got it from packages: ```apt install cmake```.

Install Qt. I installed the latest stable version from Qt Maintenance Tool.

Install JDK version 8 (later versions may lead to some issues, e.g., Qt doesn't accept Android SDK). I picked OpenJDK having executed ```apt install openjdk-8-jre openjdk-8-jdk```.

Install Yasm (FFmpeg dependency). I got it from packages: ```apt install yasm```.

Install Android Studio to get Android SDK https://developer.android.com/studio/index.html. Handling some Android stuff without Android Studio is painful.

Download and unpack Android NDK https://developer.android.com/ndk/downloads.

You also have to add the Android NDK and SDK paths in Qt Creator at **Tools > Options > Devices > Android**. After that click **Update Installed** inside **SDK Manager** tab to accept licenses.

Create environment variables `OPENCV_SRC_DIR`, `FFMPEG_SRC_DIR`. Consider them to be the paths to future directories `opencv` and `FFmpeg` in a directory where you are going to execute the build scripts, e.g., directly in this repository. In order to register environment variables in my system I put these lines

```
export OPENCV_SRC_DIR=$HOME/opencv-with-ffmpeg-on-qt-for-android/opencv
export FFMPEG_SRC_DIR=$HOME/opencv-with-ffmpeg-on-qt-for-android/FFmpeg
```

to `~/.profile` and ran `source ~/.profile`.

Now edit `NDK_PATH` along with `ANDROID_SDK_ROOT` inside `build.sh` and run this script to build FFmpeg 4.2.1 and OpenCV 4.1.1 for x86 and armeabi-v7a using Clang. Sources are downloaded automatically.

## Running the sample application

Open `sample/sample.pro` in Qt Creator. Note that this project uses your previously registered environment variables `OPENCV_SRC_DIR` and `FFMPEG_SRC_DIR` in order to obtain libraries. In case of success the application generates a sample video.

## Known issues

#### Text relocations warning

This issue appears on x86 only. https://trac.ffmpeg.org/ticket/4928

Passing `--disable-asm` to configure script in case of x86 build is used as a workaround. The drawback is performance hit.
