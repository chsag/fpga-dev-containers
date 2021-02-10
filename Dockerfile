FROM chriz2600/quartus-lite as quartus
FROM ghdl/vunit:gcc

RUN apt-get update && apt-get --yes install locales libtcmalloc-minimal4 libglib2.0-0 && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/adm /opt/intelFPGA_lite/20.1/quartus/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/bin /opt/intelFPGA_lite/20.1/quartus/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/common/devinfo/cyclone10lp /opt/intelFPGA_lite/20.1/quartus/common/devinfo/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/eda /opt/intelFPGA_lite/20.1/quartus/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/extlibs32 /opt/intelFPGA_lite/20.1/quartus/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/libraries /opt/intelFPGA_lite/20.1/quartus/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/linux64 /opt/intelFPGA_lite/20.1/quartus/
COPY --from=quartus /opt/intelFPGA_lite/20.1/quartus/lmf /opt/intelFPGA_lite/20.1/quartus/
