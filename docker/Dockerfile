FROM ubuntu:bionic

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y sudo locales && locale-gen en_US.UTF-8 && apt-get install -y curl software-properties-common git wget cmake unzip openjdk-8-jre openjdk-8-jdk pkg-config yasm && \
echo "# inside docker container you can run anything" >> /etc/sudoers && \
echo "ALL ALL = NOPASSWD: ALL" >> /etc/sudoers && \
wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip && \
mkdir -p /opt/android-sdk/cmdline-tools && \
unzip commandlinetools-linux-6200805_latest.zip -d /opt/android-sdk/cmdline-tools && \
rm commandlinetools-linux-6200805_latest.zip && \
yes | /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager --licenses && \
/opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "platform-tools" && \
/opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "ndk;21.2.6472646" && \
/opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "build-tools;29.0.3" && \
ln -s /opt/android-sdk/cmdline-tools/tools /opt/android-sdk/tools

ENV PATH=/opt/android-sdk/cmdline-tools/tools/bin/:$PATH NDK_PATH=/opt/android-sdk/ndk/21.2.6472646 ANDROID_SDK_ROOT=/opt/android-sdk
