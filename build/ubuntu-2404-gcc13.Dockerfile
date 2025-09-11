FROM ubuntu:24.04

RUN apt update


# Get a supported version for CMake and install
RUN apt install -y wget
# Make sure no stray cmake is present
RUN rm -fv /usr/bin/cmake /usr/bin/cpack /usr/local/bin/cmake /usr/local/bin/cpack

# Install Ubuntu’s cmake
RUN apt install -y cmake

# Set up the compiler
RUN apt install -y \
 build-essential \
 software-properties-common \
 git \
 libssl-dev \
 libarchive-dev \
 ca-certificates


## Install GCC 13 and enable
RUN apt install -y gcc-13 g++-13 \
  pkg-config \
  libpthread-stubs0-dev \
  libstdc++-13-dev


# Install the remaining OpenSpace dependencies
RUN apt install -y \
  freeglut3-dev \
  glew-utils\
  libpng-dev \
  libxrandr-dev \
  libxinerama-dev \
  xorg-dev \
  libxcursor-dev \
  libcurl4-openssl-dev \
  libxi-dev \
  libasound2-dev \
  libgdal-dev \
  libboost-all-dev \
  qt6-base-dev \
  libmpv-dev \
  libvulkan-dev \
  libasound2t64

# Install dependencies for running unit tests
RUN apt install -y xvfb

# Install dependencies for creating packages
RUN apt install -y fakeroot


# Setting up the enviroment so that we can quickly build OpenSpace from the container
ENV CMAKE_EXPORT_COMPILE_COMMANDS=1
COPY data/build.sh /
RUN chmod +x /build.sh
