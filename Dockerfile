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
RUN rm -rf /tmp/openjdk.tar.gz.sig
RUN echo "166774efcf0f722f2ee18eba0039de2d685b350ee14d7b69e6f83437dafd2af1 */tmp/openjdk.tar.gz" | sha256sum -c -
RUN mkdir -p /opt/java/openjdk

# 1,2 GB
RUN tar --extract --file /tmp/openjdk.tar.gz --directory /opt/java/openjdk --strip-components 1 --no-same-owner
RUN rm -f /tmp/openjdk.tar.gz /opt/java/openjdk/lib/src.zip
RUN find "/opt/java/openjdk/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf
RUN ldconfig

ENV PATH=/opt/java/openjdk/bin:$PATH
RUN java -Xshare:dump
RUN fileEncoding="$(echo 'System.out.println(System.getProperty("file.encoding"))' | jshell -s -)"
RUN [ "$fileEncoding" = 'UTF-8' ]