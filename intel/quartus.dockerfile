ARG REPOSITORY
FROM $REPOSITORY/vunit

ARG QUARTUS_VERSION
ARG QUARTUS_PATCH
ARG QUARTUS_BUILD

# Install quartus
RUN mkdir /tmp/quartus \
    && cd /tmp/quartus \
    && curl --location --progress-bar --remote-name \
        https://download.intel.com/akdlm/software/acdsinst/${QUARTUS_VERSION}std.${QUARTUS_PATCH}/${QUARTUS_BUILD}/ib_installers/QuartusLiteSetup-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}-linux.run \
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

ENV PATH=$PATH:/opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/bin