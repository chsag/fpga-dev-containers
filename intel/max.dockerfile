ARG REPOSITORY
FROM $REPOSITORY/quartus

ARG QUARTUS_VERSION
ARG QUARTUS_PATCH
ARG QUARTUS_BUILD

# Install device support
RUN mkdir /tmp/device \
    && cd /tmp/device \
    && curl --location --progress-bar --remote-name \
        https://download.altera.com/akdlm/software/acdsinst/${QUARTUS_VERSION}std.${QUARTUS_PATCH}/${QUARTUS_BUILD}/ib_installers/max-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}.qdz \
    && unzip max-${QUARTUS_VERSION}.${QUARTUS_PATCH}.${QUARTUS_BUILD}.qdz \
    && mv ./quartus/common/devinfo/maxii /opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/common/devinfo/maxii \
    && mv ./quartus/common/devinfo/maxv /opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/common/devinfo/maxv \
    && rm -rf /tmp/device

# Precompile intel libraries
RUN /usr/local/lib/ghdl/vendors/compile-intel.sh \
    --altera \
    --vhdl2008 \
    --source /opt/intelFPGA_lite/${QUARTUS_VERSION}/quartus/eda/sim_lib \
    --output /usr/local/lib/ghdl/vendors/intel

# Install BSDL File Generation Tools
# RUN mkdir /tmp/bsdl_generator \
#     && cd /tmp/bsdl_generator \
#     && mkdir /opt/bsdl_generator \
#     && curl --location --silent --remote-name https://www.intel.com/content/dam/altera-www/global/en_US/others/support/devices/bsdl/MAXV/max_v_postbsdl_v1.zip \
#     && unzip max_v_postbsdl_v1.zip \
#     && mv max_v_postbsdl_v1.tcl /opt/bsdl_generator/bsdl_generator.tcl \
#     && chmod +x /opt/bsdl_generator/bsdl_generator.tcl \
#     && rm -rf /tmp/bsdl_generator