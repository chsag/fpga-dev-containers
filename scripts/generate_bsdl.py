#!/usr/bin/python3
from subprocess import run
from os import chdir, unlink
from shutil import copy
from glob import glob

device_bsdl = copy(glob('*.bsd')[0], '/work/output_files/')
chdir('/work/output_files')

run([
    'quartus_sh',
    '-t',
    '/opt/bsdl_generator/bsdl_generator.tcl'
], check=True)

unlink(device_bsdl)
