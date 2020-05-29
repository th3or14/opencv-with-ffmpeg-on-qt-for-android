## Building the opencv libraries

- Install docker
- Run ./build.sh

## Running the sample application

- Open `sample/sample.pro` in Qt Creator
- Change `ARCHITECTURE` to the corresponding architecture for your current build
- Set `OPENCV_SRC_DIR=$PWD/opencv` environment variable ($PWD - path to directory with this README.md)
- Build and run. Device management is left on you
- In case of success the application generates a sample video.
