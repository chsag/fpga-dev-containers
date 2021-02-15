FROM debian:jessie-backports as quartus

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list && \
    echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list && \
    sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until \"false\";" > /etc/apt/apt.conf.d/100disablechecks && \
    apt-get update && apt-get -y install curl libtcmalloc-minimal4 libglib2.0-0

RUN mkdir /tmp/quartus && \
    cd /tmp/quartus && \
    curl -L -o quartus.run https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_installers/QuartusLiteSetup-20.1.1.720-linux.run && \
    chmod +x ./quartus.run && \
    ./quartus.run --mode unattended --installdir /opt/intelFPGA_lite/20.1 --disable-components quartus_help,modelsim_ase,modelsim_ae --accept_eula 1 && \
    rm -rf /opt/intelFPGA_lite/20.1/nios2eds && \
    rm -rf /opt/intelFPGA_lite/20.1/ip

FROM ghdl/vunit:gcc

RUN apt-get update && apt-get -y install locales

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

COPY --from=quartus /opt/intelFPGA_lite/20.1 /opt/intelFPGA_lite/20.1
COPY --from=quartus /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so.4

ENV LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4
