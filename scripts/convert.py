from glob import glob
from subprocess import run
from errno import EEXIST
from os import makedirs, replace
from sys import argv

src = glob('./src/**/*.vhd', recursive=True)
external = glob('./external/*/src/**/*.vhd', recursive=True)
primary = argv[1]

try:
    makedirs('ghdl_out')
except OSError as e:
    if e.errno != EEXIST:
        raise

options = [
    '--std=08',
    '--workdir=ghdl_out'
]

run(['ghdl', '-i'] + options + src + external)
run(['ghdl', '-m'] + options + [primary])

with open(f'./ghdl_out/{primary}.vhd', 'w') as output_file:
    output_file.write(run(['ghdl', '--synth', '--vendor-library=altera'] + options + [primary], capture_output=True).stdout.decode('utf-8'))

replace(primary, f'./ghdl_out/{primary}')
replace(f'e~{primary}.o', f'./ghdl_out/e~{primary}.o')
