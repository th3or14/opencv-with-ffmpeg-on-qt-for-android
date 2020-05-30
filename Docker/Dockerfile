FROM ubuntu:bionic

# Generate locale.
RUN apt-get update
RUN apt-get dist-upgrade --yes
RUN apt-get install --yes sudo locales
RUN locale-gen en_US.UTF-8
RUN apt-get install -y curl
RUN apt-get install -y software-properties-common
RUN apt-get install -y git
RUN apt-get install -y wget
RUN apt-get install -y cmake
RUN apt-get install -y unzip
RUN apt-get install -y openjdk-8-jre openjdk-8-jdk
RUN apt-get install -y pkg-config

RUN echo "# inside docker container you can run anything" >> /etc/sudoers
RUN echo "ALL ALL = NOPASSWD: ALL" >> /etc/sudoers

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
RUN mkdir -p /opt/android-sdk/cmdline-tools
RUN unzip commandlinetools-linux-6200805_latest.zip -d /opt/android-sdk/cmdline-tools
RUN rm commandlinetools-linux-6200805_latest.zip

RUN yes | /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager --licenses
RUN /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "platform-tools"
RUN /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "ndk;21.2.6472646"
RUN /opt/android-sdk/cmdline-tools/tools/bin/sdkmanager "build-tools;29.0.3"

RUN ln -s /opt/android-sdk/cmdline-tools/tools /opt/android-sdk/tools
ENV PATH /opt/android-sdk/cmdline-tools/tools/bin/:$PATH
