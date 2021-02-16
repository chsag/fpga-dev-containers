#!/usr/bin/python3
from subprocess import run
from glob import glob

run([
    '/opt/intelFPGA_lite/20.1/quartus/bin/quartus_sh',
    '--flow',
    'compile',
    glob('/work/*.qpf')[0]
], check=True)
