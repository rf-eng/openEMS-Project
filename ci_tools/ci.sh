#!/bin/bash

if which nproc > /dev/null; then
    MAKEOPTS="-j$(nproc)"
else
    MAKEOPTS="-j$(sysctl -n hw.ncpu)"
fi

########################################################################################
# general helper functions

function ci_pkg_install {
    #sudo add-apt-repository ppa:rock-core/qt4
    sudo apt-get update
    # Compiling OpenEMS may require installing the following packages:
    sudo apt-get install cmake libtinyxml-dev libcgal-dev #qt4-qmake libvtk5-qt4-dev
    # Compiling hyp2mat may require installing the following packages:
    sudo apt-get install gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool
    sudo apt-get install libhdf5-dev
    sudo apt-get install libvtk6-dev
    pip3 install Cython
    pip3 install setuptools
    pip3 install wheel
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
    $GITHUB_WORKSPACE/update_openEMS.sh $GITHUB_WORKSPACE/build_output --disable-GUI
    pip3 wheel $GITHUB_WORKSPACE/CSXCAD/python --global-option=build_ext --global-option=-L$GITHUB_WORKSPACE/build_output/lib --global-option=-I$GITHUB_WORKSPACE/build_output/include --global-option=-R$GITHUB_WORKSPACE/build_output/lib
    pip3 install $GITHUB_WORKSPACE/CSXCAD/python --global-option=build_ext --global-option=-L$GITHUB_WORKSPACE/build_output/lib --global-option=-I$GITHUB_WORKSPACE/build_output/include --global-option=-R$GITHUB_WORKSPACE/build_output/lib
    pip3 wheel $GITHUB_WORKSPACE/openEMS/python --global-option=build_ext --global-option=-L$GITHUB_WORKSPACE/build_output/lib --global-option=-I$GITHUB_WORKSPACE/build_output/include --global-option=-R$GITHUB_WORKSPACE/build_output/lib
}
