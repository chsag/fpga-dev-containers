FROM ubuntu:18.04

ARG GHDL_VERSION=1.0.0
ARG VUNIT_VERSION=4.4.0
ARG QUARTUS_VERSION=20.1
ARG QUARTUS_PATCH=1
ARG QUARTUS_BUILD=720
ARG QUARTUS_DEVICE=cyclone10lp

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        gnat \
        libglib2.0-0 \
        libtcmalloc-minimal4 \
        locales \
        python3 \
        python3-pip \
        python3-setuptools \
        make \
        unzip \
        zlib1g-dev \
    && update-ca-certificates \
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

# Install ghdl
RUN mkdir /tmp/ghdl \
    && cd /tmp/ghdl \
    && curl --location --progress-bar --remote-name \
        https://github.com/ghdl/ghdl/archive/v${GHDL_VERSION}.zip \
    && unzip v${GHDL_VERSION}.zip \
    && cd ghdl-${GHDL_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/ghdl

# Install vunit
RUN pip3 install \
        wheel \
    && rm -rf ~/.cache

RUN pip3 install \
        vunit_hdl==${VUNIT_VERSION} \
    && rm -rf ~/.cache

# Install quartus
RUN mkdir /tmp/quartus \
    && cd /tmp/quartus \
    && curl --location --progress-bar --remote-name \
        https://download.altera.com/akdlm/software/acdsinst/${QUARTUS_VERSION}std.${QUARTUS_PATCH}/${QUARTUS_BUILD}/ib_installers/QuartusLiteSetup-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}-linux.run \
    && chmod +x QuartusLiteSetup-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}-linux.run \
    && ./QuartusLiteSetup-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}-linux.run \
        --mode unattended \
        --unattendedmodeui minimal \
        --installdir /opt/intelFPGA_lite/${QUARTUS_VERSION} \
        --disable-components quartus_help,modelsim_ase,modelsim_ae \
        --accept_eula 1 \
    && rm -rf /opt/intelFPGA_lite/${QUARTUS_VERSION}/nios2eds \
    && rm -rf /opt/intelFPGA_lite/${QUARTUS_VERSION}/ip \
    && rm -rf /tmp/quartus

# Work around (https://community.intel.com/t5/Intel-Quartus-Prime-Software/Quartus-failed-to-run-inside-Docker-Linux/m-p/241059/highlight/true#M54719)
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

# Install device support
RUN mkdir /tmp/device \
    && cd /tmp/device \
    && curl --location --progress-bar --remote-name \
        https://download.altera.com/akdlm/software/acdsinst/${QUARTUS_VERSION}std.${QUARTUS_PATCH}/${QUARTUS_BUILD}/ib_installers/${QUARTUS_DEVICE}-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}.qdz \
    && unzip ${QUARTUS_DEVICE}-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}.qdz \
    && mv ./quartus/common/devinfo/${QUARTUS_DEVICE} /opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/common/devinfo/${QUARTUS_DEVICE} \
    && rm -rf /tmp/device

# Precompile intel libraries
RUN /usr/local/lib/ghdl/vendors/compile-intel.sh \
        --altera \
        --vhdl2008 \
        --source /opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/eda/sim_lib \
        --output /usr/local/lib/ghdl/vendors/intel

ENV PATH=$PATH:/opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/bin
