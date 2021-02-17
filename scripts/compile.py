#!/usr/bin/python3
from subprocess import run
from glob import glob
from os import rename, remove, getenv
from shutil import copyfile
from pathlib import Path

project_path = Path(glob('/work/*.qpf')[0])
settings_path = project_path.with_suffix('.qsf')

env = [
    'VERSION_MAJOR',
    'VERSION_MINOR',
    'VERSION_VARIANT',
    'VERSION_REVISION'
]

copyfile(settings_path, settings_path.with_suffix('.tmp'))

with open(settings_path, 'a') as settings_file:
    def inject_env(name, f):
        value = getenv(name)

        if value == None:
            return

        f.write(f'\nset_parameter -name {name} {value}')

    for name in env:
        inject_env(name, settings_file)

run([
    '/opt/intelFPGA_lite/20.1/quartus/bin/quartus_sh',
    '--flow',
    'compile',
    str(project_path)
], check=True)

remove(settings_path)
rename(settings_path.with_suffix('.tmp'), settings_path)
