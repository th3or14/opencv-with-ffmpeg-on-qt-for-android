## Building the OpenCV libraries

- Install Docker
- Supported architectures are listed in `build-wrapper.sh`, you are free to reduce the list there according to your needs
- Run `./build.sh`

## Running the sample application

- Qt kits and devices management is left on you, check out `Docker/Dockerfile` for versions of JDK, Android SDK and Android NDK used to build
- Open `sample/sample.pro` in Qt Creator
- Change `ARCHITECTURE` to the corresponding architecture for your current build
- Set `OPENCV_SRC_DIR=$PWD/opencv` environment variable, where `$PWD` is a path to directory with this `README.md`
- Build and run
- In case of success the application generates a sample video
