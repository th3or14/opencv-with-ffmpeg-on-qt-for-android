## Environment installation and compiling

Install CMake. Version 3.6.0 or higher is required. I got it from packages: ```apt install cmake```.

Install Qt. I installed the latest stable version from Qt Maintenance Tool.

Install JDK. I picked OpenJDK having executed ```apt install openjdk-11-jre openjdk-11-jdk```.

Install Yasm (FFmpeg dependency). I got it from packages: ```apt install yasm```.

Install Android Studio to get Android SDK https://developer.android.com/studio/index.html. Handling some Android stuff without Android Studio is painful.

Download and unpack Android NDK https://developer.android.com/ndk/downloads.

You also have to add the Android NDK and SDK paths in Qt Creator at **Tools > Options > Devices > Android**.

Create environment variables `OPENCV_SRC_DIR`, `FFMPEG_SRC_DIR`. Consider them to be the paths to future directories `opencv` and `FFmpeg` in a directory where you are going to execute the build scripts, e.g., directly in this repository. In order to register environment variables in my system I put these lines

```
export OPENCV_SRC_DIR="$HOME/Development/opencv-with-ffmpeg-on-qt-for-android/opencv"
export FFMPEG_SRC_DIR="$HOME/Development/opencv-with-ffmpeg-on-qt-for-android/FFmpeg"
```

to `~/.profile` and relogin.

Now edit `NDK_PATH` inside `build.sh` and run this script to build FFmpeg 4.2.1 and OpenCV 4.1.1 for x86 and armeabi-v7a. Sources are downloaded automatically.

## Running the sample application

Open `sample/sample.pro` in Qt Creator. Note that this project uses your previously registered environment variables `OPENCV_SRC_DIR` and `FFMPEG_SRC_DIR` in order to obtain libraries. In case of success the application generates a sample video.

## Known issues

#### Text relocations warning

This issue appears on x86 only. https://trac.ffmpeg.org/ticket/4928
