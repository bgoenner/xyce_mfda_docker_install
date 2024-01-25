
FROM ubuntu:22.04
COPY . /opt/xyce_install
RUN ls /opt/xyce_install
RUN apt-get update
RUN apt-get install -y make bash
RUN cd /opt/xyce_install && make default
