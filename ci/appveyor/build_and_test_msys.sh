#!/bin/sh
pwd
rm -rf build
mkdir build
cd build
cmake -G "MSYS Makefiles" ..
make
make check