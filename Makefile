

SHELL		= /bin/bash
.SHELLFLAGS	= -o pipefail -c

#.DEFAULT_GOAL := default


DOCKER_IMAGE = centos:8.4.2105
#DOCKER_IMAGE = ubuntu:22.04

# Ubuntu
#DOCKER_CONTAINER    = hopeful_carson
# CENTOS
DOCKER_CONTAINER    = tender_pasteur
DOCKER_INSTALL_ROOT = $(DOCKER_CONTAINER):/opt


make_docker_image:
	docker run -tid $(DOCKER_IMAGE)
	docker ps 


SS_VERSION="v7.3.1"
TRILINOS_BRANCH=trilinos-release-14-4-0
ADMS_BRANCH=release-2.3.7
CMAKE_BRANCH=v3.28.1

git_src_xyce:
	cd src && git clone https://github.com/Xyce/Xyce Xyce
	cd src && git clone https://github.com/DrTimothyAldenDavis/SuiteSparse.git -b $(SS_VERSION) suiteSparce-src
	#cd src && git clone https://github.com/trilinos/Trilinos -b $(TRILINOS_BRANCH) trilinos-src
	cd src && git clone https://github.com/Qucs/ADMS.git -b $(ADMS_BRANCH) ADMS-src
	cd src && git clone https://github.com/Kitware/CMake.git -b v3.28.1 cmake-src


default_copy_dir:
	docker cp ss_amd_config $(DOCKER_INSTALL_ROOT)
	docker cp trilinos_config $(DOCKER_INSTALL_ROOT)
	docker cp xyce_config $(DOCKER_INSTALL_ROOT)

	docker cp xyce_in_script.sh $(DOCKER_INSTALL_ROOT)
	#docker cp trilinos_cmake_build $(DOCKER_INSTALL_ROOT)

	docker exec -w /opt $(DOCKER_CONTAINER) mkdir -p /opt/xyce_src/xyce_tpl

	# Copy src code
	docker cp src/ADMS-src $(DOCKER_INSTALL_ROOT)/xyce_src/xyce_tpl
	docker cp src/suiteSparce-src $(DOCKER_INSTALL_ROOT)/xyce_src/xyce_tpl
	docker cp src/cmake-src $(DOCKER_INSTALL_ROOT)/xyce_src/xyce_tpl
	#docker cp src/trilinos-src $(DOCKER_INSTALL_ROOT)/xyce_src/xyce_tpl
	docker cp src/Xyce $(DOCKER_INSTALL_ROOT)/xyce_src


default_run_install:
	#docker exec -w /opt/xyce_src/xyce_tpl/ $(DOCKER_CONTAINER) git clone https://github.com/trilinos/Trilinos.git -b trilinos-release-14-4-0 trilinos-src
	docker exec -w /opt $(DOCKER_CONTAINER) bash xyce_in_script.sh

docker_build_from_start: default_copy_dir default_run_install

