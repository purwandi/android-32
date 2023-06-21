FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ENV ANDROID_HOME      /opt/android-sdk-linux
ENV ANDROID_SDK_HOME  ${ANDROID_HOME}
ENV ANDROID_SDK_ROOT  ${ANDROID_HOME}
ENV ANDROID_SDK       ${ANDROID_HOME}

ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/tools/bin"
ENV PATH "${PATH}:${ANDROID_HOME}/build-tools/32.0.0"
ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools"
ENV PATH "${PATH}:${ANDROID_HOME}/emulator"
ENV PATH "${PATH}:${ANDROID_HOME}/bin"

RUN dpkg --add-architecture i386 && \
    apt-get update -yqq && \
    apt-get install -y curl expect git libc6:i386 libgcc1:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 openjdk-11-jdk wget unzip vim && \
    apt-get clean

RUN groupadd android && useradd -d /opt/android-sdk-linux -g android android

WORKDIR /opt/android-sdk-linux

COPY tools /opt/tools
COPY licenses /opt/licenses

RUN /opt/tools/entrypoint.sh built-in

RUN sdkmanager "cmdline-tools;latest"
RUN sdkmanager "build-tools;32.0.0"
RUN sdkmanager "platform-tools"
RUN sdkmanager "platforms;android-32"
RUN sdkmanager "system-images;android-32;google_apis;x86_64"
RUN sdkmanager "ndk;21.4.7075529"

CMD /opt/tools/entrypoint.sh built-in
RUN sdkmanager --list_installed