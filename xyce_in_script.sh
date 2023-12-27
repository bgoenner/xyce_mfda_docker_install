
## 

INSTALL_ROOT  = xyce_src 
XYCE_SRC_ROOT = 
TPL_ROOT      = 

## check for required libraries

#
# gcc    >= 4.9 
# make   >= 
# cmake  >= 3.17
# bison  >= 3.0.4  
# flex   >= 2.5.34
# fftw    = 3.x
#
# blas   =
# lapack = 
#
# --- TPL ---
# SuiteSparce >= 2.1.1
# FFTW         = 3.x
# Trilinos     = trilinos-release-14-4-0
#

REQ_LIBRARIES = git blas lapack bison flex fttw cmake make


# Docker commands
FROM centos

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y install git



CMD /bin/bash



## clone Xyce

mkdir xyce_src
cd xyce_src

git clone https://github.com/Xyce/Xyce

## Install TPL

mkdir xyce_tpl
cd xyce_tpl

### Install Suite Sparce AMD

SS_VERSION = v7.3.1 

git clone https://github.com/DrTimothyAldenDavis/SuiteSparse.git -b v7.3.1 suiteSparce-src

# AMD install
mkdir ss-amd-build
cd ss-amd-build
../ss-amd-config
cmake --build . -t install

### Install Trilinos

TRILINOS_BRANCH = trilinos-release-14-4-0

git clone https://github.com/trilinos/Trilinos -b trilinos-release-14-4-0 trilinos-src

# Trilinos install
mkdir trilinos-build
cd trilinos-build
../trilinos-config

cmake --build . -j 2 -t install



### Build and Install Xyce
#

cd /opt/xyce-src/
mkdir xyce-build
cd xyce-build

../xyce-config
cmake --build . -j 2 -t install



