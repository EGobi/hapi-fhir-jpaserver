FROM ubuntu:24.04

# 211,0 MB
RUN apt-get update

# 298,8 MB
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl wget gnupg fontconfig ca-certificates p11-kit binutils tzdata locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

# 302,8 MB
RUN locale-gen en_US.UTF-8
RUN rm -rf /var/lib/apt/lists/*

# 686,2 MB
RUN wget -O /tmp/openjdk.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.16%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.16_8.tar.gz
RUN wget -O /tmp/openjdk.tar.gz.sig https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.16%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.16_8.tar.gz.sig

RUN gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 3B04D753C9050D9A5D343F39843C48A565F8F04B
RUN gpg --batch --verify /tmp/openjdk.tar.gz.sig /tmp/openjdk.tar.gz