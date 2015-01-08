#!/bin/sh
pwd
rm -rf build
mkdir build
cd build
cmake -G "MSYS Makefiles" C:\\projects\\kauri
make
make check
