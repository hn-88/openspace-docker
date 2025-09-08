FROM ubuntu:24.04

RUN apt update


# Get a supported version for CMake and install
RUN apt install -y wget
RUN wget https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0-linux-x86_64.sh -q -O /tmp/cmake-install.sh
RUN chmod u+x /tmp/cmake-install.sh
RUN mkdir /opt/cmake
RUN /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake
RUN ln -s /opt/cmake/bin/* /usr/local/bin


# Set up the compiler
RUN apt install -y build-essential
RUN apt install -y git


## Install GCC 13 and enable
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/ppa
RUN apt update

RUN apt install -y gcc-13 g++-13


# Install the remaining OpenSpace dependencies
RUN apt-get install -y \
    build-essential \
    ninja-build \
    qt6-base-dev \
    libvulkan-dev \
    libpng-dev \
    libx11-dev \
    libxcursor-dev \
    libxrandr-dev \
    libxi-dev \
    libglu1-mesa-dev \
    zlib1g-dev

# Install dependencies for running unit tests
RUN apt install -y xvfb


# Setting up the enviroment so that we can quickly build OpenSpace from the container
ENV CMAKE_EXPORT_COMPILE_COMMANDS=1
COPY data/build.sh /
RUN chmod +x /build.sh
