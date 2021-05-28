#!/usr/bin/python3
from subprocess import run
from os import chdir, unlink, rename
from shutil import copy
from glob import glob
from pathlib import Path

project_path = Path(glob('/work/*.qpf')[0])
primary = project_path.stem

device_bsdl_path = Path(copy(glob('/work/*.bsd')[0], '/work/output_files/'))
chdir('/work/output_files')

run([
    'quartus_sh',
    '-t',
    '/opt/bsdl_generator/bsdl_generator.tcl'
], check=True)

unlink(device_bsdl_path)
rename(device_bsdl_path.with_name(f'post{device_bsdl_path.name}'), device_bsdl_path.with_name(f'{primary}.bsd'))
