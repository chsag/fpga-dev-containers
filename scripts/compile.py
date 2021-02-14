#!/usr/bin/python3
from subprocess import run
from glob import glob

run([
    'quartus_sh',
    '--flow',
    'compile',
    glob('/work/*.qpf')[0]
])

# run([
#     'quartus_map',
#     '--read_settings_files=on',
#     '--write_settings_files=off',
#     'high_voltage_generator',
#     '-c',
#     'high_voltage_generator'
# ])
