FROM chriz2600/quartus-lite as quartus
FROM ghdl/vunit
COPY --from=quartus /usr/local/bin/quartus_wrapper /usr/local/bin
COPY --from=quartus /opt/intelFPGA_lite/20.1 /opt/intelFPGA_lite/20.1
