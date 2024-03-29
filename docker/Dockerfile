
FROM ubuntu:22.04

RUN apt-get update

Run apt-get install -y libssl-dev 

# Xyce software
RUN apt-get install -y git libblas3 libblas-dev liblapack3 liblapack-dev bison flex libfftw3-bin libfftw3-dev cmake make gcc g++ gfortran-11

# ADMS libs
RUN apt-get install -y build-essential automake libtool gperf flex bison libxml2 libxml2-dev libxml-libxml-perl libgd-perl

# Make lib to get libssl-dev
#Run apt-get install -y libssl-dev 

RUN mkdir -p /opt/xyce_src/xyce_tpl

# need from Trilinos
RUN ln -s /usr/bin/python /usr/bin/python3

#RUN cd /opt/xyce_src/ && git clone https://github.com/Xyce/Xyce Xyce

#RUN cd /opt/xyce_src/xyce_tpl/ && \
#    git clone https://github.com/DrTimothyAldenDavis/SuiteSparse.git -b v7.3.1 suiteSparce-src && \
#    git clone https://github.com/trilinos/Trilinos -b trilinos-release-14-4-0 trilinos-src && \
#    git clone https://github.com/Qucs/ADMS.git -b release-2.3.7 ADMS-src && \
#    git clone https://github.com/Kitware/CMake.git -b v3.28.1 cmake-src

COPY ../src/suiteSparce-src /opt/xyce_src/xyce_tpl
COPY ../src/cmake-src       /opt/xyce_src/xyce_tpl
# trilinos needs to be pulled from github
#COPY ../src/trilinos-src    /opt/xyce_src/xyce_tpl
COPY ../src/ADMS-src        /opt/xyce_src/xyce_tpl
COPY ../src/Xyce            /opt/xyce_src/

RUN git clone https://github.com/trilinos/Trilinos -b trilinos-release-14-4-0 trilinos-src

COPY ../ss_amd_config        /opt/xyce_src
COPY ../trilinos_config      /opt/xyce_src
COPY ../trilinos_cmake_build /opt/xyce_src
COPY ../xyce_config          /opt/xyce_src

RUN mkdir -p /opt/xyce_src/xyce_tpl/ss_amd_build
RUN cd /opt/xyce_src/xyce_tpl/ss_amd_build && \
    ../../ss_amd_config && \
    cmake --build . -t install

RUN mkdir -p /opt/xyce_src/xyce_tpl/cmake-local
RUN cd /opt/xyce_src/xyce_tpl/cmake-src/ && \
    ./bootstrap --prefix=../cmake-local && \
    make && \
    make install

## Build trilinos
RUN mkdir -p /opt/xyce_src/xyce_tpl/trilinos-build
RUN cd /opt/xyce_src/xyce_tpl/trilinos-build/ && \
    /../../trillinos_config && \
    /opt/xyce_src/xyce_tpl/cmake-local/cmake --build . -j 2 -t install

RUN cd /opt/xyce_src/ADMS-src/ && \
    bootstrap.sh && \
    ./configure && \
    make install

RUN mkdir -p /opt/xyce_src/xyce-build
RUN cd /opt/xyce_src/xyce-build && \
    ../xyce_config && \
    cmake build . -j 2 -t install

