
## 

INSTALL_ROOT=/opt 
#XYCE_SRC_ROOT = 
#TPL_ROOT      = 
CMAKE_28       = ./../cmake-local/bin/cmake

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi


## check for required libraries

# 12/27/23

#		   | Cent8 |Ub22.04|
# gcc    >= 4.9    |   x   |       |
# g++    >=        |   x   |       |
# gfortan>=        |       |       |
# make   >=        | 4.2.1 |       |
# cmake  >= 3.23   |   x   |       |
# bison  >= 3.0.4  |   x   | 3.8.2 |
# flex   >= 2.5.34 |   x   |       |
# fftw    = 3.x    |   x   |       |
#
# blas   =
# lapack = 
#
# --- TPL ---
# SuiteSparce >= 2.1.1
# FFTW         = 3.x
# Trilinos     = trilinos-release-14-4-0
#


make_cmake_28 () {
    # build cmake 3.28.1
    INSTALL_CMAKE_DIR=../cmake-local

    mkdir -p $INSTALL_ROOT/xyce_src/xyce_tpl
    cd $INSTALL_ROOT/xyce_src/xyce_tpl
    #git clone https://github.com/Kitware/CMake.git -b v3.28.1 cmake-src

    mkdir cmake-local

    cd cmake-src
    ./bootstrap --prefix=$INSTALL_CMAKE_DIR && make && make install

}

make_xyce_tpl () {
	
	# AMD install
	mkdir ss_amd_build
	cd ss_amd_build
	../../../ss_amd_config
	cmake --build . -t install
	
	# Trilinos install
	cd $INSTALL_ROOT/xyce_src/xyce_tpl
	
	mkdir trilinos-build
	cd trilinos-build
	../../../trilinos_config
	
	cmake --build . -j 2 -t install

}

if [ "$OS" = "CentOS Linux" ]; then
 
    REQ_LIBRARIES="git blas blas-devel lapack lapack-devel bison bison-devel flex flex-devel fftw fftw-devel cmake make gcc gcc-c++ gcc-gfortran"

    CMAKE_LIBS="openssl openssl-devel"

    ADMS_LIBS="automake libtool gperf libxml2 libxml2-devel perl-XML-LibXML perl-GD"

    echo "OS detected: CENTOS"
    
    echo "Adding mirrors"
    cd /etc/yum.repos.d && \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
    
    yum install -y dnf-plugins-core
    yum config-manager --set-enabled powertools
    
    yum install -y epel-release
    
    echo "Install required libraries"
    yum install -y $REQ_LIBRARIES $CMAKE_LIBS $ADMS_LIBS
    
    make_cmake_28

    cd $INSTALL_ROOT/xyce_src/xyce_tpl
    git clone https://github.com/trilinos/Trilinos.git -b trilinos-release-14-4-0 trilinos-src

elif [[ "$OS" = "Ubuntu" ]]; then

    REQ_LIBRARIES="git libblas3 libblas-dev liblapack3 liblapack-dev bison flex libfftw3-bin libfftw3-dev cmake make gcc g++ gfortran-11 gfortran doxygen graphviz"

    CMAKE_LIBS="openssl libssl-dev"

    ADMS_LIBS="build-essential automake libtool gperf flex bison libxml2 libxml2-dev libxml-libxml-perl libgd-perl"

    apt-get update
    apt-get install -y $REQ_LIBRARIES $ADMS_LIBS

    make_cmake_28

    cd $INSTALL_ROOT/xyce_src/xyce_tpl
    git clone https://github.com/trilinos/Trilinos.git -b trilinos-release-14-4-0 trilinos-src


    echo "UBUNTU"
fi


#ADMS_LIBS_UB="build-essential automake libtool gperf flex bison libxml2 libxml2-dev libxml-libxml-perl libgd-perl"
# Docker commands
#FROM centos

#RUN cd /etc/yum.repos.d/
#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
#RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

#RUN yum -y install git

#CMD /bin/bash

#echo "Adding mirrors"
#cd /etc/yum.repos.d && \
#sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
#sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
#
#yum install -y dnf-plugins-core
#yum config-manager --set-enabled powertools
#
#yum install -y epel-release
#
#echo "Install required libraries"
#yum install -y $REQ_LIBRARIES $CMAKE_LIBS $ADMS_LIBS

## clone Xyce

cd $INSTALL_ROOT

mkdir xyce_src
cd xyce_src

#git clone https://github.com/Xyce/Xyce Xyce

## Install TPL

mkdir xyce_tpl
cd xyce_tpl

#SS_VERSION="v7.3.1"
#git clone https://github.com/DrTimothyAldenDavis/SuiteSparse.git -b $SS_VERSION suiteSparce-src

#TRILINOS_BRANCH=trilinos-release-14-4-0
#git clone https://github.com/trilinos/Trilinos -b $TRILINOS_BRANCH trilinos-src

#ADMS_BRANCH=release-2.3.7
#git clone https://github.com/Qucs/ADMS.git -b $ADMS_BRANCH ADMS-src

#git clone https://github.com/Kitware/CMake.git -b v3.28.1 cmake-src


### Install Suite Sparce AMD

# AMD install
mkdir ss_amd_build
cd ss_amd_build
../../../ss_amd_config
cmake --build . -j 2 -t install

### Install Trilinos

# build cmake 3.28.1
#INSTALL_CMAKE_DIR=../cmake-local
#
#cd /opt/xyce_src/xyce_tpl
#git clone https://github.com/Kitware/CMake.git -b v3.28.1 cmake-src
#
#mkdir cmake-local
#
#cd cmake-src
#./bootstrap --prefix=$INSTALL_CMAKE_DIR && make && make install
#
#../../../trilinos_cmake_build

# Trilinos install
cd $INSTALL_ROOT/xyce_src/xyce_tpl

mkdir trilinos-build
cd trilinos-build
../../../trilinos_config

$CMAKE_28 --build . -j 2 -t install

## Install AMDS
#
#ADMS_BRANCH=release-2.3.7

cd $INSTALL_ROOT/xyce_src/xyce_tpl
#git clone https://github.com/Qucs/ADMS.git -b $ADMS_BRANCH ADMS-src

cd $INSTALL_ROOT/xyce_src/xyce_tpl/ADMS-src
sh bootstrap.sh
./configure
make install


# out of date libraries
# GNU Bison
#
# req libs = wget gettext-devel
# autoconf automake autopoint flex gperf graphviz help2man texinfo valgrind

# for textinfo
# subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms

#cd /opt/xyce_src/xyce_tpl
#git clone https://github.com/akimd/bison.git -b v3.4.92 bison-src
#mkdir bison-local

#cd bison-src && git submodule update --init
#./bootstrap --prefix=./../bison-local

#./configure && make

### Build and Install Xyce
#

cd $INSTALL_ROOT/xyce_src/
mkdir xyce-build
cd xyce-build

../../xyce_config
$CMAKE_28 --build . -j 2 -t install



