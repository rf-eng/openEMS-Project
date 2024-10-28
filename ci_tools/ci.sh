#!/bin/bash

if which nproc > /dev/null; then
    MAKEOPTS="-j$(nproc)"
else
    MAKEOPTS="-j$(sysctl -n hw.ncpu)"
fi

########################################################################################
# general helper functions

function ci_pkg_install {
    sudo apt-get update
    sudo apt-get install build-essential cmake git libhdf5-dev libvtk7-dev libboost-all-dev libcgal-dev libtinyxml-dev qtbase5-dev libvtk7-qt-dev
    sudo apt-get install gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool
    pip3 install numpy matplotlib cython==0.29.36 h5py setuptools wheel
}


########################################################################################

function ci_setup {
    ci_pkg_install
}

function ci_build {
    git submodule update --init AppCSXCAD
    git submodule update --init CSXCAD
    git submodule update --init CTB
    git submodule update --init QCSXCAD
    git submodule update --init fparser
    git submodule update --init hyp2mat
    git submodule update --init openEMS
    cd $GITHUB_WORKSPACE
    ./update_openEMS.sh $GITHUB_WORKSPACE/build_output --python

    pip3 wheel $GITHUB_WORKSPACE/CSXCAD/python --global-option=build_ext --global-option=-L$GITHUB_WORKSPACE/build_output/lib --global-option=-I$GITHUB_WORKSPACE/build_output/include --global-option=-R$GITHUB_WORKSPACE/build_output/lib
    pip3 install $GITHUB_WORKSPACE/CSXCAD/python --global-option=build_ext --global-option=-L$GITHUB_WORKSPACE/build_output/lib --global-option=-I$GITHUB_WORKSPACE/build_output/include --global-option=-R$GITHUB_WORKSPACE/build_output/lib
    pip3 wheel $GITHUB_WORKSPACE/openEMS/python --global-option=build_ext --global-option=-L$GITHUB_WORKSPACE/build_output/lib --global-option=-I$GITHUB_WORKSPACE/build_output/include --global-option=-R$GITHUB_WORKSPACE/build_output/lib
}
