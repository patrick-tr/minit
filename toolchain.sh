#!/bin/bash 

set -e

apt-get update
apt-get install -y \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        gcc-x86-64-linux-gnu g++-x86-64-linux-gnu