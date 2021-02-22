#!/usr/bin/python3
from subprocess import run
from glob import glob
from os import rename, remove
from os.path import exists
from shutil import copyfile
from pathlib import Path
from sys import argv

project_path = Path(glob('/work/*.qpf')[0])
settings_path = project_path.with_suffix('.qsf')

try:
    version_major, version_minor, version_revision = argv[1], argv[2], argv[3]
    print(f'Version {version_major}.{version_minor}.{version_revision}')

    copyfile(settings_path, settings_path.with_suffix('.tmp'))

    with open(settings_path, 'a') as settings_file:
        settings_file.write(f'\nset_parameter -name VERSION_MAJOR {version_major}')
        settings_file.write(f'\nset_parameter -name VERSION_MINOR {version_minor}')
        settings_file.write(f'\nset_parameter -name VERSION_VARIANT 1')
        settings_file.write(f'\nset_parameter -name VERSION_REVISION {version_revision}')

except IndexError:
    version_major = None
    version_minor = None
    version_revision =None

run([
    'quartus_sh',
    '--flow',
    'compile',
    str(project_path)
], check=True)

if exists(settings_path.with_suffix('.tmp')):
    remove(settings_path)
    rename(settings_path.with_suffix('.tmp'), settings_path)
