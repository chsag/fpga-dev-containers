#!/usr/bin/python3
from glob import glob
from subprocess import CalledProcessError, run, PIPE
from errno import EEXIST
from os import makedirs, replace
from pathlib import Path
from re import findall

project_path = Path(glob('/work/*.qpf')[0])
settings_path = project_path.with_suffix('.qsf')
primary = project_path.stem

src = None
with open(settings_path) as settings_file:
    src = findall(r'set_global_assignment -name VHDL_FILE "?(.*\.vhd)"?', settings_file.read())

try:
    makedirs('ghdl_out')
except OSError as e:
    if e.errno != EEXIST:
        raise

options = [
    '--std=08',
    '--workdir=ghdl_out',
    '-fsynopsys'
]

try:
    run(['ghdl', '-i', '-P/usr/local/lib/ghdl/vendors/intel'] + options + src, stdout=PIPE, stderr=PIPE, check=True)
    run(['ghdl', '-m', '-P/usr/local/lib/ghdl/vendors/intel'] + options + [primary], stdout=PIPE, stderr=PIPE, check=True)
except CalledProcessError as e:
    print(e.stderr.decode('utf-8'))
    exit(e.returncode)

with open(f'./ghdl_out/{primary}.vhd', 'w') as output_file:
    try:
        p = run(['ghdl', '--synth', '--vendor-library=altera_mf'] + options + [primary], stdout=PIPE, stderr=PIPE, check=True)
        output_file.write(p.stdout.decode('utf-8'))
    except CalledProcessError as e:
        print(e.stderr.decode('utf-8'))
        exit(e.returncode)

replace(primary, f'./ghdl_out/{primary}')
replace(f'e~{primary}.o', f'./ghdl_out/e~{primary}.o')
