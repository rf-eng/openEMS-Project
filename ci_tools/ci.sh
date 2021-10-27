#!/bin/bash

if which nproc > /dev/null; then
    MAKEOPTS="-j$(nproc)"
else
    MAKEOPTS="-j$(sysctl -n hw.ncpu)"
fi

########################################################################################
# general helper functions

function ci_pkg_install {
    # Compiling OpenEMS may require installing the following packages:
    sudo apt-get install cmake qt4-qmake libtinyxml-dev libcgal-dev libvtk5-qt4-dev
    # Compiling hyp2mat may require installing the following packages:
    sudo apt-get install gengetopt help2man groff pod2pdf bison flex libhpdf-dev libtool
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
    update_openEMS.sh /build_output --disable-GUI
}
