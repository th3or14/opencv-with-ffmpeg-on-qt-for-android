FROM ubuntu:bionic

ARG BUILD_ARG_COMMANDLINETOOLS_VERSION=commandlinetools-linux-6200805_latest
ARG BUILD_ARG_NDK_VERSION=21.2.6472646
ARG BUILD_ARG_BUILD_TOOLS_VERSION=29.0.3

RUN apt-get update && \
apt-get dist-upgrade -y && \
apt-get install -y sudo locales && \
locale-gen en_US.UTF-8 && \
apt-get install -y curl software-properties-common git wget cmake unzip openjdk-8-jre openjdk-8-jdk pkg-config yasm && \
echo "# inside docker container you can run anything" >> /etc/sudoers && \
echo "ALL ALL = NOPASSWD: ALL" >> /etc/sudoers && \
wget https://dl.google.com/android/repository/$BUILD_ARG_COMMANDLINETOOLS_VERSION.zip && \
mkdir -p /opt/android-sdk/cmdline-tools && \
unzip $BUILD_ARG_COMMANDLINETOOLS_VERSION.zip -d /opt/android-sdk/cmdline-tools && \
rm $BUILD_ARG_COMMANDLINETOOLS_VERSION.zip && \
yes | /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager --licenses && \
/opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "platform-tools" && \
/opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "ndk;$BUILD_ARG_NDK_VERSION" && \
/opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "build-tools;$BUILD_ARG_BUILD_TOOLS_VERSION" && \
ln -s /opt/android-sdk/cmdline-tools/tools /opt/android-sdk/tools

ENV PATH=/opt/android-sdk/cmdline-tools/tools/bin/:$PATH NDK_PATH=/opt/android-sdk/ndk/$BUILD_ARG_NDK_VERSION ANDROID_SDK_ROOT=/opt/android-sdk
