FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG C.UTF-8

ARG INSTALL_ZSH="true"

RUN apt-get update --fix-missing

# Install Verilator 5+ (4 is not sufficient)

RUN apt-get -y install git help2man perl python3 python3-dev make autoconf g++ flex bison ccache

RUN apt-get -y install libgoogle-perftools-dev numactl perl-doc

RUN apt-get -y install libfl2

RUN apt-get -y install libfl-dev

RUN apt-get -y install zlib1g zlib1g-dev

RUN git clone https://github.com/verilator/verilator

RUN cd verilator && git pull && git checkout v5.020

RUN cd verilator && autoconf && ./configure && make -j `nproc` && make install

# Install netlist viewer

RUN apt-get -y install npm

RUN git clone https://github.com/nturley/netlistsvg

RUN cd netlistsvg && npm install --legacy-peer-deps && npm install -g .

# Install iverilog v12

RUN apt-get -y install autoconf gperf flex bison

RUN git clone https://github.com/steveicarus/iverilog.git

RUN cd iverilog && git fetch && git checkout v12_0

RUN cd iverilog && sh autoconf.sh && ./configure && make && make install

# Install zachjs-sv2v
RUN apt-get install -y wget unzip

RUN wget https://github.com/zachjs/sv2v/releases/download/v0.0.13/sv2v-Linux.zip

RUN unzip sv2v-Linux.zip && rm -f sv2v-Linux.zip && mv sv2v-Linux zachjs-sv2v

RUN ln -s "$PWD/zachjs-sv2v/sv2v" /usr/local/bin/sv2v

RUN sv2v --version

# Install pre-built tools

RUN apt-get -y install gtkwave

#RUN apt-get -y install nextpnr-ice40-qt Too old.

RUN apt-get -y install fpga-icestorm fpga-icestorm-chipdb

# Install nextpnr

RUN apt-get -y install cmake libboost-all-dev libeigen3-dev

RUN git clone https://github.com/YosysHQ/nextpnr.git

RUN cd nextpnr && git fetch && git checkout nextpnr-0.7 && git submodule update --init --recursive

RUN ln -s /usr/share/fpga-icestorm/chipdb/ /usr/local/share/icebox

RUN cd nextpnr && mkdir build && cd build && cmake .. -DARCH=ice40

RUN ls /usr/local/share/icebox/

RUN cd nextpnr/build && make && make install

# Install cocotb
RUN apt-get install -y python3 python3-pip

# RUN pip3 install --upgrade pip

RUN pip3 install --no-cache-dir 'cocotb==1.9.1'

RUN pip3 install --no-cache-dir cocotb-test cocotb-bus cocotbext-axi gitpython

# Install pytest
RUN pip3 install --no-cache-dir pytest pytest-timeout

# RUN pip3 install jsonmerge
RUN pip3 install --no-cache-dir jsonmerge

# Cleanup!

RUN apt clean

RUN rm -rf verilator

RUN rm -rf get-pip.py

RUN rm -rf netlistsvg

RUN rm -rf iverilog

RUN rm -rf nextpnr

RUN rm -rf /tmp/tabby-linux-x64-latest.tgz

RUN rm -rf /tmp/tabbycad-acad-DustinRichmond-240911.lic

RUN apt -y remove emacs-nox npm

RUN apt-get -y install sudo
