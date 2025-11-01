#!/bin/sh

set -e

# Build for AMD64
cmake -S . -B build-amd64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain-x86-64.cmake
cmake --build build-amd64

# Build for ARM64
cmake -S . -B build-arm64 -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=toolchain-arm64.cmake
cmake --build build-arm64
