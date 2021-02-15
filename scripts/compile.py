#!/usr/bin/python3
from subprocess import run
from glob import glob

run([
    '/opt/intelFPGA_lite/20.1/quartus/bin/quartus_sh',
    '--flow',
    'compile',
    glob('/work/*.qpf')[0]
])

# run([
#     '/opt/intelFPGA_lite/20.1/quartus/bin/quartus_map',
#     '--read_settings_files=on',
#     '--write_settings_files=off',
#     'high_voltage_generator',
#     '-c',
#     'high_voltage_generator'
# ])
