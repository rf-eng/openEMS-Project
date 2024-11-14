#!/bin/bash

cd $GITHUB_WORKSPACE

git submodule update --init AppCSXCAD
git submodule update --init CSXCAD
git submodule update --init CTB
git submodule update --init QCSXCAD
git submodule update --init fparser
git submodule update --init hyp2mat
git submodule update --init openEMS

vcpkg install tinyxml
vcpkg install hdf5
vcpkg install cgal
vcpkg install vtk --recurse

mkdir build
cd build
cmake -DBUILD_APPCSXCAD=1 -DCMAKE_INSTALL_PREFIX=$GITHUB_WORKSPACE/build_output -DWITH_MPI=0 -DCMAKE_TOOLCHAIN_FILE=/c/vcpkg/scripts/buildsystems/vcpkg.cmake ..

MSBuild.exe openEMS-Project.sln

# delvewheel





