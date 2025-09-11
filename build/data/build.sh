#!/bin/bash

# A shell script that will perform a build. It has to optional arguments:
#   0: The branch to build (defaults to "master")
#   1: The repository to build (defaults to "https://github.com/OpenSpace/OpenSpace")

args_array=("$@")
if [ ${#args_array[@]} -eq 0 ]; then
  args_array+=("master")
fi

if [ ${#args_array[@]} -eq 1 ]; then
  args_array+=("https://github.com/OpenSpace/OpenSpace.git")
fi

# Clone the Git repository with 8 threads. We also only want the most recent commit
git clone --recursive --jobs 8 --depth 1 --branch "${args_array[0]}" "${args_array[1]}" OpenSpacemount/OpenSpace
cd OpenSpacemount/OpenSpace && mkdir build

# Build
cmake -S . \
  -DCMAKE_BUILD_TYPE="Release" \
  -DCMAKE_CXX_COMPILER=/usr/bin/g++-13 \
  -DCMAKE_C_COMPILER=/usr/bin/gcc-13 \
  -DCMAKE_CXX_STANDARD=20 \
  -DASSIMP_BUILD_MINIZIP=1 \
  -DBUILD_TESTS=OFF -DOPENSPACE_HAVE_TESTS=OFF -DSGCT_BUILD_TESTS=OFF \
  -DOPENSPACE_DISTRO=ubuntu24.04 -DCMAKE_INSTALL_PREFIX=/usr \
  -B ./build

# Use the system's libvulkan, not the vendored one, otherwise they might conflict
cef_orig_dir=$(find ./build -path */Release/libcef.so | xargs dirname)
rm -v $cef_orig_dir/libvulkan.so.1

cmake --build build --parallel 3
cpack -G TGZ
