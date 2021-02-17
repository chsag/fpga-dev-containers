#!/usr/bin/python3
from subprocess import run
from glob import glob
from os import rename, makedirs, remove, getenv
from os.path import exists
from shutil import copyfile
from pathlib import Path
from re import search

project_path = Path(glob('/work/*.qpf')[0])
settings_path = project_path.with_suffix('.qsf')

ref = getenv('Build.SourceBranch', '')

makedirs('build')

try:
    version_major, version_minor, version_revision, version_rc = search(r'v(\d+)\.(\d+)\.(\d+)_rc(\d+)', ref).groups()

    copyfile(settings_path, settings_path.with_suffix('.tmp'))

    with open(settings_path, 'a') as settings_file:
        settings_file.write(f'\nset_parameter -name VERSION_MAJOR {version_major}')
        settings_file.write(f'\nset_parameter -name VERSION_MINOR {version_minor}')
        settings_file.write(f'\nset_parameter -name VERSION_VARIANT 1')
        settings_file.write(f'\nset_parameter -name VERSION_REVISION {version_revision}')

except AttributeError:
    version_major = None
    version_minor = None
    version_revision =None
    version_rc = None

run([
    '/opt/intelFPGA_lite/20.1/quartus/bin/quartus_sh',
    '--flow',
    'compile',
    str(project_path)
], check=True)

if exists(settings_path.with_suffix('.tmp')):
    remove(settings_path)
    rename(settings_path.with_suffix('.tmp'), settings_path)

binary_path = Path(glob('/work/output_files/*.rbf')[0])

if version_major != None:
    rename(binary_path, f'/work/build/{binary_path.stem}_v{version_major}_{version_minor}_{version_revision}_rc_{version_rc}.rbf')
