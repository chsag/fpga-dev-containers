from glob import glob
from subprocess import run
from errno import EEXIST
from os import makedirs, replace
from os.path import exists
from sys import argv
from itertools import chain
from glob import iglob
from pathlib import Path

primary = argv[1]

src = []
for src_file in chain(
    iglob('./src/**/*.vhd', recursive=True),
    iglob('./external/**/src/**/*.vhd', recursive=True)
):
    try:
        next(f for f in src if Path(f).stem == Path(src_file).stem)
    except StopIteration:
        src.append(src_file)

try:
    makedirs('ghdl_out')
except OSError as e:
    if e.errno != EEXIST:
        raise

options = [
    '--std=08',
    '--workdir=ghdl_out',
    '-Paltera',
    '-fsynopsys'
]

if not exists('./altera'):
    run([
        '/usr/local/lib/ghdl/vendors/compile-altera.sh',
        '--source', '/quartus/eda/sim_lib',
        '--vhdl2008',
        '--altera'
    ], check=True)

run(['ghdl', '-i'] + options + src, check=True)
run(['ghdl', '-m'] + options + [primary], check=True)

with open(f'./ghdl_out/{primary}.vhd', 'w') as output_file:
    p = run(['ghdl', '--synth'] + options + [primary], capture_output=True)
    output_file.write(p.stdout.decode('utf-8'))
    print(p.stderr.decode('utf-8'))

replace(primary, f'./ghdl_out/{primary}')
replace(f'e~{primary}.o', f'./ghdl_out/e~{primary}.o')
