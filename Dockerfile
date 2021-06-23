FROM ubuntu:20.10 as builder
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget sudo

#Installing Firebase Tools CLI
RUN curl -sL https://firebase.tools | bash

#Installing Sentry CLI
RUN curl -sL https://sentry.io/get-cli/ | bash

# Set up new user
RUN useradd -ms /bin/bash mandalorian
USER mandalorian
WORKDIR /home/mandalorian

#Installing Android SDK
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT home/mandalorian/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/mandalorian/Android/sdk/platform-tools"

#Installing Flutter SDK
RUN git clone --branch 2.0.5 --depth=1 https://github.com/flutter/flutter
ENV PATH "$PATH:/home/mandalorian/flutter/bin"
RUN flutter config  --no-analytics
RUN flutter precache
RUN yes "y" | flutter doctor --android-licenses
RUN flutter doctor -v

