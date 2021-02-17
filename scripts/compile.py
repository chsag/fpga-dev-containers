#!/usr/bin/python3
from subprocess import run
from glob import glob
from os import rename, remove, getenv
from os.path import exists
from shutil import copyfile
from pathlib import Path
from re import search

project_path = Path(glob('/work/*.qpf')[0])
settings_path = project_path.with_suffix('.qsf')

ref = getenv('Build.SourceBranch', '')

try:
    version_major, version_minor, version_revision = search(r'v(\d+)\.(\d+)\.(\d+)', ref).groups()

    copyfile(settings_path, settings_path.with_suffix('.tmp'))

    with open(settings_path, 'a') as settings_file:
        settings_file.write(f'\nset_parameter -name VERSION_MAJOR {version_major}')
        settings_file.write(f'\nset_parameter -name VERSION_MINOR {version_minor}')
        settings_file.write(f'\nset_parameter -name VERSION_VARIANT 1')
        settings_file.write(f'\nset_parameter -name VERSION_REVISION {version_revision}')

except AttributeError:
    pass

run([
    '/opt/intelFPGA_lite/20.1/quartus/bin/quartus_sh',
    '--flow',
    'compile',
    str(project_path)
], check=True)

if exists(settings_path.with_suffix('.tmp')):
    remove(settings_path)
    rename(settings_path.with_suffix('.tmp'), settings_path)
